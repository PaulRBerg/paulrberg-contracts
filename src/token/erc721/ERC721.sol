// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.13;

import { Address } from "@prb/contracts/utils/Address.sol";

import { IERC721 } from "./IERC721.sol";
import { IERC721Receiver } from "./IERC721Receiver.sol";

contract ERC721 is IERC721 {
    /*//////////////////////////////////////////////////////////////////////////
                                    PUBLIC STORAGE
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice The token collection name.
    string public name;

    /// @notice The token collection symbol.
    string public symbol;

    /*//////////////////////////////////////////////////////////////////////////
                                    INTERNAL STORAGE
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Internal mapping of balances.
    mapping(address => uint256) internal _balances;

    /// @dev Internal mapping of owners.
    mapping(uint256 => address) internal _owners;

    /// @dev Internal mapping of token approvals.
    mapping(uint256 => address) internal _tokenApprovals;

    /// @dev Internal mapping of operator approvals.
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    /*//////////////////////////////////////////////////////////////////////////
                                    CONSTRUCTOR
    //////////////////////////////////////////////////////////////////////////*/

    /// @param name_ ERC-721 name of this token.
    /// @param symbol_ ERC-721 symbol of this token.
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    /*//////////////////////////////////////////////////////////////////////////
                            PUBLIC CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IERC721
    function balanceOf(address owner) public view virtual returns (uint256) {
        if (owner == address(0)) {
            revert ERC721__BalanceOfZeroAddress();
        }

        return _balances[owner];
    }

    /// @inheritdoc IERC721
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];

        if (owner == address(0)) {
            revert ERC721__InvalidTokenId(tokenId);
        }

        return _tokenApprovals[tokenId];
    }

    /// @inheritdoc IERC721
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /// @inheritdoc IERC721
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];

        if (owner == address(0)) {
            revert ERC721__InvalidTokenId(tokenId);
        }

        return owner;
    }

    /// @dev Returns true if this contract implements the interface defined by
    /// `interfaceId`. See the corresponding
    /// https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
    /// to learn more about how these ids are created.
    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
    }

    /// @notice Returns the Uniform Resource Identifier (URI) for `tokenId` token.
    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {}

    /*//////////////////////////////////////////////////////////////////////////
                            PUBLIC NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IERC721
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);

        // Checks: `to` is not the actual owner.
        if (to == owner) {
            revert ERC721__ApproveCurrentOwner(owner);
        }

        // Checks: `msg.sender` is authorized.
        if (msg.sender != owner && !isApprovedForAll(owner, msg.sender)) {
            revert ERC721__UnauthorizedApprover(msg.sender);
        }

        // Effects:
        _approve(to, tokenId);
    }

    /// @inheritdoc IERC721
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /// @inheritdoc IERC721
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        _safeTransferFrom(from, to, tokenId, data);
    }

    /// @inheritdoc IERC721
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    /// @inheritdoc IERC721
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        _transferFrom(from, to, tokenId);
    }

    /*//////////////////////////////////////////////////////////////////////////
                            INTERNAL CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
    /// The call is not executed if the target address is not a contract.
    /// @param from The address that represents the previous owner of the given `tokenId`.
    /// @param to The target address that will receive the tokens.
    /// @param tokenId The ID of the token to be transferred.
    /// @param data The optional data to send along with the call.
    /// @return bool Whether the call correctly returned the expected magic value.
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal returns (bool) {
        if (Address.isContract(to)) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retVal) {
                return retVal == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert ERC721__NonERC721ReceiverImplementer();
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                            INTERNAL NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev See the documentation for the public functions that call this internal function.
    function _approve(address to, uint256 tokenId) internal virtual {
        // Effects: update the approval.
        _tokenApprovals[tokenId] = to;

        // Emit an event.
        emit Approval(_owners[tokenId], to, tokenId);
    }

    /// @notice Destroys `tokenId`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// The approval is cleared when the token is burned.
    ///
    /// Requirements:
    ///
    /// - `tokenId` must exist.
    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        // Effects: clear the approvals.
        _approve(address(0), tokenId);

        // Effects: burn the token.
        _balances[owner] -= 1;
        delete _owners[tokenId];

        // Emit an event.
        emit Transfer(owner, address(0), tokenId);
    }

    /// @notice Mints `tokenId` and transfers it to `to`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Usage of this method is discouraged, use {_safeMint} whenever possible.
    ///
    /// Requirements:
    ///
    /// - `to` cannot be the zero address.
    /// - `tokenId` must not exist.
    function _mint(address to, uint256 tokenId) internal virtual {
        // Checks: `to` is not the zero address.
        if (to == address(0)) {
            revert ERC721__MintZeroAddress();
        }

        // Checks: `tokenId` is already minted.
        if (_owners[tokenId] != address(0)) {
            revert ERC721__MintExistingToken(tokenId);
        }

        // Overflow is incredibly unrealistic.
        unchecked {
            _balances[to] += 1;
        }

        // Effects: mint the new token.
        _owners[tokenId] = to;

        // Emit an event.
        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Safely mints `tokenId` and transfers it to `to`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received},
    /// which is called upon a safe transfer.
    /// - `tokenId` must not exist.
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /// @dev Same as {_safeMint(address, uint256)} with an additional `data` parameter which is
    /// forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        if (!_checkOnERC721Received(address(0), to, tokenId, data)) {
            revert ERC721__NonERC721ReceiverImplementer();
        }
    }

    /// @dev See the documentation for the public functions that call this internal function.
    function _safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transferFrom(from, to, tokenId);
        if (!_checkOnERC721Received(from, to, tokenId, data)) {
            revert ERC721__NonERC721ReceiverImplementer();
        }
    }

    /// @dev See the documentation for the public functions that call this internal function.
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        // Checks: `operator` is not the actual owner.
        if (owner == operator) {
            revert ERC721__ApproveCurrentOwner(operator);
        }

        // Effects: update the operator approval.
        _operatorApprovals[owner][operator] = approved;

        // Emit an event.
        emit ApprovalForAll(owner, operator, approved);
    }

    /// @dev See the documentation for the public functions that call this internal function.
    function _transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        // Checks: `from` is the owner.
        if (from != ownerOf(tokenId)) {
            revert ERC721__TransferInvalidFrom(from);
        }

        // Checks: `to` is not the zero address.
        if (to == address(0)) {
            revert ERC721__TransferZeroAddress();
        }

        // Checks: `msg.sender` is authorized.
        if (msg.sender != from && !isApprovedForAll(from, msg.sender) && getApproved(tokenId) != msg.sender) {
            revert ERC721__UnauthorizedSender(msg.sender);
        }

        // Effects: Clear approvals from the previous owner.
        _approve(address(0), tokenId);

        // Underflow of the sender's balance is impossible because we check for
        // _ownership above and the recipient's balance can't realistically overflow.
        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }

        // Effects: update the new owner.
        _owners[tokenId] = to;

        // Emit an event.
        emit Transfer(from, to, tokenId);
    }
}

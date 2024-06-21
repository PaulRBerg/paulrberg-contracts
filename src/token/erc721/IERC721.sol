// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.13;

/// @title IERC721
/// @author Andrei Vlad Brg
/// @notice Implementation for the ERC-721 standard.
interface IERC721 {
    /*//////////////////////////////////////////////////////////////////////////
                                    CUSTOM ERRORS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Emitted when the approved address is the current owner of the token.
    error ERC721__ApproveCurrentOwner(address owner);

    /// @notice Emitted when the owner is the zero address.
    error ERC721__BalanceOfZeroAddress();

    /// @notice Emitted when the token id does not exist.
    error ERC721__InvalidTokenId(uint256 tokenId);

    /// @notice Emitted when the token has been already minted.
    error ERC721__MintExistingToken(uint256 tokenId);

    /// @notice Emitted when the address to receive the token is the zero address.
    error ERC721__MintZeroAddress();

    /// @notice Emitted when the {IERC721Receiver-onERC721Received} method is not implemented by the recipient and
    /// when the returned value by `IERC721Receiver.onERC721Received.selector` is wrong.
    error ERC721__NonERC721ReceiverImplementer();

    /// @notice Emitted when sender is not the owner of the token.
    error ERC721__TransferInvalidFrom(address from);

    /// @notice Emitted when recipient is the zero address.
    error ERC721__TransferZeroAddress();

    /// @notice Emitted when the approver is neither the owner nor approved.
    error ERC721__UnauthorizedApprover(address approver);

    /// @notice Emitted when the sender is neither the owner nor approved.
    error ERC721__UnauthorizedSender(address sender);

    /*//////////////////////////////////////////////////////////////////////////
                                        EVENTS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Emitted when an approval happens.
    /// @param owner The address of the owner of the NFT.
    /// @param spender The address of the spender.
    /// @param tokenId The identifier for the NFT.
    event Approval(address indexed owner, address indexed spender, uint256 indexed tokenId);

    /// @notice Emitted when an enable or a disable to manage all of its assets happens.
    /// @param owner The address of the owner of the NFTs.
    /// @param operator The address of the operator of the NFTs.
    /// @param approved The boolean value that indicates wether is an enable or a disable.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /// @notice Emitted when a transfer happens.
    /// @param from The address sending the NFT.
    /// @param to The address receiving the NFT.
    /// @param tokenId The identifier for the NFT.
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /*//////////////////////////////////////////////////////////////////////////
                                    CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Returns the number of NFTs owned by `owner`.
    function balanceOf(address owner) external view returns (uint256);

    /// @notice Returns the approved address for the NFT, or the zero address if there is none.
    ///
    /// Requirements:
    ///
    /// - `tokenId` must exist.
    ///
    /// @param tokenId The NFT to find the approved address for.
    function getApproved(uint256 tokenId) external view returns (address);

    /// @notice Returns if the `operator` is allowed to manage all of the assets of `owner`.
    /// @param owner The address that owns the NFTs.
    /// @param operator The address that acts on behalf of the owner.
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /// @notice Returns the owner of the `tokenId` token.
    ///
    /// Requirements:
    ///
    /// - `tokenId` must exist.
    ///
    /// @param tokenId The identifier for the NFT.
    function ownerOf(uint256 tokenId) external view returns (address);

    /*//////////////////////////////////////////////////////////////////////////
                                NON-CONSTANT FUNCTIONS
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Change or reaffirm the approved address for a NFT.
    ///
    /// @dev Emits an {Approval} event.
    ///
    /// Requirements:
    ///
    /// - The caller must own the token or be an approved operator.
    /// - `tokenId` must exist.
    ///
    /// @param approved The new approved NFT controller.
    /// @param tokenId The NFT to approve.
    function approve(address approved, uint256 tokenId) external;

    /// @notice Safely transfers `tokenId` token from `from` to `to`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - `from` cannot be the zero address.
    /// - `to` cannot be the zero address.
    /// - `tokenId` token must exist and be owned by `from`.
    /// - If the caller is not `from`,
    /// it must be approved to move this token by either {approve} or {setApprovalForAll}.
    /// - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received},
    /// which is called upon a safe transfer.
    ///
    /// @param from The current owner of the NFT.
    /// @param to The new owner.
    /// @param tokenId The NFT to transfer.
    /// @param data Additional data with no specified format, sent in call to `to`.
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /// @notice Safely transfers `tokenId` token from `from` to `to`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - `from` cannot be the zero address.
    /// - `to` cannot be the zero address.
    /// - `tokenId` token must exist and be owned by `from`.
    /// - If the caller is not `from`,
    /// it must be approved to move this token by either {approve} or {setApprovalForAll}.
    /// - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received},
    /// which is called upon a safe transfer.
    ///
    /// @param from The current owner of the NFT.
    /// @param to The new owner.
    /// @param tokenId The NFT to transfer.
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /// @notice Enable or disable approval for a third party ("operator") to manage
    ///  all of `msg.sender`'s assets.
    ///
    /// @dev Emits an {ApprovalForAll} event.
    ///
    /// Requirements:
    ///
    /// - The `operator` cannot be the caller.
    ///
    /// @param operator Address to add to the set of authorized operators.
    /// @param approved True if the operator is approved, false to revoke approval.
    function setApprovalForAll(address operator, bool approved) external;

    /// @notice Safely transfers `tokenId` token from `from` to `to`.
    ///
    /// @dev Emits a {Transfer} event.
    ///
    /// Requirements:
    ///
    /// - `from` cannot be the zero address.
    /// - `to` cannot be the zero address.
    /// - `tokenId` token must exist and be owned by `from`.
    /// - If the caller is not `from`,
    /// it must be approved to move this token by either {approve} or {setApprovalForAll}.
    ///
    /// @param from The current owner of the NFT.
    /// @param to The new owner.
    /// @param tokenId The NFT to transfer.
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}

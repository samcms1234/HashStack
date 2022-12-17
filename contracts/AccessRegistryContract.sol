// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./MultiSignatureWallet.sol";

contract AccessRegistryContract {
    address owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can call this function");
        _;
    }


    address[] public owners;
    mapping(address => bool) public isOwner;

    MultiSignatureWallet multiSignatureWallet;

    constructor(address[] memory _owners) {

        owner = msg.sender;
        
        require( _owners.length > 2 , "owners required");

        for(uint i; i < _owners.length; i++ ) {

            address _owner;

            _owner = _owners[i];

            require(_owner != address(0), "Invalid owner");
            require(!isOwner[_owner], "owner is not unique");

            owners.push(_owner);
            isOwner[_owners[i]] = true;
        }

        multiSignatureWallet = new MultiSignatureWallet(_owners, owner);
    }

    function addingSignatories(address _owner) private onlyOwner {
        multiSignatureWallet.addingSignatoryRights(_owner);
    } 

    function revokingSignatories(address _owner) private onlyOwner {
        multiSignatureWallet.revokeSignatoryRights(_owner);
    }
    
    function renounceSignatoryRights() private onlyOwner {
        multiSignatureWallet.revokeSignatoryRights(owner);
    }

    function transferSignatoryRights(address _oldSigner, address _newSigner) private onlyOwner {
        require(_oldSigner != _newSigner, "Both the signer must not be same");
        revokingSignatories(_oldSigner);
        addingSignatories(_newSigner);
    }

}
// SPDX-License-Identifier: MIT

pragma ^0.8.0;

import 'MultiSignatureWallet';

contract AccessRegistryContract {
    address payable owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender);
        _;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;




}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract MultiSignatureWallet {
    event Deposit(address indexed sender, uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner, uint indexed txId);
    event Revoke(address indexed owner, uint indexed txId);
    event Execute(uint indexed txId);

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
    }

    function getAddress() public view returns(address) {
        return address(this);
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier Onlyroot() {
        require(msg.sender == root, "Only root user can call this function");
        _;
    }

    modifier txExists(uint _txId) {
        require(_txId < transactions.length, "tx does not exist");
        _;
    }

    modifier notApproved(uint _txId) {
        require(!approved[_txId][msg.sender], "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(!transactions[_txId].executed, "tx already executed");
        _;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;
    uint public required;
    address public root;

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approved;

    constructor(address[] memory _owners, address _root) {
        require( _owners.length > 2 , "owners required");

        required = _owners.length * 3 / 5;

        for(uint i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);

        }

        root = _root;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function submit(address _to, uint _value, bytes calldata _data)
    external 
    onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false

        }));

        emit Submit(transactions.length - 1);
    }

    function approve(uint _txId)
        external
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId) 
    {
        approved[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns (uint count) {
        for(uint i; i < owners.length; i++) {
            if(approved[_txId][owners[i]]) {
                count ++;
            }
        }
    }

    function execute(uint _txId) external txExists(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals < required");
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;

        (bool success, ) = transaction.to.call{ value: transaction.value }(
            transaction.data
        );

        require(success, "transaction failed");

        emit Execute(_txId);
    }

    function revoke(uint _txId)
    external
    onlyOwner
    txExists(_txId)
    notExecuted(_txId) {
        require(approved[_txId][msg.sender], "tx not approved");
        approved[_txId][msg.sender] = false;

        emit Revoke(msg.sender, _txId);
    }

    function revokeSignatoryRights(address _owner)
    external
    Onlyroot {
        require(isOwner[_owner], "Not a owner");

        uint index;
        for(uint i; i < owners.length; i++) {
            if(owners[i] == _owner) {
                index = i;
                break;
            }
        }

        for(uint i = index ; i < owners.length - 1 ; i ++ ) {
            owners[i] = owners[i+1];
        }

        owners.pop();

        isOwner[_owner] = false;
    }

    function addingSignatoryRights(address _owner)
    external
    Onlyroot {
        require(!isOwner[_owner], "the owner already exists");

        owners.push(_owner);
        isOwner[_owner] = true;
    }

}
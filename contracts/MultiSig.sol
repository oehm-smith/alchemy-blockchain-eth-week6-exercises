// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract MultiSig {
    address[] public owners;
    uint256 public required;

    constructor(address[] memory _owners, uint256 _required){
        for (uint i=0; i < _owners.length; ++i) {
            owners.push(_owners[i]);
        }
        required=_required;
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract MultiSig {
    address[] public owners;
    uint256 public required;

    constructor(address[] memory _owners, uint256 _required){
        require(_owners.length > 0, "Must have at least one owner");
        require(_required > 0, "Must have at least one requirer");
        require(_required <= _owners.length, "Cant have more requirers than owners");
        for (uint i=0; i < _owners.length; ++i) {
            owners.push(_owners[i]);
        }
        required=_required;
    }
}

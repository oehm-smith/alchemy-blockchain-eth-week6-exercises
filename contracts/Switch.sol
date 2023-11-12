// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Switch {
    address payable eventualRecipient;
    address owner;
    uint lastUpdated;

    constructor(address payable _eventualRecipient) payable {
        eventualRecipient = _eventualRecipient;
        owner = msg.sender;
        lastUpdated = block.timestamp;
    }

    function withdraw() external {
        uint weeksDiff = (block.timestamp - lastUpdated) / 60 / 60 / 24 / 7;
        require(weeksDiff >= 52, "Cannot withdraw until 52 of no owner response");
        (bool success, ) = eventualRecipient.call{ value: address(this).balance }("");
        require(success, "eR failure");
    }

    function ping() external {
        require(msg.sender == owner, "Only owner can ping");
        lastUpdated = block.timestamp;
    }
}

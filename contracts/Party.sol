// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Party {
    uint256 depositRequired;
    mapping(address => bool) rsvps;
    address [] rsvps_array;
    constructor (uint256 _depositRequired) {
        depositRequired = _depositRequired;
    }
    function rsvp() external payable {
        require(msg.value == depositRequired, "Must pay exact deposit to join party");
        require(rsvps [msg.sender] != true, "Cannot join party more than once");
        rsvps [msg.sender] = true;
        rsvps_array.push (msg.sender);
        // I believe that because it is external payable, any msg.value (the rsvp'er sends) will be added to contract balance
    }

    function payBill(address payable _venue, uint _bill) external {
        (bool success1,) = _venue.call{value: _bill}("");
        require(success1, "Error refunding portion to RSVPer");
        // this will auto-deduct from this. balance
        uint refund = address(this) .balance / rsvps_array.length;
        for (uint i = 0; i < rsvps_array.length; ++i) {
            (bool success,) = rsvps_array[i].call{value: refund} ('');
            // this will auto-deduct from this.balance
            require(success, "Error refunding portion to RSVPer");
        }
    }
}

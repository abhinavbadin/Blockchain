//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
contract Blood{
    
        address whoDonated;
        uint donated;
        //enum
    
    mapping(address => bool) alreadyUser;

    /*function whoDonated() public{
        if(alreadyUser[msg.sender]==true)
        //function 
    }*/
    
        uint ReceiverId;
        uint  received;
    
    function Donate() public payable{
        donated=msg.value;

    }
    function Receive() public payable{
       received= msg.value;
    }

}
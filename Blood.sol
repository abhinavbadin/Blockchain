pragma solidity >=0.4.22 <=0.6.0;
contract Blood{
    
        address whoDonated;
        uint donated;
        enum
    
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
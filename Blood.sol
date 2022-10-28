pragma solidity >=0.4.22 <=0.6.0;
contract Blood{
    
        address whoDonated;
        uint donated;
        struct BloodGrps{
            uint apos;
            uint aneg;
            uint bpos;
            uint bneg;
            uint opos;
            uint oneg;
        }
        
    
    mapping(address => BloodGrps) bloodproj;
    /*function whoDonated() public{
        if(alreadyUser[msg.sender]==true)
        //function 
    }*/
    
        uint ReceiverId;
        uint  received;
    
    function Donate() public payable{
        donated=msg.value;

    }
    function availableBloodGrps(uint choice) public 
    {
          var group= bloodproj[msg.sender]; /*giving error*/
         if(choice>=1 && choice<=6)
         {
             if(choice==1)
             group.apos++;
             else if(choice==2)
             group.aneg++;
             else if(choice==3)
             group.bpos++;
             else if(choice==4)
             group.bneg++;
             else if(choice==5)
             group.opos++;
             else
             group.oneg++;

         }
    }
    function Receive() public payable{
       received= msg.value;
    }

}

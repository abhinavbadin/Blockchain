pragma solidity >=0.4.22 <=0.6.0;
contract Blood{
    
        address testingcenter;
        uint donated;
        struct BloodGrps{
            uint apos;
            uint aneg;
            uint bpos;
            uint bneg;
            uint opos;
            uint oneg;
        }
        /*mapping (address => bool) whoDonated;
        function register() public payable{
          whoDonated[msg.sender] = true;
        } */
    
        
        uint  received;
        uint age;
        bool smoke;
        bool drink;
        uint bmi;
        bool healthrisks;
        bool tattoo;
    
    function Donate() public payable{
        donated=msg.value;
        DonorValidity(age,smoke,drink,bmi,healthrisks,tattoo);

    }

    modifier onlyTestingCenter{
        require(msg.sender==testingcenter);
        _;
        

    }
    

    function DonorValidity(uint userAge,bool userSmoke,bool userDrink,uint userBmi,bool userhealthrisks,bool usertattoo) public returns(bool) {
        age=userAge;
        smoke=userSmoke;
        drink=userDrink;
        bmi=userBmi;
        healthrisks=userhealthrisks;
        tattoo=usertattoo;
        
        uint flag=0;
        if(age>=18)
        flag=1;
        if(smoke==false)
        flag=1;
        if(drink==false)
        flag=1;
        if(tattoo==false)
        flag=1;
        if(bmi>=18 && bmi<=24)
        flag=1;
        if(healthrisks==false)
        flag=1;
        if(flag==1)
        return true;
    }
    /*function availableBloodGrps(string ) public 
    {
          
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
    } */
    function Receive() public payable{
       received= msg.value;
    }

}

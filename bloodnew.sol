//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

//phase-1 only data
contract blood{
//blood groups must be added how? string array  or struct

    struct BloodGrps{
            uint apos;
            uint aneg;
            uint bpos;
            uint bneg;
            uint opos;
            uint oneg;
        }
    struct Donor{
        uint age;
        uint bmi;
        bool smoke;
        bool drink;
        bool healthrisks;
        bool tattoo;
        string bloodgroup;
    }
    struct Receiver
    {
        uint age;
    }
    address testingcentre;
    mapping(address=>bool) membership;
    mapping(address => Donor) Donors;
    mapping(address => Receiver) Receivers;
    //mapping(Donor.bloodgroup =>uint) bloodAvailability;

    modifier onlyTestingCenter{
        require(msg.sender==testingcentre);
        _;
        
    }

    modifier onlyMember{ 
        require(membership[msg.sender]==true);
        _;
    }
    // creating testing centre and registering him

    constructor() public{
        testingcentre=msg.sender;
        membership[msg.sender]=true;
    }
    //writing functions

    //1.get donor details.
    function set_donor(address donor,uint age, uint bmi, bool smoke, bool drink,bool healthrisks,bool tattoo) public
    {
        Donors[donor].age=age;
        Donors[donor].bmi=bmi;
        Donors[donor].smoke=smoke;
        Donors[donor].drink=drink;
        Donors[donor].healthrisks=healthrisks;
        Donors[donor].tattoo=tattoo;
        //donor_eligible(donor);
    }

    //2. Register the donor.
    function donor_eligible(address donor) public {
        //checking if the ones adding is not testing centre and already eligible to donate
        if(msg.sender==testingcentre && membership[msg.sender]==true){
        if(Donors[donor].age >=18 && (Donors[donor].bmi>=18 && Donors[donor].bmi<=24) && Donors[donor].smoke==false && Donors[donor].drink==false && Donors[donor].tattoo==false &&  Donors[donor].healthrisks==false){
                membership[donor]=true;
        }
        else{
            //we cant add him
            membership[donor]=false;
            revert();
        } 
        }
        else{
            //direct donate web page must be shown
            revert();
        }
        
    }

    //3. Donate

    function donate() public{

    }
}
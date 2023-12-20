//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

//phase-1 only data
contract Blood{
//blood groups must be added how? string array  or struct
    struct BloodGroups
    {
        uint apos;
        uint aneg;
        uint bpos;
        uint bneg;
        uint opos;
        uint oneg;
        uint abpos;
        uint abneg;
    }
    struct Donor{
        uint age;
        uint bmi;
        bool smoke;
        bool drink;
        bool healthrisks;
        bool tattoo;
        string bloodgrp;
    }
    struct Receiver
    {
        string bloodgrp;
    }
    
    address testingcentre;
    mapping(address=>uint) donormembership;
    mapping(address=>uint) receivermembership;
    mapping(address => Donor) Donors;
    mapping(address => Receiver) Receivers;
    mapping(address => BloodGroups) BloodBank;
   

    // creating testing centre and registering him

    constructor() {
        testingcentre=msg.sender;
        donormembership[msg.sender]=1;
        receivermembership[msg.sender]=1;
        BloodBank[testingcentre].apos=0;
        BloodBank[testingcentre].aneg=0;
        BloodBank[testingcentre].bpos=0;
        BloodBank[testingcentre].bneg=0;
        BloodBank[testingcentre].abpos=0;
        BloodBank[testingcentre].abneg=0;
        BloodBank[testingcentre].opos=0;
        BloodBank[testingcentre].oneg=0;
    }
    //writing functions

/*---------------------------------------------DONOR-Functions------------------------------------------------------------*/
    
    //1. check membership
    function get_membership(address donor) public view returns(uint x)
    {
        if(donormembership[donor]==1)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
    //2.get donor details.
    function set_donor(address donor,uint age, uint bmi, bool smoke, bool drink,bool healthrisks,bool tattoo, string memory bloodgr) public
    {
        Donors[donor].age=age;
        Donors[donor].bmi=bmi;
        Donors[donor].smoke=smoke;
        Donors[donor].drink=drink;
        Donors[donor].healthrisks=healthrisks;
        Donors[donor].tattoo=tattoo;
        Donors[donor].bloodgrp=bloodgr;
        //donor_eligible(donor);
    }
    
    //3. Register the donor.
    function donor_eligible(address donor) public 
    {
        //checking if the ones adding is not testing centre and already eligible to donate
        if(Donors[donor].age >=18 && (Donors[donor].bmi>=18 && Donors[donor].bmi<=24) && Donors[donor].smoke==false && Donors[donor].drink==false && Donors[donor].tattoo==false &&  Donors[donor].healthrisks==false){
            donormembership[donor]=1;
        }
        else{
            //we cant add him
            donormembership[donor]=0;
            revert("Cant give membership. You didnt satisfy requirements");
        }  
    }
    
    
    //4. Donate
    function donate(address donor, uint value) public 
    {
        if(donormembership[msg.sender]==1)
        {
            string memory bloodcall=Donors[donor].bloodgrp;
            if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("A+"))))
            {
            BloodBank[testingcentre].apos+=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("A-"))))
            {
                BloodBank[testingcentre].aneg+=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("B+"))))
            {
                BloodBank[testingcentre].bpos+=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("B-"))))
            {
                BloodBank[testingcentre].bneg+=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("AB+"))))
            {
                BloodBank[testingcentre].abpos+=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("AB-"))))
            {
                BloodBank[testingcentre].abneg+=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("O+"))))
            {
                BloodBank[testingcentre].opos+=value;   
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("O-"))))
            {
                BloodBank[testingcentre].oneg+=value;
            }
        }
        else
        {
            revert("You dont have membership");
        }
    }

/*-----------------------------------------------RECEIVER-Functions--------------------------------------------------------*/

//1. set receiever details
function set_receiver(address recv, string memory bloodgr) public
{
    Receivers[recv].bloodgrp=bloodgr;
    //set the membership
    receivermembership[recv]=1;
    //get_reqblooddetails(Receivers[recv].bloodgrp);
}

// To get req blood group blood details in the blood bank.
function get_reqblooddetails(string memory blreq) public view returns(uint x)
{
        if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("A+")))){
            return BloodBank[testingcentre].apos;
        }
        else if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("A-"))))
        {
            return BloodBank[testingcentre].aneg;
        }
        else if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("B+"))))
        {
            return BloodBank[testingcentre].bpos;
        }
        else if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("B-"))))
        {
            return BloodBank[testingcentre].bneg;
        }
        else if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("AB+"))))
        {
            return BloodBank[testingcentre].abpos;
        }
        else if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("AB-"))))
        {
            return BloodBank[testingcentre].abneg;
        }
        else if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("O+"))))
        {
            return BloodBank[testingcentre].opos;   
        }
        else if(keccak256(abi.encodePacked((blreq))) == keccak256(abi.encodePacked(("O-"))))
        {
            return BloodBank[testingcentre].oneg;
        }
}

// To get receivers blood group.
function get_recvBlood(address recv) public view returns(string memory)
{
    return Receivers[recv].bloodgrp;
}
//2. Receive blood and decrement it from blood bank
function rec(address recv,uint value) public 
{
        if(receivermembership[msg.sender]==1)
        {
            string memory bloodcall=Receivers[recv].bloodgrp;
            if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("A+"))))
            {
                BloodBank[testingcentre].apos-=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("A-"))))
            {
                BloodBank[testingcentre].aneg-=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("B+"))))
            {
                BloodBank[testingcentre].bpos-=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("B-"))))
            {
                BloodBank[testingcentre].bneg-=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("AB+"))))
            {
                BloodBank[testingcentre].abpos-=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("AB-"))))
            {
                BloodBank[testingcentre].abneg-=value;
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("O+"))))
            {
                BloodBank[testingcentre].opos-=value;   
            }
            else if(keccak256(abi.encodePacked((bloodcall))) == keccak256(abi.encodePacked(("O-"))))
            {
                BloodBank[testingcentre].oneg-=value;
            }
        }
        else
        {
            revert("You dont have membership");
        }   
}

}

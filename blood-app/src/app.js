App = {
    web3Provider: null,
    contracts: {},
    //names: new Array(),
    url: 'http://127.0.0.1:7545',
    testingAgency:null,
    currentAccount:null,
    userAccount:null,
    init: function() {
      return App.initWeb3();
    },
  
    initWeb3: function() {
          // Is there is an injected web3 instance?
      if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider;
      } else {
        // If no injected web3 instance is detected, fallback to the TestRPC
        App.web3Provider = new Web3.providers.HttpProvider(App.url);
      }
      web3 = new Web3(App.web3Provider);
  
      ethereum.enable();
      web3.eth.handleRevert=true;
      
      return App.initContract();
    },
  
    initContract: function() {
        $.getJSON('Blood.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var bloodArtifact = data;
      App.contracts.blood = TruffleContract(bloodArtifact);
  
      // Set the provider for our contract
      App.contracts.blood.setProvider(App.web3Provider);
      
     

      App.gettestingAgency();
      App.populateAddress();
     return App.bindEvents();
    });
    },
  
    bindEvents: function() {
      $(document).on('click', '#donor', function(){App.handleDonor(App.userAccount)});
      $(document).on('click','#formsubmit',App.handleDonorForm);
      $(document).on('click','#finalSubmit',App.handleDonorBloodSubmit);
      $(document).on('click', '#receiver', App.handleReceiver);
      $(document).on('click','#receiverformsubmit',App.handleReceiverForm);
      $(document).on('click','#getquantity',function(){App.handleBloodquantity(App.userAccount)}); 
      $(document).on('click','#ReceiverSubmit',App.handleFinalReceive);
      
    },
  
    gettestingAgency : function(){
      new Web3(new Web3.providers.HttpProvider(App.url)).eth.getAccounts((err, accounts) => {
        web3.eth.defaultAccount=web3.eth.accounts[0]
        console.log(accounts);
        App.testingAgency=accounts[0];
        console.log("testing agency address is"+App.testingAgency);
      });
    },
    populateAddress : async function(){
        const accounts= await ethereum.request({method : 'eth_requestAccounts'});
        App.userAccount=accounts[0];
        console.log("User address is"+App.userAccount);
        console.log(typeof App.userAccount);
    },
     
    //Initial Donor click button handling. If there is membership then direct donate else donor form.
    handleDonor : function(addr) {
      console.log("to check membership");
      var donorInstance;
      App.contracts.blood.deployed().then(function(instance) {
        donorInstance = instance;
        console.log(donorInstance);
        return donorInstance.get_membership(addr,{from:App.userAccount,gas:'1000000'});
      }).then(function(res,err){
        console.log(res);
        let stat=res.words[0];
        if(stat==1)
        {
          alert("Taking you to donation page")
          window.location.href="donate.html"
        }
        else
        {
          alert("you Dont have membership please fill the form to get started.")
          window.location.href="donorform.html"
        }
      }).catch(function(err){
        console.log(err.message);
      })
    },

    handleDonorForm: function(){
      console.log("handling form");
      let age=document.getElementById("age").value;
      console.log(age);
      let smoke=document.getElementById("smoke").value;
      smoke=changetoBOOL(smoke);
      console.log(smoke);
      let drink=document.getElementById("drink").value;
      drink=changetoBOOL(drink);
      console.log(drink);
      let tattoo=document.getElementById("tattoo").value;
      tattoo=changetoBOOL(tattoo);
      console.log(tattoo);
      let bmi=document.getElementById("BMI").value;
      console.log(bmi);
      let healthissues=document.getElementById("issues").value;
      healthissues=changetoBOOL(healthissues);
      console.log(healthissues);
      let bldgrp=document.getElementById("grp").value;
      console.log(bldgrp);
      function changetoBOOL(x){
        if(x=="yes")
        {
          return true
        }
        else{
          return false
        }
      }
      //calling contract
      var donorInstance;
      App.contracts.blood.deployed().then(function(instance) {
        donorInstance = instance;
        return donorInstance.set_donor(App.userAccount,age,bmi,smoke,drink,healthissues,tattoo,bldgrp,{from:App.userAccount, gas:'1000000'});
      }).then(function(res){
      console.log(res);
      if(res){
        console.log(res.receipt.status);
        alert("donor details are set. Only checking eligibilty is remaining.!!!!!!please wait");
        App.handleDonorEligibility(App.userAccount);
        //return donorInstance.donor_eligible(App.userAccount,{from:App.testingAgency}); 
    } else {
        alert(account + " donation failed. dont know why i am here check")
    }   
        // alert(App.userAccount + "  membership is shown ! :)");
      }).catch(function(err){
        console.log(err.message);
      })

    },
    handleDonorEligibility: function(acc){
      console.log("check eligibility")
      var donorInstance;
      App.contracts.blood.deployed().then(function(instance) {
      donorInstance = instance;
      console.log(acc)
      return donorInstance.donor_eligible(acc,{from:App.userAccount,gas:'1000000'});
      }).then(function(res){
      console.log(res);
      if(res){
        console.log(res.receipt.status);
        window.location.href="donate.html"
        alert(App.userAccount + " you are verfied taking you to donation page")
    } else {
        alert(account + " donation failed. dont know why i am here check")
    }   
        // alert(App.userAccount + "  membership is shown ! :)");
      }).catch(function(err){
        console.log(err.message);
        alert("You dont satisfy requirements");
        window.location.href="index.html"
      })
    },

    handleDonorBloodSubmit: function(){
      let quantity=document.getElementById("quantity").value;
      console.log(quantity);

      var donorInstance;
      App.contracts.blood.deployed().then(function(instance) {
        donorInstance = instance;
        return  donorInstance.donate(App.userAccount,quantity,{from:App.userAccount, gas:'1000000'});
      }).then(function(res,err){
      console.log(res);
      if(res){
        alert(App.userAccount + " Thanks for submitting the blood")
        window.location.href="index.html"
    } else {
        alert(App.userAccount + " donation failed. dont know why i am here check")
    }   
        // alert(App.userAccount + "  membership is shown ! :)");
      }).catch(function(err){
        console.log(err.message);
        alert("Sorry server down cant donate this time. Please try again later")
        window.location.href="index.html"

      })

    },


    // Receiver Functions
    handleReceiver: function(){
      window.location.href="receiverform.html"
    },

    handleReceiverForm: function(){
      console.log("checking receiver membership")
      let bldgrp=document.getElementById("needed").value;
      console.log(bldgrp);

      var receiverInstance;
      App.contracts.blood.deployed().then(function(instance) {
        receiverInstance = instance;
        console.log(receiverInstance);
        receiverInstance.set_receiver(App.userAccount,bldgrp,{from:App.userAccount, gas:'1000000'})
        return receiverInstance.get_reqblooddetails(bldgrp,{from:App.userAccount, gas:'1000000'});
      }).then(function(res){
      console.log(res)
      console.log(res.words[0])// get blood count available
      bloodcnt=res.words[0]
      if(bloodcnt==0)
      {
        alert("Your blood group is not available. Waiting for someone to donate. Please try again after sometime")
        window.location.href="index.html"
      }
      else
      {
        window.location.href="receive.html"
      }
      }).catch(function(err){
        console.log(err.message);
      })
    },

    handleBloodquantity: function(account){

      var receiverInstance;
      App.contracts.blood.deployed().then(function(instance) {
        receiverInstance = instance;
        console.log(receiverInstance)
        return receiverInstance.get_recvBlood(account,{from:App.userAccount, gas:'1000000'})
        //console.log(res)
        //return receiverInstance.get_reqblooddetails(bldgrp,{from:App.userAccount, gas:'1000000'});
      }).then(function(res){
      console.log(res)
      return receiverInstance.get_reqblooddetails(res,{from:App.userAccount,gas:'1000000'}).then(function(result){
        console.log(result)
        cnt=result.words[0]
        var htmlstr=""
        console.log(cnt)
        for(var i=cnt;i>0;i--)
        {
          htmlstr+="<option value='"+i+"'>"+i+"</option>\n"
        }
        console.log(htmlstr);
        jQuery('#required').append(htmlstr); 
      })
      }).catch(function(err){
        console.log(err.message);
      })
    },
    handleFinalReceive: function()
    { 
      let req=document.getElementById("required").value;
      console.log(req); 
      var receiverInstance;
      App.contracts.blood.deployed().then(function(instance) {
        receiverInstance = instance;
        return  receiverInstance.rec(App.userAccount,req,{from:App.userAccount, gas:'1000000'});
      }).then(function(res,err){
      console.log(res);
      if(res){
        console.log(res.receipt.status)
        window.location.href="index.html"
        alert(App.userAccount + "received successfully")
    } else {
        alert(account + " receive failed. dont know why i am here check")
    }   
      }).catch(function(err){
        console.log(err.message);
      }) 
    }
  };
  
$(function() {
    $(window).load(function() {
      App.init();
    });
  });
  
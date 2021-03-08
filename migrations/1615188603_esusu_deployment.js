
//  1. Ensure you have done truffle compile to ensure the contract ABI has been added to the artifact
const VenusAdapterContract = artifacts.require("VenusAdapter");
const VenusLendingServiceContract = artifacts.require("VenusLendingService");
const GroupsContract = artifacts.require('Groups');
const TreasuryContract = artifacts.require('Treasury');
const SavingsConfigContract = artifacts.require('SavingsConfig');
const XendTokenContract = artifacts.require('XendToken');
const EsusuServiceContract = artifacts.require('EsusuService');
const RewardConfigContract = artifacts.require('RewardConfig');
const EsusuAdapterContract = artifacts.require('EsusuAdapter');
const EsusuAdapterWithdrawalDelegateContract = artifacts.require('EsusuAdapterWithdrawalDelegate');
const EsusuStorageContract = artifacts.require('EsusuStorage');

module.exports = function (deployer) {

  console.log("********************** Running Esusu Migrations On Venus BSC *****************************");

  deployer.then(async () => {


     await deployer.deploy(GroupsContract);

     await deployer.deploy(TreasuryContract);

     await deployer.deploy(SavingsConfigContract);

     await deployer.deploy(VenusLendingServiceContract);

     await deployer.deploy(VenusAdapterContract,VenusLendingServiceContract.address);

     await deployer.deploy(XendTokenContract, "Xend Token", "$XEND","18","200000000000000000000000000");

     await deployer.deploy(EsusuServiceContract);

     await deployer.deploy(RewardConfigContract,EsusuServiceContract.address, GroupsContract.address);

     await deployer.deploy(EsusuStorageContract);

    //  address payable serviceContract, address esusuStorageContract, address esusuAdapterContract,
    //                 string memory feeRuleKey, address treasuryContract, address rewardConfigContract, address xendTokenContract

     await deployer.deploy(EsusuAdapterContract,
                            EsusuServiceContract.address,
                            GroupsContract.address,
                            EsusuStorageContract.address);

      await deployer.deploy(EsusuAdapterWithdrawalDelegateContract,
                              EsusuServiceContract.address,
                              EsusuStorageContract.address,
                              EsusuAdapterContract.address,
                              "esusufee",
                              TreasuryContract.address,
                              RewardConfigContract.address,
                              XendTokenContract.address,
                              SavingsConfigContract.address);

     console.log("Groups Contract address: "+GroupsContract.address);

     console.log("Treasury Contract address: "+TreasuryContract.address);

     console.log("SavingsConfig Contract address: "+SavingsConfigContract.address);

     console.log("Venus LendingService Contract address: " + VenusLendingServiceContract.address);

     console.log("Venus Adapter Contract address: "+VenusAdapterContract.address );

     console.log("XendToken Contract address: "+XendTokenContract.address );

     console.log("EsusuService Contract address: "+EsusuServiceContract.address );

     console.log("EsusuStorage Contract address: "+EsusuStorageContract.address );

     console.log("EsusuAdapterWithdrawalDelegate Contract address: "+EsusuAdapterWithdrawalDelegateContract.address );

     console.log("RewardConfig Contract address: "+RewardConfigContract.address );

     console.log("EsusuAdapter Contract address: "+EsusuAdapterContract.address );

     let venusAdapterContract = null;
     let venusLendingServiceContract = null;
     let savingsConfigContract = null;
     let esusuAdapterContract = null;
     let esusuServiceContract = null;
     let groupsContract = null;
     let xendTokenContract = null;
     let esusuAdapterWithdrawalDelegateContract = null;
     let esusuStorageContract = null;
     let rewardConfigContract = null;

     savingsConfigContract = await SavingsConfigContract.deployed();
     venusAdapterContract = await VenusAdapterContract.deployed();
     venusLendingServiceContract = await VenusLendingServiceContract.deployed();
     esusuAdapterContract = await EsusuAdapterContract.deployed();
     esusuServiceContract = await EsusuServiceContract.deployed();
     groupsContract = await GroupsContract.deployed();
     xendTokenContract = await XendTokenContract.deployed();
     esusuAdapterWithdrawalDelegateContract = await EsusuAdapterWithdrawalDelegateContract.deployed();
     esusuStorageContract = await EsusuStorageContract.deployed();
     rewardConfigContract = await RewardConfigContract.deployed();
 
  })

};

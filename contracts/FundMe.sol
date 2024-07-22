// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "./PriceConverter.sol";

error NotOwner();
contract FundMe{
    using PriceConverter for uint256;


   uint256 public constant MINIMUN_USD = 50 * 1e18;
   address[] private funders;
   mapping(address => uint256) private addressToAmountFunded;
   address private immutable i_owner;

    AggregatorV3Interface private priceFeed; 
   constructor(address priceFeedAddress) {
     i_owner = msg.sender;
     priceFeed = AggregatorV3Interface(priceFeedAddress);
   }

   modifier onlyOwner {

    //require(msg.sender == i_owner, "sender is not owner");
    if(msg.sender != i_owner){revert NotOwner();}
    _;
  }

  receive() external payable { 
    fund();
  }

  fallback() external payable {
    fund();
   }

   function fund() public payable {
       require(msg.value.getConversionRate(priceFeed) >= MINIMUN_USD, "Didn't send enough");
       funders.push(msg.sender);
       addressToAmountFunded[msg.sender] = msg.value;
   } 

  function withdraw() public onlyOwner{
    for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;
    }
    funders = new address[](0);
    (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
    require(callSuccess, "Call Failed");
  }

  function getOwner() public view returns(address){
    return i_owner;
  }
  function getFunder(uint256 index) public view returns(address){
    return funders[index];
  }

  function getAddressToAmountFunded(address funder) public view returns(uint256){
    return addressToAmountFunded[funder]; 
  }

  function getPriceFeed() public view returns(AggregatorV3Interface){
    return priceFeed;
  }
}
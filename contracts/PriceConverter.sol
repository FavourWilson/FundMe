// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import  "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
library PriceConverter {
     function getPrice(AggregatorV3Interface priceFeed) internal view returns(uint256){
        (,int256 answer,,,) = priceFeed.latestRoundData();

        return uint256(answer * 1e10);
   }

   function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns(uint256){
    uint256 ethPrice = getPrice(priceFeed);
    uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
    return  ethAmountInUSD;
   }
}
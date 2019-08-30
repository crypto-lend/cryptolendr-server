/**
* MIT License
*
* Copyright (c) 2019 Finocial
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

pragma solidity ^0.5.0;

import "./ProvableI.sol";

/**
*This contract gets the price from Given URL , and transform the price and sends its back to asking method
*Now we are using this contract when a collateral is claimed or sold, so its sold at the current price retrieved from
* market.
*/


contract PriceFeeder is usingProvable {

   bytes32 price;
   event LogPriceUpdated(string price);
   event LogNewProvableQuery(string description);


   function updatePrice(string memory _contractAddress) payable public returns(bytes32) {
     // We could check and validate contract address but as of now we have left it out.
     // We can do it like this ERC20 = IERC20(address);

       if (provable_getPrice("URL") > address(this).balance) {
           emit LogNewProvableQuery("Provable query was NOT sent, please add some ETH to cover for the query fee");
       } else {
          emit LogNewProvableQuery("Provable query was sent, standing by for the answer..");
           string memory url = strConcat("json(https://api.coingecko.com/api/v3/coins/ethereum/contract/", _contractAddress, ").market_data.current_price.usd");
           bytes32 value = provable_query("URL",url);
           price = value;
           return price;
       }
   }
}

pragma solidity 0.6.6;
// SPDX-License-Identifier: MIT
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";


contract FundMe {
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed;
    constructor (address _priceFeed) public {
    priceFeed = AggregatorV3Interface(_priceFeed);
    owner = msg.sender;
    // msg is whoever deploys the contract
    }
    function fund() public payable {
    uint256 minimumUSD = 50 * 10 ** 18;
    require(getConversionRate(msg.value) >= minimumUSD, 'you need to send $50 equivalent');
    addressToAmountFunded[msg.sender] += msg.value;
    funders.push(msg.sender);
    // payable means it can be used to pay for things
    // the button is red because its payable
    }
    function getVersion() public view returns(uint256) {

    return priceFeed.version();
    }

    function getPrice() public view returns(uint256) {

    (
    uint80 roundId,
    int256 answer,
    uint256 startedAt,
    uint256 updatedAt,
    uint80 answeredInRound
    ) = priceFeed.latestRoundData();
    // pricefeed.lastestround data has multiple returns, we can 
    // catch each return by storing them in variables listed out
    // in a touple 

    return uint256(answer * 10000000000);
    // answer is returned as a int256 but in our function definition, were
    // returning in format uint256.. so convert via type casting
    // answer is returned without the decimals, know it has 8 decimals 
    }
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
    uint256 ethPrice = getPrice();
    uint256 ethAmountInUsd = (ethPrice * ethAmount)/1000000000000000000;
    return ethAmountInUsd;
    }

    function getEntranceFee() public view returns (uint256){
        // minimum usd
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    
    }
    modifier onlyOwner {
    require(msg.sender == owner, "you do not have permisson to withdraw from this contract");
    _;
    }
    function withdraw() payable onlyOwner public {
    require(msg.sender == owner);
    // ensures that the address that calls withdraw has to be
    // the address that call the contract
    msg.sender.transfer(address(this).balance);
    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++){
    address funder = funders[funderIndex];
    addressToAmountFunded[funder] = 0;
    }

    funders = new address[](0);
    // this => refers to the contract you're currently in
    }
}

// Modifiers can be used instead of a constructur
// modifiers change the behaviour of a function in a declarative way

  
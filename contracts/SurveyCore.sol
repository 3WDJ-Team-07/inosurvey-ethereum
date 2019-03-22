pragma solidity ^0.5.0;

import "./SurveyRequest.sol";

contract SurveyCore is SurveyRequest {

    uint256 private constant INITIAL_AMOUNT = 1000000000000; // 발행량 1조
    
    constructor () public {
        paused = false;
        
        developerAddress = msg.sender;

        mint(msg.sender, INITIAL_AMOUNT);
    }
    
}
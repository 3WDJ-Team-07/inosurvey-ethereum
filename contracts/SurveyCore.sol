pragma solidity ^0.5.0;

import "./SurveyRequest.sol";

contract SurveyCore is SurveyRequest {

    constructor () public {
        paused = false;
        
        developerAddress = msg.sender;
    }
    
}
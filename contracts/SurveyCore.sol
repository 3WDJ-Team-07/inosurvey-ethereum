pragma solidity ^0.5.0;

import "./SurveyFoundation.sol";

contract SurveyCore is SurveyFoundation {
    
    constructor () public {
        paused = false;
        
        developerAddress = msg.sender;
    }
}
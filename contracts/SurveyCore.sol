pragma solidity ^0.5.0;

import "./SurveyFoundation.sol";

contract SurveyCore is SurveyFoundation {
    
    constructor () public {
        paused = false;
        
        developerAddress = msg.sender;
        mint(msg.sender, 1000000000000);

        // burning survey
        requestSurvey(0, now, 0);
        // burning foundation
        createFoundation(0, 0);
    }
}
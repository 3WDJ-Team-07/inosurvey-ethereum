pragma solidity ^0.5.0;

import "./SurveyFoundation.sol";

contract SurveyCore is SurveyFoundation {
    
    constructor () public {
        paused = false;
        
        developerAddress = msg.sender;
        mint(msg.sender, 1000000000000);

        // burning survey
        _createSurvey(0, 0, 0, 0, 0, 0, false);
        // burning foundation
        _createFoundation(0, 0, 0, 0, false);
    }
}
pragma solidity ^0.5.0;

import "./SurveyTokenInterface.sol";

contract SurveyAccessControl {
    /*** ADDRESSES ***/
    address public developerAddress;

    /*** CONTRACT ***/
    SurveyTokenInterface public token;


    /*** CONTRACT LIFECYCLE ***/
    bool public paused = false;

    modifier onlyDeveloper() {
        require(msg.sender == developerAddress, "Not Owner");
        _;
    }
    
    // set owner(developer)
    function setDeveloper(address _newDeveloperAddress) external onlyDeveloper {
        // address 0x0... 무시하기(악의적인 컨트랙트 burning 방지)
        require(_newDeveloperAddress != address(0), "Warning");
        developerAddress = _newDeveloperAddress;
    }

    //set tokenContract address
    function setTokenContractAddress(address _newContractAddress) external onlyDeveloper {
        require(_newContractAddress != address(0), "Warning");
        token = SurveyTokenInterface(_newContractAddress);
    }

    modifier whenNotPaused() {
        require(!paused, "already paused.");
        _;
    }

    modifier whenPuased() {
        require(paused, "not paused.");
        _;
    }

    function pause() external onlyDeveloper whenNotPaused {
        paused = true;
    }

    function unpause() external onlyDeveloper whenPuased {
        paused = false;
    }
}
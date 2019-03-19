pragma solidity ^0.5.0;

contract SurveyAccessControl {
    // owner address
    address public developer;

    //contract lifeCycle
    bool public paused = false;

    event ContractUpgrade(address newContract);

    modifier onlyDeveloper() {
        require(msg.sender == developer, "Not Owner");
        _;
    }
    
    // set owner
    function setOwner(address _newDeveloper) external onlyDeveloper {
        // address 0x0... 무시하기(악의적인 컨트랙트 burning 방지)
        require(_newDeveloper != address(0), "Warning");
        developer = _newDeveloper;
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
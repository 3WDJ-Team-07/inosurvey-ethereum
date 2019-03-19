pragma solidity ^0.5.0;

contract SurveyAccessControl {
    // owner address
    address public _owner;

    //contract lifeCycle
    bool public paused = false;

    event ContractUpgrade(address newContract);

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not Owner");
        _;
    }

    // set owner
    function setOwner(address _newOwner) external onlyOwner {
        // address 0x0... 무시하기(악의적인 컨트랙트 burning 방지)
        require(_newOwner != address(0), "Warning");
        _owner = _newOwner;
    }

    modifier whenNotPaused() {
        require(!paused, "already paused.");
        _;
    }

    modifier whenPuased() {
        require(paused, "not paused.");
        _;
    }

    function pause() external onlyOwner whenNotPaused {
        paused = true;
    }

    function unpause() external onlyOwner whenPuased {
        paused = false;
    }
}
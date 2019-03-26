pragma solidity ^0.5.0;

import "./SurveyBase.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Roles.sol";

contract SurveyOwnership is SurveyBase {
    using Roles for Roles.Role;

    event SubscriberAdded(uint256 surveyId, address indexed account);
    event SubscriberRemoved(uint256 surveyId, address indexed account);

    mapping (uint256 => Roles.Role) private _surveyToSubscribers;

    /*** Only Onwer ***/  
    modifier onlySurveyOwner(uint256 _surveyId) {
        require(surveyIndexToOwner[_surveyId] == msg.sender);
        _;
    }
    modifier onlyProductOwner(uint256 _productId) {
        require(productIndexToOwner[_productId] == msg.sender);
        _;
    }
    modifier onlyReceiptOwner(uint256 _receiptId) {
        require(receiptIndexToOwner[_receiptId] == msg.sender);
        _;
    }

    
    modifier onlySubscriber(uint256 _surveyId) {
        require(isSubscriber(_surveyId, msg.sender));
        _;
    }

    function isSubscriber(uint256 _surveyId, address _account) public view returns (bool) {
        return _surveyToSubscribers[_surveyId].has(_account);
    }

    function addSubscriber(uint256 _surveyId, address _account) public onlySurveyOwner(_surveyId) {
        _addSubscriber(_surveyId, _account);
    }

    // Security warning!
    function renounceSubscriber(uint256 _surveyId, address _account) public {
        _removeSubscriber(_surveyId, _account);
    }

    function _addSubscriber(uint256 _surveyId, address _account) internal {
        _surveyToSubscribers[_surveyId].add(_account);
        emit SubscriberAdded(_surveyId, _account);
    }

    function _removeSubscriber(uint256 _surveyId, address _account) internal {
        _surveyToSubscribers[_surveyId].remove(_account);
        emit SubscriberRemoved(_surveyId, _account);
    }
}
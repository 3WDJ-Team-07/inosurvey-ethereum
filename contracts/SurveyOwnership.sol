pragma solidity ^0.5.0;

import "./SurveyBase.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Roles.sol";

contract SurveyOwnership is SurveyBase {
    using Roles for Roles.Role;

    event BuyerAdded(uint256 surveyId, address indexed account);
    event BuyerRemoved(uint256 surveyId, address indexed account);

    mapping (uint256 => Roles.Role) private _surveyToBuyers;

    /*** OWNERSHIP ***/ 
    // 설문조사 주인만 
    modifier onlySurveyOwner(uint256 _surveyId) {
        require(surveyIndexToOwner[_surveyId] == msg.sender);
        _;
    }
    // 상품 주인만 
    modifier onlyProductOwner(uint256 _productId) {
        require(productIndexToOwner[_productId] == msg.sender);
        _;
    }
    // 기부단체 주인만
    modifier onlyFoundationOwner(uint256 _foundationId) {
        require(foundationIndexToOwner[_foundationId] == msg.sender);
        _;
    }
    // 영수증 주인만
    modifier onlyReceiptOwner(uint256 _receiptId) {
        require(receiptIndexToOwner[_receiptId] == msg.sender);
        _;
    }
    // 설문 구매자만
    modifier onlyBuyer(uint256 _surveyId) {
        require(isSurveyToBuyer(_surveyId, msg.sender));
        _;
    }
    // 설문 구매 가능 여부
    modifier buyableSurvey(uint256 _surveyId) {
        require(isBuyableSurvey(_surveyId));
        _;
    }

    // 구매 가능한 설문조사 인지?
    function isBuyableSurvey(uint256 _surveyId) public view returns (bool) {
        return surveys[_surveyId].isSell;
    }

    /***  SURVEY ROLE ***/
    function isSurveyToBuyer(uint256 _surveyId, address _account) public view returns (bool) {
        return _surveyToBuyers[_surveyId].has(_account);
    }

    function addSubscriber(uint256 _surveyId, address _account) internal {
        _addSubscriber(_surveyId, _account);
    }

    function renounceSubscriber(uint256 _surveyId, address _account) internal {
        _removeSubscriber(_surveyId, _account);
    }

    function _addSubscriber(uint256 _surveyId, address _account) internal {
        _surveyToBuyers[_surveyId].add(_account);
        emit BuyerAdded(_surveyId, _account);
    }

    function _removeSubscriber(uint256 _surveyId, address _account) internal {
        _surveyToBuyers[_surveyId].remove(_account);
        emit BuyerRemoved(_surveyId, _account);
    }
}
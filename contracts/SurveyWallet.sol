pragma solidity ^0.5.0;

import "./StandardToken.sol";
import "./SurveyOwnership.sol";

contract SurveyWallet is SurveyOwnership, StandardToken { 
    
    uint256[] resultList;
    /// 영수증의 모든 정보 반환
    function getReceiptDetail(uint256 _receiptId) 
        public 
        view
        onlyReceiptOwner(_receiptId)
        returns (
            ReceiptTitles,      // 설문인지, 상품인지
            ReceiptMethods,     // 요청, 구매 등..
            address,            // 누구에게
            address,            // 누구로부터
            uint256,            // 어떤 오브젝트를
            uint256,            // 얼마에
            uint256             // 언제
        )
    {
        return (
            receipts[_receiptId].title, 
            receipts[_receiptId].method, 
            receipts[_receiptId].to, 
            receipts[_receiptId].from,
            receipts[_receiptId].objectId,
            receipts[_receiptId].total, 
            receipts[_receiptId].date 
        );
    }
    /// 내가 요청한 설문 영수증의 Index List 반환
    function getSurveyRequestReceiptList() public view returns (uint256[] memory) {
        return surveyRequestReceiptList[msg.sender];
    }
    /// 내가 응답한 설문 영수증의 Index List 반환
    function getSurveyResponseReceiptList() public view returns (uint256[] memory) {
        return surveyRequestReceiptList[msg.sender];
    }
    /// 내가 구매한 설문 영수증의 Index List 반환
    function getSurveyBuyReceiptList() public view returns (uint256[] memory) {
        return surveyRequestReceiptList[msg.sender];
    }
    /// 내가 판매한 설문 영수증의 Index List 반환
    function getSurveySellReceiptList() public view returns (uint256[] memory) {
        return surveyRequestReceiptList[msg.sender];
    }
    /// 내가 구매한 상품 영수증의 상품 Index List 반환
    function getProductBuyReceiptList() public view returns (uint256[] memory) {
        return surveyRequestReceiptList[msg.sender];
    }
    /// 내가 판매한 상품 영수증의 Index List 반환
    function getProductSellReceiptList() public view returns (uint256[] memory) {
        return surveyRequestReceiptList[msg.sender];
    }

    /** TokenTransfer Internal Functions **/
    /// msg.sender => EA
    function _tranferTokenFromUserToThis(uint256 _value) internal returns (bool) {
        _transfer(msg.sender, address(this), _value);
        return true;
    }
    /// EA => DeveloperAddress
    function _transferTokenFromThisToDeveloper(uint256 _value) internal returns (bool) {
        _transfer(address(this), developerAddress, _value);
        return true;
    }

    /// EA => msg.sender
    function _transferTokenFromThisToUser(uint256 _value) internal returns (bool) {
        _transfer(address(this), msg.sender, _value);
        return true;
    }
}

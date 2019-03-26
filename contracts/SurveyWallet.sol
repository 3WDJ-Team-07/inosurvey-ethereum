pragma solidity ^0.5.0;

import "./StandardToken.sol";
import "./SurveyOwnership.sol";

contract SurveyWallet is SurveyOwnership, StandardToken {

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
    /// 내가 요청한 설문 영수증 리스트의 설문 primary key Index 반환
    function getSurveyRequestReceiptList() 
        public
        returns (uint256[] memory) 
    {
        
    }
    /// 내가 응답한 설문 영수증 리스트의 설문 primary key Index 반환

    /// 내가 구매한 설문 영수증 리스트의 설문 primary key Index 반환

    /// 내가 판매한 설문 영수증 리스트의 설문 primary key Index 반환

    /// 내가 구매한 상품 영수증 리스트의 상품 primary key Index 반환

    /// 내가 판매한 상품 영수증 리스트의 상풍 primary key Index 반환


    /** Contract Internal Functions **/
    /// EA 계좌에서 개발자에게 토큰 전송
    function _transferTokenToThis(uint256 _value) internal returns (bool){
        _transfer(address(this), developerAddress, _value);
        return true;
    }

    /// EA 계좌에서 유저에게 토큰 전송
    function _transferTokenToUser(address _userAddr, uint256 _value) internal returns (bool) {
        _transfer(address(this), _userAddr, _value);
        return true;
    }
}

pragma solidity ^0.5.0;

import "./StandardToken.sol";
import "./SurveyOwnership.sol";

contract SurveyWallet is SurveyOwnership, StandardToken { 
    /**
    * @dev Index에 해당하는 영수증 상세정보 반환
    * @param _receiptId 영수증 IndexId
    * @return ReceiptTitle uint256 enum 인덱스 반환. 설문인지, 상품인지
    * @return ReceiptMethod uint256 enum 인덱스 반환, 요청, 구매 등..
    * @return to address 누구에게
    * @return from address 누구로부터
    * @return objectId uint256 어떤 오브젝트를?
    * @return total uint256 총 금액
    * @return date uint256 생성 날짜
    */
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
            receipts[_receiptId].startedAt
        );
    }
    /** @dev 모든 설문 영수증의 Index List 반환 */
    function getOwnerReceiptList() public view returns (uint256[] memory) {
        return ownerReceiptList[msg.sender];
    }
    /** @dev 내가 요청한 설문 영수증의 Index List 반환 (소모) */
    function getSurveyRequestReceiptList() public view returns (uint256[] memory) {
        return surveyRequestReceiptList[msg.sender];
    }
    /** @dev 내가 응답한 설문 영수증의 Index List 반환 (적립) */
    function getSurveyResponseReceiptList() public view returns (uint256[] memory) {
        return surveyResponseReceiptList[msg.sender];
    }
    /** @dev 내가 구매한 설문 영수증의 Index List 반환 (소모) */
    function getSurveyBuyReceiptList() public view returns (uint256[] memory) {
        return surveyBuyReceiptList[msg.sender];
    }
    /** @dev 내가 판매한 설문 영수증의 Index List 반환 (적립) */
    function getSurveySellReceiptList() public view returns (uint256[] memory) {
        return surveySellReceiptList[msg.sender];
    }
    /** @dev 내가 등록한 기부 단체 영수증의 Index List 반환 */
    function getFoundationRequestReceiptList() public view returns (uint256[] memory) {
        return foundationRequestReceiptList[msg.sender];
    }
    /** @dev 내가 기부한 기부 영수증의 Index List 반환 (소모) */
    function getFoundationDonateReceiptList() public view returns (uint256[] memory) {
        return foundationDonateReceiptList[msg.sender];
    }
    /** @dev 내가 구매한 상품 영수증의 상품 Index List 반환 */
    function getProductBuyReceiptList() public view returns (uint256[] memory) {
        return productBuyReceiptList[msg.sender];
    }
    /** @dev 내가 판매한 상품 영수증의 Index List 반환 */
    function getProductSellReceiptList() public view returns (uint256[] memory) {
        return productSellReceiptList[msg.sender];
    }

    function faucet(address to, uint256 value) public onlyDeveloper returns (bool)  {
        mint(to, value);
        return true;
    }

    /*** TokenTransfer Internal Functions ***/
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

    /// EA => Foundation address
    function _transferTokenFromThisToFoundation(address _foundationAddr, uint256 _value) internal returns (bool) {
        _transfer(address(this), _foundationAddr, _value);
        return true;
    }
}

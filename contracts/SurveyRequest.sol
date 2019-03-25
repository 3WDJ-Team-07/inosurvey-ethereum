pragma solidity ^0.5.0;

import "./SurveySubscribeRole.sol";

contract SurveyRequest is SurveySubscribeRole {
    /*** CONSTANTS ***/
    uint256 public constant PRICE_PER_QUESTION = 100;

    mapping (uint256 => uint256) public surveyRequestPrice;

    function createSurvey(
        string memory _surveyUUID, 
        uint8 _questionCount
        // bytes32 _hashData
    ) 
        public
        returns (bool)
    {
        // 설문 가격 계산
        uint256 price = uint256(_questionCount) * uint256(PRICE_PER_QUESTION);
        // 토큰 전송 시도
        bool isSuccess = _transferTokenToThis(price);

        // 토큰 전송 성공 시
        if(isSuccess) {
            // 설문 조사 생성
            uint256 newSurveyId = _createSurvey(_surveyUUID, _questionCount);
            // 영수증 생성
            _createReceipt(address(this), msg.sender, price, ReceiptTitles.SurveyRequest);
            return true;
        }else {
            return false;
        }
    }

    function getRequestSurveyList() public returns (uint256[] memory) {
        return ownershipSurveyList[msg.sender];
    }
}
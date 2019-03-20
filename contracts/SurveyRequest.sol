pragma solidity ^0.5.0;

import "./SurveySubscribeRole.sol";

contract SurveyRequest is SurveySubscribeRole {

    mapping (uint256 => uint256) public surveyRequestPrice;

    function createSurvey(
        string memory _surveyUUID, 
        uint8 _questionCount, 
        address _owner, 
        bytes32 _hashData
    ) 
        public
        returns (bool)
    {
        // 설문 가격 계산
        uint256 price = uint256(_questionCount) * uint256(PricePerQuestions[_questionCount/4]);
        // 서비스 운영자에게 토큰 전송
        if(token.transfer(developerAddress, price)) {
            // 설문 생성
            uint256 surveyId = _createSurvey(_surveyUUID, _questionCount, _owner, _hashData);
            // 설문 요청 가격 저장
            surveyRequestPrice[surveyId] = price;
            return true;
        } else {
            return false;
        }
    }

}
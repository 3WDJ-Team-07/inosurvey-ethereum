pragma solidity ^0.5.0;

import "./SurveyResponse.sol";

contract SurveyMarket is SurveyResponse {
    uint256[] tempList;

    // 설문 판매 등록
    function addSurveyMarket(uint256 _surveyId, uint256 _price) 
        public 
        onlySurveyOwner(_surveyId) 
        returns (bool) 
    {
        surveys[_surveyId].sellPrice = _price;
        surveys[_surveyId].isSell = true;
        return true;
    }
    
    // 설문 판매 등록 취소
    function cancelSurveyMarket(uint256 _surveyId) public returns (bool) {
        surveys[_surveyId].sellPrice = 0;
        surveys[_surveyId].isSell = false;
        return true; 
    }

    // 설문 구매
    function buySurvey(uint256 _surveyId) public returns (bool) {
        Survey memory targetSurvey = surveys[_surveyId];
        uint256 price = targetSurvey.sellPrice;
        // 토큰 전송 시도
        bool buyIsSuccessed = transfer(surveyIndexToOwner[_surveyId], price);
        
        if(buyIsSuccessed) {
            
        }
        // 구매 생성
        // 열람 가능한지
    }

    // 설문 판매 리스트
    function getSurveyMarketList() public returns (uint256[] memory) {
        uint256[] memory resultList;
        tempList = resultList;

        for(uint i ; i < surveys.length ; i++) {
            if(surveys[i].isSell) {
                tempList.push(i);
            }
        }
        return tempList;
    }

    // 설문 구매 리스트
    function getSurveyBuyList() public returns (uint256[] memory) {
        
    }
}
pragma solidity ^0.5.0;

import "./SurveyResponse.sol";

contract SurveyMarket is SurveyResponse {
    /** @dev 설문 판매 등록 이벤트 */
    event AddSurveyMarket(uint256 surveyId, uint256 price);    
    /** @dev 설문 판매 취소 이벤트 */
    event CancelSurveyMarket(uint256 surveyId);
    /** @dev 설문 구매 이벤트 */
    event BuySurvey(uint256 surveyId, uint256 price);

    // 설문 판매 등록
    function addSurveyMarket(uint256 _surveyId, uint256 _price) 
        public 
        onlySurveyOwner(_surveyId) 
        returns (bool) 
    {
        surveys[_surveyId].sellPrice = _price;
        surveys[_surveyId].isSell = true;
        emit AddSurveyMarket(_surveyId, _price);
        return true;
    }

    // 설문 판매 등록 취소
    function cancelSurveyMarket(uint256 _surveyId) public returns (bool) {
        surveys[_surveyId].sellPrice = 0;
        surveys[_surveyId].isSell = false;
        emit CancelSurveyMarket(_surveyId);
        return true; 
    }

    // 설문 구매
    function buySurvey(uint256 _surveyId) public returns (uint256) {
        Survey memory targetSurvey = surveys[_surveyId];
        uint256 price = targetSurvey.sellPrice;
        // 토큰 전송 시도
        bool buyIsSuccessed = transfer(surveyIndexToOwner[_surveyId], price);
        
        if(buyIsSuccessed) {
            // 구매 생성
            uint256 newReceiptId = _createReceipt(
                ReceiptTitles.Survey, 
                ReceiptMethods.Buy, 
                address(this), 
                msg.sender, 
                _surveyId, 
                price, 
                now
            );
            addSubscriber(_surveyId, msg.sender);
            // 열람 가능한지
            emit BuySurvey(_surveyId, price);
            return newReceiptId;
        }
        
    }

    // 설문 판매 리스트
    function getSurveyMarketList() public returns (uint256[] memory) {
        uint256[] memory resultList;
        tempList = resultList;

        for(uint i = 0 ; i < surveys.length ; i++) {
            if(surveys[i].isSell) {
                tempList.push(i);
            }
        }
        return tempList;
    }

    // 설문 구매 리스트
    function getSurveyBuyList() public returns (uint256[] memory) {
        uint256[] memory resultList;
        uint256[] memory receiptIndexList = getSurveyBuyReceiptList();
        tempList = resultList;
        for(uint i = 0 ; i < receiptIndexList.length ; i++) {
            tempList.push(receipts[receiptIndexList[i]].objectId);
        }
        return tempList;
    }
}
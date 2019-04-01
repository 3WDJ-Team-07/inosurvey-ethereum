pragma solidity ^0.5.0;

import "./SurveyRequest.sol";

contract SurveyResponse is SurveyRequest {
    function responseSurvey(uint256 _surveyId) public returns (bool) {
        // surveys[_surveyId]
        // surveyDonateToFoundation[_usrveyId]
        // Survey.requestPrice
        // 
        Survey memory targetSurvey = surveys[_surveyId];
        address foundationAddr = foundationIndexToOwner[surveyDonateToFoundation[_surveyId]];

        uint256 responseReward = targetSurvey.requestPrice / 100 * 40;
        uint256 donationReward = targetSurvey.requestPrice / 100 * 20;

        // 응답 보상 지불 시도
        // 기부 시도
        bool resIsSuccessed = _transferTokenFromThisToUser(responseReward);
        bool donationIsSuccessed = _transferTokenFromThisToFoundation(foundationAddr, donationReward);

        if(resIsSuccessed) {
            // 응답인원 추가
            targetSurvey.currentCount++;
            // 영수증 발급
            _createReceipt(
                ReceiptTitles.Survey,
                ReceiptMethods.Response,
                msg.sender,
                address(this),
                _surveyId,
                responseReward
            );
        }else {
            return false;
        }
        if(donationIsSuccessed) {
            // 영수증 발급
            _createReceipt(
                ReceiptTitles.Foundation,
                ReceiptMethods.Donate,
                foundationAddr,
                msg.sender,
                surveyDonateToFoundation[_surveyId],
                donationReward
            );
        }else {
            return false;
        }
        return true;
    }

    // 설문 응답 리스트 반환
    function getSurveyResponseList() public returns (uint256[] memory) {
        uint256[] memory resultList;
        uint256[] memory receiptIndexList = getSurveyResponseReceiptList();
        tempList = resultList;
        for(uint i = 0 ; i < surveyResponseReceiptList[msg.sender].length ; i++) {
            tempList.push(receipts[receiptIndexList[i]].objectId);
        }
        return tempList;
    }

}
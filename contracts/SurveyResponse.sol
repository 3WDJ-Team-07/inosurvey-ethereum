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

        uint256 allReward = targetSurvey.requestPrice / targetSurvey.maximumCount;
        uint256 responseReward = allReward * 80 / 100;
        uint256 donationReward = allReward - responseReward;

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
                responseReward,
                now
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
                donationReward,
                now
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
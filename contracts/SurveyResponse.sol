pragma solidity ^0.5.0;

import "./SurveyRequest.sol";

contract SurveyResponse is SurveyRequest {
    function responseSurvey(uint256 _surveyId) public returns (uint256) {
        uint256 reward = surveys[_surveyId].requestPrice / surveys[_surveyId].maximumCount * 80 / 100;
        // uint256 donationReward = allReward - responseReward;

        // 응답 보상 지불 시도
        // 기부 시도
        bool isSuccess = _transferTokenFromThisToUser(reward);
        // bool donationIsSuccessed = _transferTokenFromThisToFoundation(foundationAddr, donationReward);

        if(isSuccess) {
            // 응답인원 추가
            surveys[_surveyId].currentCount++;
            // 영수증 발급
            uint256 newReceiptId = _createReceipt(
                ReceiptTitles.Survey,
                ReceiptMethods.Response,
                msg.sender,
                address(this),
                _surveyId,
                reward,
                now
            );
            return newReceiptId;
        }else {
            revert();
        }
        
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
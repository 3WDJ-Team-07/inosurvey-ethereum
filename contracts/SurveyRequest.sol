pragma solidity ^0.5.0;

import "./SurveyWallet.sol";

contract SurveyRequest is SurveyWallet {
    uint256[] tempList;
    mapping (uint256 => uint256) public surveyRequestPrice;

    function createSurvey(
        uint8 _questionCount
        // bytes32 _hashData
    ) 
        public
        returns (bool)
    {
        // 1. 설문 가격 계산
        uint256 requestPrice = uint256(_questionCount) * uint256(PRICE_PER_QUESTION);
        // 2. 토큰 전송 시도
        bool isSuccess = _tranferTokenFromUserToThis(requestPrice);
        if(isSuccess) {
            // 3. 설문 생성
            uint256 newSurveyId = _createSurvey(requestPrice, 0, _questionCount, false);
            // 4. 영수증 발급
            _createReceipt(
                ReceiptTitles.Survey, 
                ReceiptMethods.Request, 
                address(this), 
                msg.sender, 
                newSurveyId,
                requestPrice
            );
        }else {
            return false;
        }

    }

    function getRequestSurveyList() public returns (uint256[] memory) {
        uint256[] memory resultList;
        uint256[] memory receiptIndexList = getSurveyRequestReceiptList();
        tempList = resultList;
        for(uint i = 0 ; i < surveyRequestReceiptList[msg.sender].length ; i++) {
            tempList.push(receipts[receiptIndexList[i]].objectId);
        }
        return tempList;
    }
}
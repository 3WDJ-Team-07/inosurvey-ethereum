pragma solidity ^0.5.0;

import "./SurveyWallet.sol";

contract SurveyRequest is SurveyWallet {
    uint256[] tempList;
    mapping (uint256 => uint256) public surveyRequestPrice;

    /**
    * @dev create Survey(public)
    * _CreateProduct() 실행함
    * 설문 가격 계산 후 해당 금액 만큼의 토큰 전송을 시도
    * 성공 시 스토리지에 등록
    * 실패 시 false 리턴 
    * @param _maximumCount 설문 최대 응답 가능 인원 수.
    * @param _questionCount 설문 질문 개수
    * @return A bool 성공 여부 반환 
    */
    function createSurvey(
        uint256 _maximumCount,
        uint8   _questionCount
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
            uint256 newSurveyId = _createSurvey(
                requestPrice, 
                0, 
                _maximumCount,
                0,
                _questionCount, 
                false
            );
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
    /**
    * @dev 내가 등록한 설문 리스트 반환
    * @return A uint256[] 등록 설문 리스트의 DB primary key 반환 
    */
    function getSurveyRequestList() public returns (uint256[] memory) {
        uint256[] memory resultList;
        uint256[] memory receiptIndexList = getSurveyRequestReceiptList();
        tempList = resultList;
        for(uint i = 0 ; i < surveyRequestReceiptList[msg.sender].length ; i++) {
            tempList.push(receipts[receiptIndexList[i]].objectId);
        }
        return tempList;
    }

    function getSurveyRequestDetail(uint256 _surveyId) 
        public
        view 
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint8,
            bool
        )
    {
        return (
            surveys[_surveyId].requestPrice,
            surveys[_surveyId].sellPrice,
            surveys[_surveyId].maximumCount,
            surveys[_surveyId].currentCount,
            surveys[_surveyId].createdAt,
            surveys[_surveyId].questionCount,
            surveys[_surveyId].isSell
        );
    }
}
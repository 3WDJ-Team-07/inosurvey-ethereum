pragma solidity ^0.5.0;

contract test {
    struct Survey {
        uint256 requestPrice;       // 설문 등록 가격
        uint256 sellPrice;          // 설문 판매 가격
        uint256 rewardPrice;        // 설문 보상 가격
        uint256 maximumCount;       // 최대 응답자 수
        uint256 currentCount;       // 현재 응답자 수
        uint256 startedAt;          // 등록 날짜
        uint8   questionCount;      // 질문 개수
        bool    isSell;             // 팔지 말지
        // bytes32 hashData;       // DB 데이터 변조 여부 확인
    }

    Survey[]        surveys;
    mapping (uint256 => address) surveyIndexToOwner;

    function _createSurvey(
        uint256 _requestPrice,
        uint256 _sellPrice,
        uint256 _rewardPrice,
        uint256 _maximumCount,
        uint256 _currentCount,
        uint256 _startedAt,
        uint8   _questionCount,
        bool    _isSell
        // bytes32 _hashData
    )
        internal
        returns (uint256)
    {
        Survey memory _survey = Survey({
            requestPrice: _requestPrice,
            sellPrice: _sellPrice,
            rewardPrice: _rewardPrice,
            maximumCount: _maximumCount,
            currentCount: _currentCount,
            startedAt: _startedAt,
            questionCount: _questionCount,
            isSell: _isSell
            //hashData: _hashData
        });

        uint256 newSurveyId = surveys.push(_survey) - 1;

        surveyIndexToOwner[newSurveyId] = msg.sender;

        return newSurveyId;
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
            uint256,
            uint8,
            bool
        )
    {
        Survey memory survey = surveys[_surveyId];
        return (
            survey.requestPrice,
            survey.sellPrice,
            survey.rewardPrice,
            survey.maximumCount,
            survey.currentCount,
            survey.startedAt,
            survey.questionCount,
            survey.isSell
        );
    }
}
pragma solidity ^0.5.0;

import "./SurveyAccessControl.sol";

contract SurveyBase is SurveyAccessControl {

    /*** EVENT ***/
    // 설문 생성 알림
    event CreateSurvey(uint256 surveyId, address owner);
    
    // 설문 owner 변경 알림
    event SurveyTransfer(address from, address to, uint256 surveyId);

    /*** DATA TYPES ***/
    struct Survey {
        string  surveyUUID;   // DB address UUID
        uint64  createdAt;
        uint8   questionCount;    // created Date
        bytes32 hashData;      
    }
    /*** CONSTANTS ***/
    /** 
    *       index           sruvey question num         price
    *       0               1 ~ 4                       100
    *       1               5 ~ 8                       250
    *       2               9 ~ 12                      400
    *       3               13 ~ 16                     500
    *       4               17 ~ 20                     680
    *       5               21 ~ 24                     800
    *       6               25 ~ 28                     900
    *       7               ~ 30                        1000      
    */
    uint16[8] public PricePerQuestions = [
        uint16(100),
        uint16(250),
        uint16(400),
        uint16(500),
        uint16(680),
        uint16(800),
        uint16(900),
        uint16(1000)
    ];

    /*** STORAGE ***/
    /// 설문 조사
    Survey[] surveys;

    /// 설문조사 오너 주소
    mapping (uint256 => address) public surveyIndexToOwner;

    /// 오너가 가진 설문조사 개수
    mapping (address => uint256) ownershipSurveyCount;

    /// 설문 판매가 허가된 주소
    mapping (uint256 => address) public surveyIndexToApproved;

    /// 설문 소유자 이전
    function _transfer(address _from, address _to, uint _surveyId) internal {
        ownershipSurveyCount[_to]++;
        surveyIndexToOwner[_surveyId] = _to;

        if(_from != address(0)) {
            ownershipSurveyCount[_from]--;
            delete surveyIndexToApproved[_surveyId];
        }
        
        emit SurveyTransfer(_from, _to, _surveyId);
    }

    /// 설문 등록
    function _createSurvey(
        string memory _surveyUUID, 
        uint8 _questionCount, 
        address _owner, 
        bytes32 _hashData
    ) 
        internal 
        returns (uint256) 
    {
        Survey memory _survey = Survey({
            surveyUUID: _surveyUUID,
            createdAt: uint64(now),
            questionCount: _questionCount,
            hashData: _hashData
        });

        uint256 newSurveyId = surveys.push(_survey) - 1;

        emit CreateSurvey(newSurveyId, _owner);
        _transfer(address(0), _owner, newSurveyId);
        return newSurveyId;
    }
}
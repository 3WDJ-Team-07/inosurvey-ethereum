pragma solidity ^0.5.0;

import "./SurveyAccessControl.sol";

contract SurveyBase is SurveyAccessControl {

    /*** DATA TYPES ***/
    struct Survey {
        string surveyUUID;   // DB address UUID
        // uint64 createdAt;   // created Date
        // bytes32 signed;      
        // boolean isSale;     // 판매 여부
    }

    /*** EVENT ***/
    event CreateSurvey(uint256 surveyId, address owner);
    
    event Transfer(address from, address to, uint256 surveyId);

    /*** STORAGE ***/
    /// 설문 조사
    Survey[] surveys;

    /// 설문조사 오너 주소
    mapping (uint256 => address) surveyIndexToOwner;

    /// 오너가 가진 설문조사 개수
    mapping (address => uint256) ownershipSurveyCount;

    /// 설문 판매가 허가된 주소
    mapping (uint256 => address) surveyIndexToApproved;


    /// 설문 소유자 이전
    function _transfer(address _from, address _to, uint _surveyId) internal {
        ownershipSurveyCount[_to]++;
        surveyIndexToOwner[_surveyId] = _to;

        if(_from != address(0)) {
            ownershipSurveyCount[_from]--;
            delete surveyIndexToApproved[_surveyId];
        }
        
        emit Transfer(_from, _to, _surveyId);
    }

    /// 설문 등록
    function _createSurvey(string memory _surveyUUID, address _owner) internal returns (uint256) {
        Survey memory _survey = Survey({
            surveyUUID: _surveyUUID
        });

        uint256 newSurveyId = surveys.push(_survey) - 1;

        emit CreateSurvey(newSurveyId, _owner);
        _transfer(address(0), _owner, newSurveyId);
        return newSurveyId;
    }
}
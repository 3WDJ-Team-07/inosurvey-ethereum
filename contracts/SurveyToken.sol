pragma solidity ^0.5.0;

import "./StandardToken.sol";
import "./SurveyBase.sol";

contract SurveyToken is SurveyBase, StandardToken {
    /// EA 계좌에서 개발자에게 토큰 전송
    function _transferTokenToThis(uint256 _value) internal returns (bool){
        _transfer(address(this), developerAddress, _value);
        return true;
    }

    /// EA 계좌에서 유저에게 토큰 전송
    function _transferTokenToUser(address _userAddr, uint256 _value) internal returns (bool) {
        _transfer(address(this), _userAddr, _value);
        return true;
    }
}

pragma solidity ^0.5.0;

interface SurveyTokenInterface {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);

    /// 토큰 총 발행량
    function totalSupply() external view returns (uint256);

    /// 토큰 소유 갯수
    function balanceOf(address owner) external view returns (uint256);

    /// 토큰 소유자가 토큰 수신자에게 인출을 허락한 토큰이 얼마인지를 반환
    function allowance(address owner, address spender) external view returns (uint256);

    /// 송신자 계정에서 수신자 계정에게 토큰 송신
    function transfer(address to, uint256 value) external returns (bool);
    /// 송신자가 보유한 토큰에서 일정 금액 만큼의 토큰을 인출할 수 있는 권한을 수신자에게 부여
    function approve(address spender, uint256 value) external returns (bool);

    /// 송신자 account에서 해당 금액 만큼의 토큰을 인출해서 수신자 어카운트로 해당 금액 만큼의 토큰을 송신
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    
    /// 허가된 송신 금액중 원하는 금액만큼 추가
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);

    /// 허가된 송신 금액중 원하는 금액만큼 감소
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

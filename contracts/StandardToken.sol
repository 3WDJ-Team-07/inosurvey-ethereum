pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

contract StandardToken is IERC20 {
        using SafeMath for uint256;
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;
    string private _coinName = "INOCOIN";
    uint8 private _coinDecimals = 18;
    string private _coinSymbol = "INC";

    /// 토큰 총 발행량
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /// 토큰 소유 갯수
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /// 토큰 소유자가 토큰 수신자에게 인출을 허락한 토큰이 얼마인지를 반환
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /// 송신자 계정에서 수신자 계정에게 토큰 송신
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }
    /// 송신자가 보유한 토큰에서 일정 금액 만큼의 토큰을 인출할 수 있는 권한을 수신자에게 부여
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /// 송신자 account에서 해당 금액 만큼의 토큰을 인출해서 수신자 어카운트로 해당 금액 만큼의 토큰을 송신
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }
    
    /// 허가된 송신 금액중 원하는 금액만큼 추가
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /// 허가된 송신 금액중 원하는 금액만큼 감소
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

        /// 토큰 생성 메소드
    function mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /// 토큰 송신 메소드
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "burn address!!!");
        
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }


    function name() public view returns (string memory) {
        return _coinName;
    }

    function symbol() public view returns (string memory) {
        return _coinSymbol;
    }

    function decimals() public view returns (uint8) {
        return _coinDecimals;
    }
}
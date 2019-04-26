pragma solidity ^0.5.0;

import "./SurveyMarket.sol";

contract SurveyFoundation is SurveyMarket {
    event Donation(uint256 foundationId, uint256 price);

    uint256[] tempList;
    // 기부단체 등록
    function createFoundation(
        uint256 _maximumAmount,
        uint256 _closedAt
    ) 
        public 
        returns (uint256) 
    {
        uint256 newFoundationId = _createFoundation(
            0,
            _maximumAmount, 
            now,
            _closedAt,
            true
        );
        return newFoundationId;
    } 

    // 기부하기
    function donation(uint256 _foundationId, uint256 _value) public returns (uint256) {
        address foundationAddr = foundationIndexToOwner[_foundationId];
        // 기부 단체 활성화 여부
        if(foundations[_foundationId].isAchieved) {
            // 날짜가 지났으면?
            if(now > foundations[_foundationId].closedAt) {
                foundations[_foundationId].isAchieved = false;
                revert();
            }
            // 토큰 전송 시도
            bool isSuccess = transfer(foundationAddr, _value);
            if(isSuccess) {
                // 관련 변수 업데이트
                foundations[_foundationId].currentAmount += _value;
                if(foundations[_foundationId].maximumAmount <= foundations[_foundationId].currentAmount) {
                    foundations[_foundationId].isAchieved = false;
                }
                // 영수증 발급
                uint256 newReceiptId = _createReceipt(
                    ReceiptTitles.Foundation,
                    ReceiptMethods.Donate,
                    foundationAddr,
                    msg.sender,
                    _foundationId,
                    _value,
                    now
                );
                return newReceiptId;
            }else {
                revert();
            }
        } else {
            revert();
        }
    }

    // 기부 단체 리스트 
    function getFoundationList() public returns (uint256[] memory) {
        // 
        uint256[] memory resultList;
        uint256[] memory receiptIndexList = getFoundationDonateReceiptList();
        tempList = resultList;
        for(uint i = 0 ; i < foundationDonateReceiptList[msg.sender].length ; i++) {
            tempList.push(receipts[receiptIndexList[i]].objectId);
        }
        return tempList;
    }

    function getFoundationDetail(uint256 _foundationId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            bool
        )
    {
        return (
            foundations[_foundationId].currentAmount,
            foundations[_foundationId].maximumAmount,
            foundations[_foundationId].startedAt,
            foundations[_foundationId].closedAt,
            foundations[_foundationId].isAchieved
        );
    }
}
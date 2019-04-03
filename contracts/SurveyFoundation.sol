pragma solidity ^0.5.0;

import "./SurveyMarket.sol";

contract SurveyFoundation is SurveyMarket {
    uint256[] tempList;
    // 기부단체 등록
    function createFoundation(uint256 _maximumAmount, uint256 _closedAt) public returns (bool) {
        _createFoundation(_maximumAmount, _closedAt);
        return true;
    } 

    // 기부
    function donation(uint256 _foundationId, uint256 _value) public returns (bool) {
        // 
        Foundation memory targetFoundation = foundations[_foundationId];
        address foundationAddr = foundationIndexToOwner[_foundationId];
        if(targetFoundation.isAchieved) {
            // 전송 시도
            bool isSuccess = _transferTokenFromThisToFoundation(foundationAddr, _value);
            if(isSuccess) {
                // 관련 변수 업데이트
                targetFoundation.currentAmount += _value;
                if(targetFoundation.maximumAmount <= targetFoundation.currentAmount) {
                    targetFoundation.isAchieved = false;
                }
                // 영수증 발급
                _createReceipt(
                    ReceiptTitles.Foundation,
                    ReceiptMethods.Donate,
                    foundationAddr,
                    msg.sender,
                    _foundationId,
                    _value
                );
                return true;
            }else {
                return false;
            }
        } else {
            return false;
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
            foundations[_foundationId].createdAt,
            foundations[_foundationId].closedAt,
            foundations[_foundationId].isAchieved
        );
    }
}
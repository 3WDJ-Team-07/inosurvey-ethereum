pragma solidity ^0.5.0;

import "./SurveyAccessControl.sol";

contract SurveyBase is SurveyAccessControl {

    /*** EVENT ***/
    // 설문 생성 알림
    event CreateSurvey(uint256 surveyId, address owner);
    event CreateReceipt(uint256 ReceiptId, address owner);

    /*** DATA TYPES ***/
    struct Survey {
          // DB에 저장된 설문 고유 번호
        uint8 questionCount;    // 질문 개수
        // bytes32 hashData;       // DB 데이터 변조 여부 확인
    }
    struct Receipt {
        address to;
        address from;
        uint256 total;
    }

    /*** CONSTANTS ***/
    enum ReceiptTitles {
        SurveyRequest,
        SurveyResponse,
        SurveyBuy,
        SurveySell,
        ProductBuy,
        ProductSell
    }

    /*** STORAGE ***/
    /// 설문 조사 저장
    Survey[] surveys;
    Receipt[] receipts;

    /// DB UUID에 해당하는 설문 인덱스 번호
    mapping(string => uint256) uuidToSurveyIndex;
    /// 설문 조사 요청자
    mapping (uint256 => address) surveyIndexToOwner;
    /// 내가 요청한 설문 조사 리스트
    mapping (address => uint256[]) ownershipSurveyList;   
    
    /**** Receipt ****/ 
    // 영수증 인덱스 => 주인
    mapping (uint256 => address) receiptIndexToOwner;
    // 유저가 요청한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyRequestReceiptList;
    // 유저가 응답한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyResponceReceiptList;
    // 유저가 구매한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyBuyReceiptList;
    // 유저가 판매한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveySellReceiptList;
    // 유저가 구매한 상품 영수증 리스트
    mapping (address => uint256[]) productBuyReceiptList;
    // 유저가 판매한 상품 영수증 리스트
    mapping (address => uint256[]) productSellReceiptList;

    
    /// 설문 생성
    function _createSurvey(
        string memory _uuid,
        uint8 _questionCount
        // bytes32 _hashData
    )
        internal
        returns (uint256)
    {
        Survey memory _survey = Survey({
            //uuid: _uuid,
            questionCount: _questionCount
            //hashData: _hashData
        });
        uint256 newSurveyId = surveys.push(_survey) - 1;

        uuidToSurveyIndex[_uuid] =  newSurveyId;
        surveyIndexToOwner[newSurveyId] = msg.sender;
        ownershipSurveyList[msg.sender].push(newSurveyId);

        emit CreateSurvey(newSurveyId, msg.sender);

        return newSurveyId;
    }

    /// 영수증 발급
    function _createReceipt(
        address _to,
        address _from,
        uint256 _total,
        ReceiptTitles _title
    )
        internal
        returns (uint256)
    {
        Receipt memory _receipt = Receipt({
            to: _to,
            from: _from,
            total: _total
        });
        uint256 newReceiptId = receipts.push(_receipt) - 1;
        receiptIndexToOwner[newReceiptId] = msg.sender;
        
        if(_title == ReceiptTitles.SurveyRequest) {
            surveyRequestReceiptList[msg.sender].push(newReceiptId);
        }else if(_title == ReceiptTitles.SurveyResponse) {
            surveyResponceReceiptList[msg.sender].push(newReceiptId);
        }else if(_title == ReceiptTitles.SurveyBuy) {
            surveyBuyReceiptList[msg.sender].push(newReceiptId);
        }else if(_title == ReceiptTitles.SurveySell) {
            surveySellReceiptList[msg.sender].push(newReceiptId);
        }else if(_title == ReceiptTitles.ProductBuy) {
            productBuyReceiptList[msg.sender].push(newReceiptId);
        }else if(_title == ReceiptTitles.ProductSell) {
            productSellReceiptList[msg.sender].push(newReceiptId);
        }else {
            revert();
        }
        
        emit CreateReceipt(newReceiptId, msg.sender);
        return newReceiptId;
    }
}
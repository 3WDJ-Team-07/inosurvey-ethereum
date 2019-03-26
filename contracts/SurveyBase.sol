pragma solidity ^0.5.0;

import "./SurveyAccessControl.sol";

contract SurveyBase is SurveyAccessControl {

    /*** EVENT ***/
    // 설문 생성 알림
    event CreateSurvey(uint256 surveyId, address owner);
    event CreateProduct(uint256 productId, address owner);
    event CreateReceipt(uint256 ReceiptId, address owner);

    /*** DATA TYPES ***/
    struct Survey {
        uint8 questionCount;    // 질문 개수
        // bytes32 hashData;       // DB 데이터 변조 여부 확인
    }

    struct Product {
        uint256 price;
    }

    struct Receipt {
        ReceiptTitles title;
        ReceiptMethods method;
        address to;
        address from;
        uint256 objectId;
        uint256 total;
        uint256 date;
    }
    // struct Product {
    //     string  name;
    //     uint256 price;
    // }

    /*** CONSTANTS ***/
    enum ReceiptTitles {
        Survey,
        Product
    }

    enum ReceiptMethods {
        Request,
        Response,
        Buy,
        Sell
    }

    /*** STORAGE ***/
    Survey[] surveys;
    Product[] products;
    Receipt[] receipts;

    /*** data ownership ***/
    /// 설문 데이터 주인
    mapping (uint256 => address) surveyIndexToOwner;
    /// 상품 데이터 주인
    mapping (uint256 => address) productIndexToOwner;
    /// 영수증 데이터 주인
    mapping (uint256 => address) receiptIndexToOwner;

    /*** Receipt ***/
    // 유저가 요청한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyRequestReceiptList;    
    // 유저가 응답한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyResponseReceiptList;   
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
            questionCount: _questionCount
            //hashData: _hashData
        });
        uint256 newSurveyId = surveys.push(_survey) - 1;

        surveyIndexToOwner[newSurveyId] = msg.sender;

        emit CreateSurvey(newSurveyId, msg.sender);

        return newSurveyId;
    }

    /// 상품 생성
    function _createProduct(
        string memory _uuid,
        uint256 _price
    )
        internal
        returns (uint256)
    {
        Product memory _product = Product({
            price: _price
        });
        uint256 newProductId = products.push(_product) - 1;

        productIndexToOwner[newProductId] = msg.sender;

        emit CreateProduct(newProductId, msg.sender);

        return newProductId;
    }

    /// 영수증 생성
    function _createReceipt(
        ReceiptTitles _title,
        ReceiptMethods _method,
        address _to,
        address _from,
        uint256 _objectId,
        uint256 _total
    )
        internal
        returns (uint256)
    {
        Receipt memory _receipt = Receipt({
            title: _title,
            method: _method,
            to: _to,
            from: _from,
            objectId: _objectId,
            total: _total,
            date: now
        });

        uint256 newReceiptId = receipts.push(_receipt) - 1;
        receiptIndexToOwner[newReceiptId] = msg.sender;
        
        // 설문인 경우
        if(_title == ReceiptTitles.Survey) {
            if(_method == ReceiptMethods.Request) {
                surveyRequestReceiptList[msg.sender].push(newReceiptId);
            }else if(_method == ReceiptMethods.Response) {
                surveyResponseReceiptList[msg.sender].push(newReceiptId);
            }else if(_method == ReceiptMethods.Buy) {
                surveyBuyReceiptList[msg.sender].push(newReceiptId);
            }else if(_method == ReceiptMethods.Sell) {
                surveySellReceiptList[msg.sender].push(newReceiptId);
            }else {
                revert();
            }
        // 상품인 경우
        }else if(_title == ReceiptTitles.Product) {
            if(_method == ReceiptMethods.Buy) {
                productBuyReceiptList[msg.sender].push(newReceiptId);
            }else if(_method == ReceiptMethods.Sell) {
                productSellReceiptList[msg.sender].push(newReceiptId);
            }else {
                revert();
            }
        }else {
            revert();
        }

        emit CreateReceipt(newReceiptId, msg.sender);
        return newReceiptId;
    }
}
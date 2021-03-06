pragma solidity ^0.5.0;

import "./SurveyAccessControl.sol";

contract SurveyBase is SurveyAccessControl {
    /*** EVENT ***/
    /** @dev 설문 생성 이벤트 */
    event CreateSurvey(uint256 surveyId, address owner);
    /** @dev 영수증 생성 이벤트 */
    event CreateReceipt(uint256 receiptId, address owner);
    /** @dev 기부 단체 생성 이벤트 */
    event CreateFoundation(uint256 foundationId, address owner);
    /** @dev 상품 생성 이벤트 */
    event CreateProduct(uint256 productId, address owner);

    /*** DATA TYPES ***/
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

    struct Foundation {
        uint256 currentAmount;      // 현재 모금 액수
        uint256 maximumAmount;      // 목표 모금 액스
        uint256 startedAt;          // 만들어진 시간
        uint256 closedAt;           // 마감 시간
        bool    isAchieved;         // 모금 여부
    }

    struct Receipt {
        ReceiptTitles title;        // 영수증 타이틀
        ReceiptMethods method;      // 영수증 행동
        address to;                 // 누구에게 전송했는지
        address from;               // 누구의 계좌에서
        uint256 objectId;           // 관련 오브젝트 indexId
        uint256 total;              // 전송량
        uint256 startedAt;          // 날짜
    }

    struct Product {
        uint256 price;
    }

    /*** CONSTANTS ***/
    // survey constants
    uint256 public constant PRICE_PER_QUESTION = 10;

    // receipt constants
    enum ReceiptTitles {
        Survey,
        Foundation,
        Product
    }

    enum ReceiptMethods {
        Request,
        Response,
        Donate,
        Buy,
        Sell,
        Reward
    }

    /*** STORAGE ***/
    Survey[]        surveys;
    Receipt[]       receipts;
    Foundation[]    foundations;
    Product[]       products;

    /*** DATA's OWNERSHIP ***/
    /// 설문 데이터 주인
    mapping (uint256 => address) surveyIndexToOwner;
    /// 영수증 데이터 주인
    mapping (uint256 => address) receiptIndexToOwner;
    /// 도네이션 모금함 주인
    mapping (uint256 => address) foundationIndexToOwner;
    /// 상품 데이터 주인
    mapping (uint256 => address) productIndexToOwner;

    // 설문을 구매한 사람 리스트
    mapping (uint256 => address[]) surveyBuyerList;

    /*** RECEIPTS ***/
    mapping (address => uint256[]) ownerReceiptList;
    // 유저가 요청한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyRequestReceiptList;
    // 유저가 응답한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyResponseReceiptList;
    // 유저가 구매한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveyBuyReceiptList;
    // 유저가 판매한 설문 조사 영수증 리스트
    mapping (address => uint256[]) surveySellReceiptList;
    // 설문 구매시 보너스 영수증 리스트
    mapping (address => uint256[]) surveyRewardReceiptList;
    // 유저가 등록한 기부 단체 영수증 리스트
    mapping (address => uint256[]) foundationRequestReceiptList;
    // 유저가 기부한 금액 영수증 리스트
    mapping (address => uint256[]) foundationDonateReceiptList;
    // 유저가 구매한 상품 영수증 리스트
    mapping (address => uint256[]) productBuyReceiptList;
    // 유저가 판매한 상품 영수증 리스트
    mapping (address => uint256[]) productSellReceiptList;

    /**
    * @dev Create Survey(internal)
    * @param _requestPrice 설문 등록 요청 가격.
    * @param _sellPrice 설문 판매시 판매 가격.
    * @param _maximumCount 설문 판매 여부.
    * @param _currentCount 설문 판매 여부.
    * @param _isSell 자동 기부되는 기부단체 Index.
    * @param _questionCount 설문 질문 개수.
    * @param _isSell 설문 판매 여부
    * @return A uint256 설문 구조체 배열에 들어간 Index 반환
    */
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

        emit CreateSurvey(newSurveyId, msg.sender);

        return newSurveyId;
    }

    /**
    * @dev 영수증 생성 메소드, 토큰 소비 흐름을 감시
    * CreateReceipt EVENT 발생
    * 종류에 따른 매핑에 영수증 index 저장
    * @param _title 어떤 오브젝트인지, ex) survey, product.
    * @param _method 어떤 행동을 했는지, ex) buy, sell.
    * @param _to 누구의 계좌로 송금 하였는지.
    * @param _from 누구의 계좌에소 출금 하였는지.
    * @param _objectId 스토리지에 저장된 object(survey, product) index.
    * @param _total 총 금액.
    * @return A uint256 영수증 구조체 배열에 들어간 Index 반환
    */
    function _createReceipt(
        ReceiptTitles   _title,
        ReceiptMethods  _method,
        address         _to,
        address         _from,
        uint256         _objectId,
        uint256         _total,
        uint256         _startedAt
    )
        internal
        returns (uint256)
    {
        Receipt memory _receipt = Receipt({
            title:      _title,
            method:     _method,
            to:         _to,
            from:       _from,
            objectId:   _objectId,
            total:      _total,
            startedAt:  _startedAt
        });
        uint256 newReceiptId = receipts.push(_receipt) - 1;
        receiptIndexToOwner[newReceiptId] = msg.sender;

        ownerReceiptList[msg.sender].push(newReceiptId);

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
            }else if(_method == ReceiptMethods.Reward) {
                surveyRewardReceiptList[msg.sender].push(newReceiptId);
            }else {
                revert();
            }
        // 기부 단체인 경우
        }else if(_title == ReceiptTitles.Foundation){
            if(_method == ReceiptMethods.Request) {
                foundationRequestReceiptList[msg.sender].push(newReceiptId);
            }else if(_method == ReceiptMethods.Donate) {
                foundationDonateReceiptList[msg.sender].push(newReceiptId);
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

    /**
    * @dev 기부단체 생성 메소드 
    * @param _maximumAmount 모금 목표 금액 .
    * @param _closedAt 모금 종료 시간, UNIX Timestamp
    * @return A uint256 기부단체 구조체 배열에 들어간 Index 반환 
    */
    function _createFoundation(
        uint256 _currentAmount,
        uint256 _maximumAmount,
        uint256 _startedAt,
        uint256 _closedAt,
        bool    _isAchieved
    )
        internal
        returns (uint256)
    {
        Foundation memory _foundation = Foundation({
            currentAmount:  _currentAmount,
            maximumAmount:  _maximumAmount,
            startedAt:      _startedAt,
            closedAt:       _closedAt,
            isAchieved:     _isAchieved
        });

        uint256 newFoundationId = foundations.push(_foundation) - 1;

        foundationIndexToOwner[newFoundationId] = msg.sender;

        emit CreateFoundation(newFoundationId, msg.sender);

        return newFoundationId;
    }



    /**
    * @dev 상품 생성 메소드, 스토리지에 상품 추가 .
    * CreateProduct EVENT 발생
    * @param _price 상품 판매 가격.
    * @return A uint256 상품 구조체 배열에 들어간 Index 반환 
    */
    function _createProduct(
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

}

import XCTest
import Combine
@testable import ExampleForTest

@MainActor
class CurrencyConverterViewModelTests: XCTestCase {

    var viewModel: CurrencyConverterViewModel!

    override func setUp() {
        super.setUp()
        viewModel = CurrencyConverterViewModel()
        executionTimeAllowance = 2.0 // 각 테스트의 타임아웃을 2초로 설정
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testValidConversion() async {
        viewModel.amountString = "1350"
        viewModel.sourceCurrency = .KRW
        viewModel.targetCurrency = .USD

        var finalValue: String?
        for await value in viewModel.$convertedAmountString.values {
            if value.contains("1.00") {
                finalValue = value
                break
            }
        }
        XCTAssertNotNil(finalValue)
    }

    func testInvalidAmount() async {
        viewModel.amountString = "abc"

        var finalValue: String?
        for await value in viewModel.$convertedAmountString.values {
            if value == "유효하지 않은 숫자입니다." {
                finalValue = value
                break
            }
        }
        XCTAssertNotNil(finalValue)
    }

    func testZeroAmount() async {
        viewModel.amountString = "0"

        var finalValue: String?
        for await value in viewModel.$convertedAmountString.values {
            if value.contains("0.00") {
                finalValue = value
                break
            }
        }
        XCTAssertNotNil(finalValue)
    }

    func testNegativeAmount() async {
        viewModel.amountString = "-1350"
        viewModel.sourceCurrency = .KRW
        viewModel.targetCurrency = .USD

        var finalValue: String?
        for await value in viewModel.$convertedAmountString.values {
            if value.contains("-1.00") {
                finalValue = value
                break
            }
        }
        XCTAssertNotNil(finalValue)
    }

    func testSameSourceAndTargetCurrency() async {
        viewModel.amountString = "1000"
        viewModel.sourceCurrency = .USD
        viewModel.targetCurrency = .USD

        var finalValue: String?
        for await value in viewModel.$convertedAmountString.values {
            if value.contains("1000.00") {
                finalValue = value
                break
            }
        }
        XCTAssertNotNil(finalValue)
    }

    func testConversionToKRW() async {
        viewModel.amountString = "1"
        viewModel.sourceCurrency = .USD
        viewModel.targetCurrency = .KRW

        var finalValue: String?
        for await value in viewModel.$convertedAmountString.values {
            if value.contains("1350.00") {
                finalValue = value
                break
            }
        }
        XCTAssertNotNil(finalValue)
    }

    func testLargeAmount() async {
        viewModel.amountString = "1000000"
        viewModel.sourceCurrency = .KRW
        viewModel.targetCurrency = .USD

        var finalValue: String?
        for await value in viewModel.$convertedAmountString.values {
            if value.contains("740.74") {
                finalValue = value
                break
            }
        }
        XCTAssertNotNil(finalValue)
    }
}

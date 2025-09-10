import Quick
import Nimble
@testable import ExampleForTest

class CurrencyConverterViewModelQuickTests: QuickSpec {
    override class func spec() {
        describe("CurrencyConverterViewModel") {
            var viewModel: CurrencyConverterViewModel!

            context("with a valid conversion") {
                beforeEach {
                    viewModel = CurrencyConverterViewModel()
                    viewModel.amountString = "1350"
                    viewModel.sourceCurrency = .KRW
                    viewModel.targetCurrency = .USD
                }

                it("should produce the correct converted amount") {
                    expect(viewModel.convertedAmountString).toEventually(contain("1.00"))
                }
            }

            context("with an invalid amount") {
                beforeEach {
                    viewModel = CurrencyConverterViewModel()
                    viewModel.amountString = "abc"
                }

                it("should produce an invalid number error") {
                    expect(viewModel.convertedAmountString).toEventually(equal("유효하지 않은 숫자입니다."))
                }
            }

            context("with a zero amount") {
                beforeEach {
                    viewModel = CurrencyConverterViewModel()
                    viewModel.amountString = "0"
                }

                it("should produce a zero result") {
                    expect(viewModel.convertedAmountString).toEventually(contain("0.00"))
                }
            }

            context("with a negative amount") {
                beforeEach {
                    viewModel = CurrencyConverterViewModel()
                    viewModel.amountString = "-1350"
                    viewModel.sourceCurrency = .KRW
                    viewModel.targetCurrency = .USD
                }

                it("should produce a negative result") {
                    expect(viewModel.convertedAmountString).toEventually(contain("-1.00"))
                }
            }

            context("with the same source and target currency") {
                beforeEach {
                    viewModel = CurrencyConverterViewModel()
                    viewModel.amountString = "1000"
                    viewModel.sourceCurrency = .USD
                    viewModel.targetCurrency = .USD
                }

                it("should produce the same amount") {
                    expect(viewModel.convertedAmountString).toEventually(contain("1000.00"))
                }
            }

            context("with a conversion to KRW") {
                beforeEach {
                    viewModel = CurrencyConverterViewModel()
                    viewModel.amountString = "1"
                    viewModel.sourceCurrency = .USD
                    viewModel.targetCurrency = .KRW
                }

                it("should produce the correct converted amount") {
                    expect(viewModel.convertedAmountString).toEventually(contain("1350.00"))
                }
            }

            context("with a large amount") {
                beforeEach {
                    viewModel = CurrencyConverterViewModel()
                    viewModel.amountString = "1000000"
                    viewModel.sourceCurrency = .KRW
                    viewModel.targetCurrency = .USD
                }

                it("should produce the correct converted amount") {
                    expect(viewModel.convertedAmountString).toEventually(contain("740.74"))
                }
            }
        }
    }
}

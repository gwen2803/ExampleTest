
import Foundation
import Combine

class CurrencyConverterViewModel: ObservableObject {
    @Published var amountString: String = "1000"
    @Published var sourceCurrency: Currency = .KRW
    @Published var targetCurrency: Currency = .USD
    @Published var convertedAmountString: String = ""
    
    // KRW를 기준으로 한 고정 환율
    private let exchangeRates: [Currency: Double] = [
        .KRW: 1.0,
        .USD: 1 / 1350.0,
        .JPY: 1 / 9.0 // 100엔 기준이 아닌 1엔 기준
    ]
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Publishers.CombineLatest3($amountString, $sourceCurrency, $targetCurrency)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .receive(on: DispatchQueue.global())
            .map { [weak self] amountStr, source, target -> String in
                guard let self = self, 
                      let amount = Double(amountStr) else { return "유효하지 않은 숫자입니다." }
                
                let convertedAmount = self.convert(amount: amount, from: source, to: target)
                
                return String(format: "%.2f %@", convertedAmount, target.symbol)
            }
            .receive(on: RunLoop.main)
            .assign(to: &$convertedAmountString)
    }
    
    private func convert(amount: Double, from source: Currency, to target: Currency) -> Double {
        guard let sourceRate = exchangeRates[source], let targetRate = exchangeRates[target] else {
            return 0
        }
        // 모든 통화를 기준 통화(KRW)로 변환 후, 목표 통화로 다시 변환
        let baseAmount = amount / sourceRate
        let finalAmount = baseAmount * targetRate
        return finalAmount
    }
}

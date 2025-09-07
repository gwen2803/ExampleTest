import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyConverterViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("변환할 금액")) {
                HStack {
                    TextField("금액", text: $viewModel.amountString)
                        .keyboardType(.decimalPad)
                    Picker("", selection: $viewModel.sourceCurrency) {
                        ForEach(Currency.allCases) { currency in
                            Text(currency.rawValue).tag(currency)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            
            Section(header: Text("변환 결과")) {
                Picker("대상 통화", selection: $viewModel.targetCurrency) {
                    ForEach(Currency.allCases) { currency in
                        Text(currency.name).tag(currency)
                    }
                }
                .pickerStyle(.segmented)
                
                Text(viewModel.convertedAmountString)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .navigationTitle("환율 계산기")
    }
}

#Preview {
    NavigationStack {
        CurrencyConverterView()
    }
}
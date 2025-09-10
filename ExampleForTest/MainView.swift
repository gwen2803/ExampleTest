import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Color.clear.frame(height: 10)) {
                    NavigationLink("사용자 등록 유효성 검사기") {
                        UserRegistrationView()
                    }
                    NavigationLink("쇼핑 카트 계산기") {
                        ShoppingCartView()
                    }
                    NavigationLink("간단한 환율 계산기") {
                        CurrencyConverterView()
                    }
                }
            }
            .navigationTitle("기능 목록")
        }
    }
}

#Preview {
    MainView()
}
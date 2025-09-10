import SwiftUI

struct ShoppingCartView: View {
    @StateObject private var viewModel = ShoppingCartViewModel()

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                List {
                    ForEach(viewModel.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.formattedPrice)
                        }
                        .id(item.id) // 스크롤을 위한 ID
                    }
                    .onDelete(perform: viewModel.removeItem)
                }
                .onChange(of: viewModel.items) { _, newValue in
                    // 아이템이 추가되었을 때 마지막 아이템으로 스크롤
                    if let lastItem = newValue.last {
                        withAnimation {
                            proxy.scrollTo(lastItem.id, anchor: .bottom)
                        }
                    }
                }
                
                Spacer()
                
                Divider()
                
                HStack {
                    Text("총액")
                        .font(.headline)
                    Spacer()
                    Text(viewModel.formattedTotalPrice)
                        .font(.title.bold())
                }
                .padding()
            }
            .navigationTitle("쇼핑 카트")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.addSampleItem) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ShoppingCartView()
    }
}
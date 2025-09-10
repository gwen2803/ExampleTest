
import Foundation
import Combine

class ShoppingCartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published private(set) var totalPrice: Double = 0.0
    @Published var formattedTotalPrice: String = "0원"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 총액(Double) 계산
        $items
            .map { $0.reduce(0) { $0 + $1.price } }
            .assign(to: &$totalPrice)
        
        // 포맷팅된 총액(String) 계산
        $totalPrice
            .map { String(format: "%.0f원", $0) }
            .assign(to: &$formattedTotalPrice)
    }
    
    func addItem(_ item: CartItem) {
        items.append(item)
    }
    
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    // For demonstration purposes
    func addSampleItem() {
        let sampleItems = [
            CartItem(id: UUID(), name: "사과", price: 1500),
            CartItem(id: UUID(), name: "바나나", price: 3000),
            CartItem(id: UUID(), name: "우유", price: 2500),
            CartItem(id: UUID(), name: "빵", price: 4000),
            CartItem(id: UUID(), name: "시리얼", price: 6000)
        ]
        
        if let randomItem = sampleItems.randomElement() {
            addItem(randomItem)
        }
    }
}

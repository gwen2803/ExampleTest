
import Foundation

struct CartItem: Identifiable, Equatable {
    let id: UUID
    let name: String
    let price: Double
    
    var formattedPrice: String {
        String(format: "%.0f원", price)
    }
}

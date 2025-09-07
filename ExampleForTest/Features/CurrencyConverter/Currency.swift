
import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case KRW
    case USD
    case JPY
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .KRW: return "대한민국 원"
        case .USD: return "미국 달러"
        case .JPY: return "일본 엔"
        }
    }
    
    var symbol: String {
        switch self {
        case .KRW: return "원"
        case .USD: return "$"
        case .JPY: return "¥"
        }
    }
}

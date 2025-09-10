import XCTest
@testable import ExampleForTest

class ShoppingCartViewModelTests: XCTestCase {

    var viewModel: ShoppingCartViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ShoppingCartViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testAddItem() {
        let item = CartItem(id: UUID(), name: "Test Item", price: 10.0)
        viewModel.addItem(item)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.totalPrice, 10.0)
    }

    func testRemoveItem() {
        let item1 = CartItem(id: UUID(), name: "Test Item 1", price: 10.0)
        let item2 = CartItem(id: UUID(), name: "Test Item 2", price: 20.0)
        viewModel.addItem(item1)
        viewModel.addItem(item2)

        viewModel.removeItem(at: IndexSet(integer: 0))
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.totalPrice, 20.0)
    }

    func testEmptyCart() {
        XCTAssertEqual(viewModel.items.count, 0)
        XCTAssertEqual(viewModel.totalPrice, 0.0)
    }

    func testAddSampleItem() {
        let initialItemCount = viewModel.items.count
        viewModel.addSampleItem()
        XCTAssertEqual(viewModel.items.count, initialItemCount + 1)
    }

    func testFormattedTotalPrice() {
        let item = CartItem(id: UUID(), name: "Test Item", price: 10.0)
        viewModel.addItem(item)
        XCTAssertEqual(viewModel.formattedTotalPrice, "10원")
    }
    
    func testRemoveAllItems() {
        let item1 = CartItem(id: UUID(), name: "Test Item 1", price: 10.0)
        let item2 = CartItem(id: UUID(), name: "Test Item 2", price: 20.0)
        viewModel.addItem(item1)
        viewModel.addItem(item2)

        viewModel.removeItem(at: IndexSet(integersIn: 0...1))
        XCTAssertEqual(viewModel.items.count, 0)
        XCTAssertEqual(viewModel.totalPrice, 0.0)
    }
    
    func testFormattedTotalPriceWithZero() {
        XCTAssertEqual(viewModel.formattedTotalPrice, "0원")
    }
    
    func testFormattedTotalPriceWithLargeNumber() {
        let item = CartItem(id: UUID(), name: "Test Item", price: 1_000_000.0)
        viewModel.addItem(item)
        XCTAssertEqual(viewModel.formattedTotalPrice, "1000000원")
    }

    func testRemoveItemFromEmptyList() {
        viewModel.removeItem(at: IndexSet(integer: 0))
        XCTAssertEqual(viewModel.items.count, 0)
        XCTAssertEqual(viewModel.totalPrice, 0.0)
    }

    func testRemoveItemWithOutOfBoundsIndex() {
        let item = CartItem(id: UUID(), name: "Test Item", price: 10.0)
        viewModel.addItem(item)
        viewModel.removeItem(at: IndexSet(integer: 1))
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.totalPrice, 10.0)
    }

    func testAddItemWithZeroPrice() {
        let item = CartItem(id: UUID(), name: "Test Item", price: 0.0)
        viewModel.addItem(item)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.totalPrice, 0.0)
    }

    func testAddItemWithNegativePrice() {
        let item = CartItem(id: UUID(), name: "Test Item", price: -10.0)
        viewModel.addItem(item)
        XCTAssertEqual(viewModel.items.count, 1)
        XCTAssertEqual(viewModel.totalPrice, -10.0)
    }

    func testTotalPriceWithFloatingPoint() {
        let item1 = CartItem(id: UUID(), name: "Test Item 1", price: 0.1)
        let item2 = CartItem(id: UUID(), name: "Test Item 2", price: 0.2)
        viewModel.addItem(item1)
        viewModel.addItem(item2)
        XCTAssertEqual(viewModel.totalPrice, 0.3, accuracy: 0.0001)
    }
}

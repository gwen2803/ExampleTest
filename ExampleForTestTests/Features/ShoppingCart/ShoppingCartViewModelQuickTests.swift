import Foundation
import Quick
import Nimble
@testable import ExampleForTest

class ShoppingCartViewModelQuickTests: QuickSpec {
    override class func spec() {
        describe("ShoppingCartViewModel") {
            var viewModel: ShoppingCartViewModel!

            beforeEach {
                viewModel = ShoppingCartViewModel()
            }

            context("when a new item is added") {
                it("should have one item and the total price should be the price of that item") {
                    let item = CartItem(id: UUID(), name: "Test Item", price: 10.0)
                    viewModel.addItem(item)
                    expect(viewModel.items.count).to(equal(1))
                    expect(viewModel.totalPrice).to(equal(10.0))
                }
            }

            context("when an item is removed") {
                it("should have one less item and the total price should be updated") {
                    let item1 = CartItem(id: UUID(), name: "Test Item 1", price: 10.0)
                    let item2 = CartItem(id: UUID(), name: "Test Item 2", price: 20.0)
                    viewModel.addItem(item1)
                    viewModel.addItem(item2)

                    viewModel.removeItem(at: IndexSet(integer: 0))
                    expect(viewModel.items.count).to(equal(1))
                    expect(viewModel.totalPrice).to(equal(20.0))
                }
            }

            context("when the cart is empty") {
                it("should have zero items and the total price should be zero") {
                    expect(viewModel.items.count).to(equal(0))
                    expect(viewModel.totalPrice).to(equal(0.0))
                }
            }

            context("when a sample item is added") {
                it("should have one more item") {
                    let initialItemCount = viewModel.items.count
                    viewModel.addSampleItem()
                    expect(viewModel.items.count).to(equal(initialItemCount + 1))
                }
            }

            context("when the total price is formatted") {
                it("should be formatted as a string with '원'") {
                    let item = CartItem(id: UUID(), name: "Test Item", price: 10.0)
                    viewModel.addItem(item)
                    expect(viewModel.formattedTotalPrice).to(equal("10원"))
                }
            }
            
            context("when all items are removed") {
                it("should have zero items and the total price should be zero") {
                    let item1 = CartItem(id: UUID(), name: "Test Item 1", price: 10.0)
                    let item2 = CartItem(id: UUID(), name: "Test Item 2", price: 20.0)
                    viewModel.addItem(item1)
                    viewModel.addItem(item2)

                    viewModel.removeItem(at: IndexSet(integersIn: 0...1))
                    expect(viewModel.items.count).to(equal(0))
                    expect(viewModel.totalPrice).to(equal(0.0))
                }
            }
            
            context("when the total price is zero") {
                it("should be formatted as '0원'") {
                    expect(viewModel.formattedTotalPrice).to(equal("0원"))
                }
            }
            
            context("when the total price is a large number") {
                it("should be formatted correctly") {
                    let item = CartItem(id: UUID(), name: "Test Item", price: 1_000_000.0)
                    viewModel.addItem(item)
                    expect(viewModel.formattedTotalPrice).to(equal("1000000원"))
                }
            }

            context("when removing an item from an empty list") {
                it("should not crash and the cart should remain empty") {
                    viewModel.removeItem(at: IndexSet(integer: 0))
                    expect(viewModel.items.count).to(equal(0))
                    expect(viewModel.totalPrice).to(equal(0.0))
                }
            }

            context("when removing an item with an out-of-bounds index") {
                it("should not crash and the cart should remain unchanged") {
                    let item = CartItem(id: UUID(), name: "Test Item", price: 10.0)
                    viewModel.addItem(item)
                    viewModel.removeItem(at: IndexSet(integer: 1))
                    expect(viewModel.items.count).to(equal(1))
                    expect(viewModel.totalPrice).to(equal(10.0))
                }
            }

            context("when adding an item with zero price") {
                it("should have one item and the total price should be zero") {
                    let item = CartItem(id: UUID(), name: "Test Item", price: 0.0)
                    viewModel.addItem(item)
                    expect(viewModel.items.count).to(equal(1))
                    expect(viewModel.totalPrice).to(equal(0.0))
                }
            }

            context("when adding an item with a negative price") {
                it("should have one item and the total price should be negative") {
                    let item = CartItem(id: UUID(), name: "Test Item", price: -10.0)
                    viewModel.addItem(item)
                    expect(viewModel.items.count).to(equal(1))
                    expect(viewModel.totalPrice).to(equal(-10.0))
                }
            }

            context("when adding items with floating point prices") {
                it("should calculate the total price correctly") {
                    let item1 = CartItem(id: UUID(), name: "Test Item 1", price: 0.1)
                    let item2 = CartItem(id: UUID(), name: "Test Item 2", price: 0.2)
                    viewModel.addItem(item1)
                    viewModel.addItem(item2)
                    expect(viewModel.totalPrice).to(beCloseTo(0.3, within: 0.0001))
                }
            }
        }
    }
}

/*
The MIT License (MIT)

Copyright (c) 2018 Daniel Illescas Romero <https://github.com/illescasDaniel>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#if canImport(UIKit)
#if os(watchOS)
#else
import StoreKit

/// A class to inherit from which lets you easily control your purchases.
/// - Note: Instead of `IAP` being a UITableViewController you can change this class so it inherits from a UIViewController.
///
/// # Setup
/// * Inherit from this class
/// * Call `super.viewDidLoad()` inside your `viewDidLoad()`
///
/// # Usage
/// Call `purchase(item: ItemID)`, with the proper ItemID.
open class IAP: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
	
	#if swift(>=4.2)
	enum ItemID: String, CaseIterable {
		case item1 = "com.yourusername.YourAppName.itemToPurchaseName1"
		case item2 = "com.yourusername.YourAppName.itemToPurchaseName2"
		case item3 = "com.yourusername.YourAppName.itemToPurchaseName3"
		case item4 = "com.yourusername.YourAppName.itemToPurchaseName4"
		static var all: Set<String> {
			return Set(self.allCases.map { $0.rawValue })
		}
	}
	#else
	enum ItemID: String {
		case item1 = "com.yourusername.YourAppName.itemToPurchaseName1"
		case item2 = "com.yourusername.YourAppName.itemToPurchaseName2"
		case item3 = "com.yourusername.YourAppName.itemToPurchaseName3"
		case item4 = "com.yourusername.YourAppName.itemToPurchaseName4"
		static let all: Set<String> = [ItemID.item1.rawValue, ItemID.item2.rawValue, ItemID.item3.rawValue, ItemID.item4.rawValue]
	}
	#endif
	
	private var iapProducts: [SKProduct] = []
	
	/// You MUST call this method on your inherited class (`super.viewDidLoad()`)
	override open func viewDidLoad() {
		super.viewDidLoad()
		self.fetchAvailableProducts()
	}
	
	@discardableResult func purchase(item: ItemID) -> Bool {
		
		let product = iapProducts.first {
			$0.productIdentifier == item.rawValue
		}
		
		if let validProduct = product {
			return self.purchase(product: validProduct)
		}
		
		return false
	}
	
	// MARK: SKProductsRequestDelegate
	
	public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		self.iapProducts = response.products
	}
	
	public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
		
		for transaction in transactions {
			
			switch transaction.transactionState {
				
			case .purchased:
				
				SKPaymentQueue.default().finishTransaction(transaction)
				
				let successfulDonationAlert = UIAlertController(title: "IAP_PAYMENT_SUCCESS_TITLE".localized, message: "IAP_PAYMENT_SUCCESS_MESSAGE".localized, preferredStyle: .alert)
				successfulDonationAlert.addAction(title: "IAP_PAYMENT_SUCCESS_OK_DISMISS_BUTTON_TITLE", style: .default)
				
				self.present(successfulDonationAlert, animated: true)
				
			case .failed:
				SKPaymentQueue.default().finishTransaction(transaction)
				
				let failedDonationAlert = UIAlertController(title: "IAP_PAYMENT_ERROR_TITLE".localized, message: "IAP_PAYMENT_ERROR_MESSAGE".localized, preferredStyle: .alert)
				failedDonationAlert.addAction(title: "IAP_PAYMENT_SUCCESS_ERROR_BUTTON_TITLE", style: .default)
				
				self.present(failedDonationAlert, animated: true)
				
			case .restored:
				SKPaymentQueue.default().finishTransaction(transaction)
				
			default: break
			}
		}
	}
	
	// MARK: Convenience
	
	private func canMakePurchases() -> Bool {
		return SKPaymentQueue.canMakePayments()
	}
	
	private func purchase(product: SKProduct) -> Bool {
		
		if self.canMakePurchases() {
			
			let payment = SKPayment(product: product)
			
			SKPaymentQueue.default().add(self)
			SKPaymentQueue.default().add(payment)
			return true
		}
		else {
			
			let alertController = UIAlertController(title: nil, message: "IAP_PURCHASES_DISABLED_ON_DEVICE".localized, preferredStyle: .alert)
			alertController.addAction(title: "IAP_PURCHASES_DISABLED_ERROR_BUTTON_TITLE", style: .default)
			
			self.present(alertController, animated: true)
			return false
		}
	}
	
	private func fetchAvailableProducts()  {
		let productsRequest = SKProductsRequest(productIdentifiers: ItemID.all)
		productsRequest.delegate = self
		productsRequest.start()
	}
}
#endif
#endif

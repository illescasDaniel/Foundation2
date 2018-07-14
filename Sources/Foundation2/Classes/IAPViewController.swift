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
#if !os(watchOS)
import StoreKit

#if swift(>=4.2)
protocol ItemIDProtocol: RawStringRepresentable, CaseIterable { }
#else
protocol ItemIDProtocol: RawStringRepresentable, CaseIterableEnum { }
#endif

/// A class to inherit from which lets you easily control your purchases.
/// - Note: Instead of `IAP` being a UITableViewController you can change this class so it inherits from a UIViewController.
///
/// # Setup
/// * Inherit from this class in a ViewController
/// * Create an Enum which implements `String, ItemIDProtocol`
/// * In your `viewDidLoad()`
/// 	* Call `self.fetchAvailable(products: Set<String>)`. In products use `YourEnumItems.all` to specify all of your products.
/// * Localize the following strings:
/// 	* IAP_PAYMENT_SUCCESS_TITLE, IAP_PAYMENT_SUCCESS_MESSAGE, IAP_PAYMENT_SUCCESS_OK_DISMISS_BUTTON_TITLE
///		* IAP_PAYMENT_ERROR_TITLE, IAP_PAYMENT_ERROR_MESSAGE, IAP_PAYMENT_SUCCESS_ERROR_BUTTON_TITLE
///		* IAP_PURCHASES_DISABLED_ON_DEVICE, IAP_PURCHASES_DISABLED_ERROR_BUTTON_TITLE
///
/// # Usage
/// Call `purchase(item: ItemID)`, with the proper ItemID.
///
/// # Class example:
/** ```

	class TestViewController: IAPViewController {

		enum ItemID: String, ItemIDProtocol {
			case item1 = "com.package"
			case item2 = "com.package.test"
		}

		override func viewDidLoad() {
			super.viewDidLoad()
			self.fetchAvailable(products: ItemID.all)
		}

		// example
		func buttonAction() {
			self.purchase(item: ItemID.item1)
		}
	}
	```
*/
open class IAPViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

	private var iapProducts: [SKProduct] = []
	
	@discardableResult func purchase<ItemType: ItemIDProtocol>(item: ItemType) -> Bool {
		
		let product = self.iapProducts.first {
			$0.productIdentifier == item.rawValue
		}
		
		if let validProduct = product {
			return self.purchase(product: validProduct)
		}
		
		return false
	}
	
	public func fetchAvailable(products: Set<String>)  {
		let productsRequest = SKProductsRequest(productIdentifiers: products)
		productsRequest.delegate = self
		productsRequest.start()
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
}
#endif
#endif

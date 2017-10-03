//
//  ApplePayVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 10/2/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import PassKit
import Stripe

class ApplePayVC: UIViewController {
    
    @IBOutlet weak var applePayBtn: UIButton!
    
    var total: NSDecimalNumber = 10.0
    
    let supportedPaymentNetworks: [PKPaymentNetwork] = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex, PKPaymentNetwork.discover]
    let merchantID = "merchant.com.eliteiosdevelopment.eid"
    
    var customer = [String:Any]()
    var paymentSucceeded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applePayBtn.isEnabled = Stripe.deviceSupportsApplePay()
        
        customer["email"] = "a@a.com"

        addBarButton(imageNormal: "back-white", imageHighlighted: nil, action: #selector(backBtnPressed), side: .west)
    }
    
    @objc func backBtnPressed() {
        self.performSegue(withIdentifier: UNWIND_FEATURE_VC, sender: self)
    }
    
    @IBAction func applePayBtnPressed(_ sender: Any) {
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantID
        request.supportedNetworks = supportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
//        request.requiredShippingAddressFields = PKAddressField.name
//        request.requiredShippingContactFields = PKContactField.emailAddress
        
        var summaryItems = [PKPaymentSummaryItem]()
        summaryItems.append(PKPaymentSummaryItem(label: "iPhone", amount: 10.00))
        summaryItems.append(PKPaymentSummaryItem(label: "Steve", amount: total))

        request.paymentSummaryItems = summaryItems
        
        if Stripe.canSubmitPaymentRequest(request) {
            
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
            applePayController?.delegate = self
            self.present(applePayController!, animated: true, completion: nil)
            
        } else {
            print("There is a problem with your Apple Pay configuration")
        }
    }

}

extension ApplePayVC: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        print("Payment Authorized!")
        
        STPAPIClient.shared().createToken(with: payment) { (token: STPToken?, error: Error?) in
            
            guard let token = token, error == nil else {
                print("CREATE TOKEN ERROR: \(error!)")
                return
            }

            APIManager.shared.processStripePayment(token: token, amount: self.total, description: "Apple Pay Charge", customer: self.customer, Success: { result in
                
                print(result)
                
            }, Failure: { error in
                print(error ?? "No Error.")
            })
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("Payment authorization view controller did finish.")
        controller.dismiss(animated: true, completion: {
            if self.paymentSucceeded {
                print("Show a receipt page.")
            }
        })
    }
    
    //Tells the delegate the user selected a shipping address
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: @escaping (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
//        print("Did Select Shipping Contact: \(contact)")
//    }
    
    //Tells the delegate the user selected a shipping address and asks for an updated payment request
//    @available(iOS 11.0, *)
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, handler completion: @escaping (PKPaymentRequestShippingContactUpdate) -> Void) {
//        print("Did Select Shipping Contact: \(contact)")
//    }
    
    //Tells the delegate the user is authorizing a payment request
//    func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
//        print("User is authorizing a payment request...")
//    }
    
    //Tells the delegate the payment method has changed and asks for summary item updates
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, completion: @escaping ([PKPaymentSummaryItem]) -> Void) {
//        print("Payment method has changed. Please give summary item update")
//    }
    
    //Tells the delegate the user did authorize payment and asks for a result
//    @available(iOS 11.0, *)
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//        print("User did authorize payment. Please give result...")
//    }
    
    //Tells the delegate the payment method has changed and asks for an updated payment request
//    @available(iOS 11.0, *)
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
//        print("Payment method has changed. Please update payment request. (Payment Update)")
//    }
    
    //Tells the delegate the shipping method had changed and asks for an updated payment request
//    @available(iOS 11.0, *)
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
//        print("Shipping method has changed. Please updated payment request. (Shipping Update)")
//    }
    
    //Tells the delegate the user selected a shipping method
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
//        print("User did select shipping method.")
//    }
    
}

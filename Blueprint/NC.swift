//
//  NC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 7/29/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit

class NC: UINavigationController, UINavigationBarDelegate {

//    static var vC: UIViewController!
//    static var previousVC: String!
//    static var mainV: MainV!
//    static var singleActionAlertV: SingleActionAlertV!
//    static var doubleActionAlertV: DoubleActionAlertV!
//    
//    var tabOneVCs = [String]()
//    var tabTwoVCs = [String]()
//    var tabThreeVCs = [String]()
//    var tabFourVCs = [String]()
//    var tabFiveVCs = [String]()
//
    override func viewDidLoad() {
        super.viewDidLoad()
    
        for viewController in self.viewControllers {

//            cacheVC(vC: viewController)
//            
//            NC.vC = viewController
//            NC.mainV = NC.vC.view as! MainV
            viewController.navigationItem.titleView = LogoV(frame: CGRect(x: 0, y: 0, width: 36, height: 36), image: UIImage(named: "chain")!)
        }
        navigationBar.barTintColor = CHAIN_BLUE
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
//        cacheVC(vC: NC.vC)
//        
//        NC.vC = viewController
//        NC.mainV = NC.vC.view as! MainV
        viewController.navigationItem.titleView = LogoV(frame: CGRect(x: 0, y: 0, width: 36, height: 36), image: UIImage(named: "chain")!)
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        removeAlert()
//    }
//    
//    func addBarButton(item: UINavigationItem, imageNormal: String, imageHighlighted: String?, action: Selector, side: Direction) {
//        
//        let button = UIButton(type: .custom)
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        button.addTarget(self, action: action, for: .touchUpInside)
//        button.setImage(UIImage(named: imageNormal), for: .normal)
//        
//        if let img = imageHighlighted {
//            button.setImage(UIImage(named: img), for: .highlighted)
//        }
//        
//        var barButton: UIBarButtonItem!
//        
//        if side == .west {
//
//            barButton = UIBarButtonItem(customView: button)
//            item.leftBarButtonItem = barButton
//            
//        } else if side == .east {
//            
//            barButton = UIBarButtonItem(customView: button)
//            item.rightBarButtonItem = barButton
//        }
//    }
//    
//    func cacheVC(vC: UIViewController) {
//        
//        switch UserDefaults.standard.value(forKey: CURRENT_TAB) as! Int {
//        case 0:
//            tabOneVCs.append("unwindTo" + vC.nameOfClass)
//        case 1:
//            tabTwoVCs.append("unwindTo" + vC.nameOfClass)
//        case 2:
//            tabThreeVCs.append("unwindTo" + vC.nameOfClass)
//        case 3:
//            tabFourVCs.append("unwindTo" + vC.nameOfClass)
//        case 4:
//            tabFiveVCs.append("unwindTo" + vC.nameOfClass)
//        default: break
//        }
//    }
//    
//    func removeAlert() {
//        
//        NC.mainV.removeAlert()
//        
//        if NC.singleActionAlertV != nil {
//            NC.singleActionAlertV.removeFromSuperview()
//        }
//        if NC.doubleActionAlertV != nil {
//            NC.doubleActionAlertV.removeFromSuperview()
//        }
//    }
//    
//    func showLogOut () {
//        
//        NC.doubleActionAlertV = NC.mainV.showDoubleActionAlert(icon: "power", header: "Logout", subHeader: "Are you sure you want to log out?", cancelBtnText: "Cancel", confirmationBtnText: "Ok", backgroundColor: UIColor.white, buttonNormalBackgroundColor: SPACE_GREY, buttonHighlightedBackgroundColor: SPACE_GREY_HIGHLIGHT, animated: true)
//        NC.doubleActionAlertV.cancelBtn.addTarget(self, action: #selector(removeAlert), for: .touchUpInside)
//        NC.doubleActionAlertV.confirmationBtn.addTarget(self, action: #selector(logOut(sender:)), for: .touchUpInside)
//    }
    
//    func logOut(sender: UIButton) {
//        
//        APIManager.shared.logOut(userId: UserDefaults.standard.value(forKey: USER_ID) as! String, Success: { good in
//            
//            if good {
//                self.performSegue(withIdentifier: UNWIND_LOGIN_VC, sender: self)
//            }
//            
//        }, Failure: { error in
//            
//            switch error {
//            case .internalServerError:
//                print(ErrorHandler.internalServerError)
//            case .noData:
//                print(ErrorHandler.noData)
//            case .methodError:
//                print(ErrorHandler.methodError)
//            default:
//                print(ErrorHandler.failedAttempt)
//            }
//        })
//    }
    
//    func unwindToPrevious() {
//        
//        let index = UserDefaults.standard.value(forKey: CURRENT_TAB) as! Int
//        switch index {
//        case 0:
//            performSegue(withIdentifier: tabOneVCs.popLast()!, sender: self)
//        case 1:
//            performSegue(withIdentifier: tabTwoVCs.popLast()!, sender: self)
//        case 2:
//            performSegue(withIdentifier: tabThreeVCs.popLast()!, sender: self)
//        case 3:
//            performSegue(withIdentifier: tabFourVCs.popLast()!, sender: self)
//        case 4:
//            performSegue(withIdentifier: tabFiveVCs.popLast()!, sender: self)
//        default:
//            break
//        }
//    }

}

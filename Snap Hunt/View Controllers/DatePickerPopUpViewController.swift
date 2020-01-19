//
//  DatePickerPopUpViewController.swift
//  Snap Hunt
//
//  Created by Surjit Chowdhary on 19/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit

class DatePickerPopUpViewController: UIViewController {

    //invoking controllers
    class func initiateDatePopUpVC() -> DatePickerPopUpViewController {
        guard let popUpViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerPopUpViewController") as? DatePickerPopUpViewController else {
            return DatePickerPopUpViewController()
        }
        return popUpViewController
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!

    var date = Date()
    var doneCompletionHandler: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.datePicker.date = self.date
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
    }
    

    @IBAction func onDateChange(_ sender: UIDatePicker) {
        self.date = sender.date
    }

    @IBAction func onDoneTapped(_ sender: UIButton) {
        self.dismissWithFadeTransition {
            self.doneCompletionHandler?(self.date)
        }
    }

}

extension UIViewController {
    internal func showDatePickerPopUp(date: Date, completion: ((Date) -> Void)?) {
        DispatchQueue.main.async {
            let datePopUpVC = DatePickerPopUpViewController.initiateDatePopUpVC()
            datePopUpVC.date = date
            datePopUpVC.doneCompletionHandler = completion
            datePopUpVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                datePopUpVC.modalPresentationStyle = .overFullScreen
            UIApplication.getTopMostViewController()?.present(datePopUpVC, animated: true, completion: .none)
            }
        }

    internal func dismissWithFadeTransition(completion: (() -> Void)?) {
        let transition: CATransition = CATransition()
        transition.duration = 0.1
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: {
            completion?()
        })
    }

    }


extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
}

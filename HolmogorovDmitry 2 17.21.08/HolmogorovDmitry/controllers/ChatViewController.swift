import UIKit
import Foundation

class ChatViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //scroll?.addGestureRecognizer(hideKeyboardGesture)

    }
    //MARK:- key board funcs
    @objc func keyBoardAppeared(_ notification: Notification) {
        if let keyboardInfo = notification.userInfo as NSDictionary? {
            let size = (keyboardInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
//            self.scroll.contentInset = contentInset
//            self.scroll.scrollIndicatorInsets = contentInset
        }
    }
    
    @objc func keyBoardWasHidden() {
//        self.scroll.contentInset = UIEdgeInsets.zero
//        self.scroll.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    @objc func hideKeyboard() {
        //self.scroll?.endEditing(true)
    }
    

    private func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    //MARK:- Notification
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardAppeared(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardWasHidden),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: nil)
    }
    
    
    @IBAction func unwindFirst(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    
    
    
}


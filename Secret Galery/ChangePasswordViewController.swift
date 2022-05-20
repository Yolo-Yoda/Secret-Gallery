import UIKit
import SwiftKeychainWrapper
// MARK: - Public properties
// MARK: - IBOutlets
// MARK: - Override methods
// MARK: - Public methods
// MARK: - Private methods
// MARK: - IBActions

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var oldPassword: UITextField!
    
    @IBOutlet weak var firstNewPassword: UITextField!
    
    @IBOutlet weak var secondNewPassword: UITextField!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeybordNotification()
        oldPassword.delegate = self
        firstNewPassword.delegate = self
        secondNewPassword.delegate = self
    }
    // MARK: - Public methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                  return false
              }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
    
    func clearAll () {
        oldPassword.text?.removeAll()
        firstNewPassword.text?.removeAll()
        secondNewPassword.text?.removeAll()
    }
    
    func performSeque() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private methods
    
    private func registerKeybordNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeybord(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(offKeybord(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    func onKeybord(_ nofication: NSNotification) {
        guard let info = nofication.userInfo,
              let keybordSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keybordSize.height, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc
    func offKeybord(_ nofication: NSNotification) {
        guard let info = nofication.userInfo,
              let _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else { return }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButton(_ sender: Any) {
        performSeque()
    }
    
    @IBAction func doneButton(_ sender: Any) {
        guard oldPassword.text == KeychainWrapper.standard.string(forKey: "password"),
              firstNewPassword.text?.count == 4,
              firstNewPassword.text == secondNewPassword.text else {
                  showPasswordIncorrectAllert()
                  return }
        guard firstNewPassword.text != "" else {
            showPasswordIncorrectAllert()
            return }
        KeychainWrapper.standard.removeObject(forKey: "password")
        KeychainWrapper.standard.set(firstNewPassword.text ?? "", forKey: "password")
        clearAll()
        performSeque()
    }
    
}


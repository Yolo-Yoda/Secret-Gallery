import UIKit
import LocalAuthentication
import SwiftKeychainWrapper
import SwiftUI

class PinViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Public properties
    let password : [Int] = [1, 5, 4, 8]
    
    var newPassword: String = ""
    
    var passwordFill : [Int] = []
    
    let myColor = UIColor(red: 0.66, green: 0.02, blue: 0.19, alpha: 1.00)
    
    // MARK: - IBOutlets
    
    @IBOutlet var allButtons: [UIButton]!
    
    @IBOutlet var allDots: [UIButton]!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        roundButtons()
        super.viewDidLoad()
        firstStartApp()
    }
    
    // MARK: - Public methods
    
    func firstStartApp() {
        if !UserDefaults.standard.bool(forKey: "firstStartedApp") {
            showPasswordAllert()
        }
    }
    
    func roundButtons () {
        for button in allButtons {
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }
    }
    
    
    
    func makeAllUncolorDots() {
        for dot in allDots {
            dot.tintColor = UIColor.lightGray
        }
    }
    
    func deleteAllAtPasswordFill() {
        passwordFill.removeAll()
    }
    func addNumbertoPasswordFill (_ inputNumber : Int) {
        animationOfButton(inputNumber)
        makeColorDots(passwordFill.count, 1)
        if passwordFill.count < 4 {
            passwordFill.append(inputNumber)
            checkPassword()
        }
    }
    
    func deleteNumberInPasswordFill (_ senderTag : Int) {
        animationOfButton(senderTag)
        if passwordFill.count > 0 {
            passwordFill.removeLast()
            makeColorDots(passwordFill.count, 2)
        }
    }
    
    func checkPassword() {
        
        guard passwordFill.count == 4 else { return }
        for characterInteger in passwordFill {
            newPassword += "\(characterInteger)"
        }
        guard newPassword == KeychainWrapper.standard.string(forKey: "password") else {
            showPasswordInCorrectAllert()
            passwordFill.removeAll()
            makeAllUncolorDots()
            newPassword = ""
            return
        }
        performSeque()
    }
    
    func animationOfButton (_ senderTag: Int) {
        UIView.animate(withDuration: 0.05, delay: 0) { [weak self] in
            self?.allButtons[senderTag].layer.borderColor = self?.myColor.cgColor
            self?.allButtons[senderTag].layer.borderWidth = 3
            self?.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.05, delay: 0) { [weak self] in
                self?.allButtons[senderTag].layer.borderColor = UIColor.clear.cgColor
                self?.allButtons[senderTag].layer.borderWidth = 0
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    func makeColorDots(_ numberOfPosition: Int,_ color1uncolor2: Int) {
        guard color1uncolor2 == 1 else {
            allDots[numberOfPosition].tintColor = UIColor.lightGray
            return
        }
        allDots[numberOfPosition].tintColor = UIColor(red: 0.66, green: 0.02, blue: 0.19, alpha: 1.00)
    }
    
    func performSeque() {
        DispatchQueue.main.async { [weak self] in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
            self?.present(vc, animated: true)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func pushButton(_ sender: UIButton) {
        addNumbertoPasswordFill(sender.tag)
    }
    
    @IBAction func back(_ sender: UIButton) {
        deleteNumberInPasswordFill(sender.tag)
    }
    
    @IBAction func faceIDPush(_ sender: UIButton) {
        animationOfButton(sender.tag)
        guard #available(iOS 8.0, *) else {
            return print("Not supported")
        }
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return print(error as Any)
        }
        let reason = "Face ID authentication"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] isAuthorized, error in
            guard isAuthorized == true else {
                return print(error as Any)
            }
            self?.performSeque()
        }
    }
}

extension PinViewController {
    
    // MARK: - Public methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitLength = 4
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
    
    func showPasswordAllert() {
        let alertController = UIAlertController(title: "Установите пароль",
                                                message: "Пароль состоит из 4 символов",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .destructive) { (_) in
            exit(0)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Введите ваш пароль"
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.isSecureTextEntry = true
        }
        let confirmAction = UIAlertAction(title: "Добавить",
                                          style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                if text.count == 4 {
                    KeychainWrapper.standard.set(text, forKey: "password")
                    UserDefaults.standard.set(true, forKey: "firstStartedApp")
                } else {
                    self.showIncorrectPasswordAllert()
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showIncorrectPasswordAllert() {
        let alertController = UIAlertController(title: "Неверный пароль",
                                                message: "Пароль должен состоять из 4 символов",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Выход",
                                         style: .destructive) { (_) in
            exit(0)
        }
        let confirmAction = UIAlertAction(title: "Заново",
                                          style: .default) { (_) in
            self.showPasswordAllert()
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

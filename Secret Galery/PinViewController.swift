//
//  ViewController.swift
//  Secret Galery
//
//  Created by Виктор Васильков on 25.04.22.
//

import UIKit
import LocalAuthentication

class PinViewController: UIViewController {
    
    let password : [Int] = [1, 5, 4, 8]
    
    var passwordFill : [Int] = []
    
    let myColor = UIColor(red: 0.66, green: 0.02, blue: 0.19, alpha: 1.00)
    
    @IBOutlet var allButtons: [UIButton]!
    
    @IBOutlet var allDots: [UIButton]!
    
    override func viewDidLoad() {
        roundButtons()
        super.viewDidLoad()
    }
    
    func roundButtons () {
        for button in allButtons {
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.frame.height / 2
            button.layer.masksToBounds = true
        }
    }
    
    func makeColorDots(_ numberOfPosition: Int,_ color1uncolor2: Int) {
        guard color1uncolor2 == 1 else {
            allDots[numberOfPosition].tintColor = UIColor.lightGray
            return
        }
        allDots[numberOfPosition].tintColor = UIColor(red: 0.66, green: 0.02, blue: 0.19, alpha: 1.00)
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
        guard passwordFill == password else {
            showPasswordInCorrectAllert()
            passwordFill.removeAll()
            makeAllUncolorDots()
            return
        }
        performSeque()
    }
    
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
    
    func performSeque() {
        DispatchQueue.main.async { [weak self] in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainViewController") else { return }
            self?.present(vc, animated: true)
        }
    }
    
}


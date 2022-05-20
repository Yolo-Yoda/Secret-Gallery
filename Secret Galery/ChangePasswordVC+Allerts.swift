import Foundation
import UIKit
import SwiftKeychainWrapper

extension ChangePasswordViewController {
    
    // MARK: - Public methods
    
    func showPasswordIncorrectAllert() {
        let alert = UIAlertController(title: "Неверный пароль",
                                      message: "Введенный пароль неверен",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Заново",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            self.clearAll()
        }))
        alert.addAction(UIAlertAction(title: "Выход",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            self.performSeque()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

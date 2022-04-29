import UIKit

extension UIViewController{
    
    // MARK: - Public methods
    
    func showPasswordInCorrectAllert() {
        let alert = UIAlertController(title: "Password incorrect",
                                      message: "try again",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Try again",
                                      style: UIAlertAction.Style.default))
        alert.addAction(UIAlertAction(title: "Exit",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            exit(0)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


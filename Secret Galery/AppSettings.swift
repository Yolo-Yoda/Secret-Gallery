import Foundation
import UIKit

class AppSettings {
    
    public static var shared = AppSettings()
    
    private init() { }
 
    var countOfImages: Int {
        get {
            UserDefaults.standard.integer(forKey: UserDefaultsKeys.countOfImages.rawValue)
        }
        set (newCount) {
            UserDefaults.standard.set(newCount, forKey: UserDefaultsKeys.countOfImages.rawValue)
        }
    }
    
    var arrayOfImages: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.arrayOfImages.rawValue) ?? []
        }
        set (newName) {
            UserDefaults.standard.set(newName, forKey: UserDefaultsKeys.arrayOfImages.rawValue)
        }
    }
}

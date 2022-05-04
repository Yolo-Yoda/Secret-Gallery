import Foundation
import UIKit
import Alamofire

extension MainViewController {
    
    func openGalery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.",
                                           preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            saveImage(nil, pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func takePictureFromURL(_ StringURL: String) {
        AF.request(StringURL, method: .get, parameters: nil).responseData { [weak self] response in
            if let status = response.response?.statusCode {
                guard (200..<300).contains(status) else {
                    print("Wrong response status: \(status)")
                    return
                }
                let url = URL(string: "\(StringURL)")!
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self?.saveImage(data, nil)
                        }
                    }
                }
            }
        }
    }
    
    func saveImage(_ data: Data?, _ pickedImage: UIImage?) {
        let nameOfImage = "image\(AppSettings.shared.countOfImages)"
        if data == nil {
            guard let pickedImage = pickedImage else { return }
            FileStorage.saveImage(pickedImage, withName: nameOfImage)
            self.images.append(pickedImage)
        } else {
            guard let data = data else { return }
            FileStorage.saveImage(UIImage(data: data), withName: nameOfImage)
            guard let image = FileStorage.getImage(withName: nameOfImage) else { return }
            self.images.append(image)
        }
        AppSettings.shared.arrayOfImages.append(nameOfImage)
        AppSettings.shared.countOfImages += 1
        self.collectionView.reloadData()
    }
                    
    func appendImages() {
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default) {_ in
            self.openGalery()
        })
        alert.addAction(UIAlertAction(title: "Камера", style: .default) {_ in
            self.openCamera()
        })
        alert.addAction(UIAlertAction(title: "По ссылке", style: .default) {_ in
            self.showURLAllert()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
                      
    func showURLAllert() {
        let alertController = UIAlertController(title: "Введите URL",
                                                message: nil,
                                                preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Добавить",
                                          style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                if self.canOpenURL(text) == true {
                    self.takePictureFromURL(text)
                } else {
                    self.incorrectURLAllert()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена",
                                          style: .destructive) { (_) in }
         alertController.addTextField { (textField) in
             textField.placeholder = "Введите URL"
         }
         alertController.addAction(confirmAction)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
    }
    
    func incorrectURLAllert() {
        let alert = UIAlertController(title: "URL неверен",
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Заново",
                                      style: UIAlertAction.Style.default) {_ in
            self.showURLAllert()
        })
        alert.addAction(UIAlertAction(title: "Выход",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
              let url = URL(string: urlString)
        else { return false }
        
        if !UIApplication.shared.canOpenURL(url) { return false }
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
}

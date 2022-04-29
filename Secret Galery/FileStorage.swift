import UIKit

class FileStorage {
    static func saveImage(_ image: UIImage?, withName filename: String) {
        guard let image = image,
              let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        let fileURL = URL(fileURLWithPath: filename, relativeTo: directoryURL).appendingPathExtension("jpeg")
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        try? data.write(to: fileURL)
    }
    
    static func getImage(withName filename: String) -> UIImage? {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }
        let fileURL = URL(fileURLWithPath: filename, relativeTo: directoryURL).appendingPathExtension("jpeg")
        guard let savedData = try? Data(contentsOf: fileURL) else { return nil }
        
        return UIImage(data: savedData)
    }
}

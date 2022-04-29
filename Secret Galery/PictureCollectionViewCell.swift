import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(for image: UIImage) {
        self.pictureView.image = image
        self.pictureView.contentMode = .scaleAspectFill
    }
    

}

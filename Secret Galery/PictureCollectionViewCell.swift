import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var pictureView: UIImageView!
    
    // MARK: - Override methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public methods
    
    func setup(for image: UIImage) {
        self.pictureView.image = image
        self.pictureView.contentMode = .scaleAspectFill
    }
}

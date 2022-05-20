import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // MARK: - Public properties
    
    var images : [UIImage] = []
    let countCells = 3
    let cellID = "PhotoCell"
    let offset : CGFloat = 2.0
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImagesToImageArray()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
    }
    
    // MARK: - Public methods
    
    func loadImagesToImageArray() {
        guard AppSettings.shared.arrayOfImages.count != 0 else { return }
        for namePicture in AppSettings.shared.arrayOfImages {
            guard let image = FileStorage.getImage(withName: namePicture) else { return }
            images.append(image)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addImage(_ sender: Any) {
        appendImages()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Public methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PictureCollectionViewCell
        cell.setup(for: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameCollectionView = view.frame
        let widthCell = frameCollectionView.width / CGFloat(countCells)
        let heightCell = widthCell
        
        let spacing = CGFloat(countCells + 1) * offset / CGFloat(countCells)
        
        return CGSize(width: widthCell - spacing, height: heightCell - (offset * 2))
    }
}




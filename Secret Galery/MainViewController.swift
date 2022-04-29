import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var images : [UIImage] = []
    let countCells = 3
    let cellID = "PhotoCell"
    let offset : CGFloat = 2.0

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "PictureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
    }

    @IBAction func addImage(_ sender: Any) {
        appendImages()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppSettings.shared.arrayOfImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PictureCollectionViewCell
        guard let picture = FileStorage.getImage(withName: AppSettings.shared.arrayOfImages[indexPath.item]) else { return cell}
        cell.setup(for: picture)
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




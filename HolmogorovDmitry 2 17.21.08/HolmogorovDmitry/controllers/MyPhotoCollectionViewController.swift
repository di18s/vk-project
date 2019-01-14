import UIKit
import  SwiftyJSON
import  Kingfisher
import RealmSwift

class MyPhotoCollectionViewController: UICollectionViewController {
    var myPhotosRealm: Results<MyPhoto>?
    private var tokenMyPhoto: NotificationToken?
    private let networkServiceMyPhoto = PhotoNetwork()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkServiceMyPhoto.loadMyPhotoAlamofire(){ (my_photos, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let photo = my_photos else { return }
            
            DatabaseService.saveToRealm(items: photo, config: DatabaseService.configuration, update: true)
        }
        
        self.myPhotosRealm = DatabaseService.loadFromRealm(MyPhoto.self)
        updateMyPhoto()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tokenMyPhoto?.invalidate()
    }
    
    //MARK: - update realm
    private func updateMyPhoto(){
        
        self.tokenMyPhoto = self.myPhotosRealm?.observe { [weak self] (changes: RealmCollectionChange) in
            
            guard let collectionView = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPhotosRealm?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "myPhotoCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MyPhotoCollectionViewCell, let myPhotos_Realm = self.myPhotosRealm else {fatalError()}
        
        let photo = myPhotos_Realm[indexPath.row]
        cell.myPhotoImg.kf.setImage(with: URL(string: photo.photo))
        return cell
    }
    
    // MARK:- Переход на след вью при нажатии на фото
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCellIndexRow = collectionView?.indexPathsForSelectedItems

        let setPhoto = segue.destination as! ZoomPhotoFriendViewController
        guard let myPhotosRealm = self.myPhotosRealm else {
            fatalError()
        }
        setPhoto.linkForPhoto = myPhotosRealm[selectedCellIndexRow?.first?.row ?? 0].photo
    }

}


extension MyPhotoCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

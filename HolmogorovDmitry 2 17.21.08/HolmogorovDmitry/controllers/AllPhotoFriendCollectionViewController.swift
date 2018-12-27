import UIKit
import  SwiftyJSON
import  Kingfisher
import RealmSwift

class AllPhotoCollectionViewController: UICollectionViewController {
    
    var friendId = 1 //значение передается из контроллера друзей
    var photosRealm: Results<PhotoFriend>?
    private var tokenPhoto: NotificationToken?
    private let networkService = PhotoNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadUserPhotoAlamofire(ownerId: friendId){ (photos, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let photo = photos else { return }
            DatabaseService.saveToRealm(items: photo, config: DatabaseService.configuration, update: true)
        }
        
        self.photosRealm = DatabaseService.loadFromRealm(PhotoFriend.self)?.filter("user_Id = %@", self.friendId)
        
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tokenPhoto?.invalidate()
    }
    
    //MARK: - update realm
    private func update(){

        self.tokenPhoto = self.photosRealm?.observe { [weak self] (changes: RealmCollectionChange) in

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
    
    // MARK:- Переход на след вью при нажатии на фото
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCellIndexRow = collectionView?.indexPathsForSelectedItems
        
        let setPhoto = segue.destination as! ZoomPhotoFriendViewController
        guard let photos_Realm = self.photosRealm else {
            fatalError("error")
        }
        
        setPhoto.linkForPhoto = photos_Realm[selectedCellIndexRow?.first?.row ?? 0].photo
    }
}

// MARK: UICollectionViewDataSource
extension AllPhotoCollectionViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photosRealm?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "cellAllPhoto"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? AllPhotoCollectionViewCell, let photos_Realm = self.photosRealm else {
            fatalError("The dequeued cell is not an instance of PhotoCollectionViewCell.")
        }
        
        // Configure the cell
        cell.configurePhotoFriendCell(with: photos_Realm[indexPath.row])
        cell.touchLike(photos_Realm[indexPath.row])
        
        return cell
    }
    
}


extension AllPhotoCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.view.bounds.width, height: 400)
    }
}

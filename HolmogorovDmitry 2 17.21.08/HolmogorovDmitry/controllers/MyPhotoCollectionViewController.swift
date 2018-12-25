//
//  MyPhotoCollectionViewController.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 03/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import  SwiftyJSON
import  Kingfisher
import RealmSwift

class MyPhotoCollectionViewController: UICollectionViewController {
    var myPhoto = [MyPhoto]()
    private let networkServiceMyPhoto = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.networkServiceMyPhoto.loadMyPhotoAlamofire(){ [weak self ] (my_photos, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let photo = my_photos, let self = self else { return }
            
            self.myPhoto = photo

            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPhoto.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "myPhotoCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MyPhotoCollectionViewCell else {fatalError()}
        
        let photo = self.myPhoto[indexPath.row]
        cell.myPhotoImg.kf.setImage(with: URL(string: photo.photo))
        return cell
    }
    
    // MARK:- Переход на след вью при нажатии на фото
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedCellIndexRow = collectionView?.indexPathsForSelectedItems

        let setPhoto = segue.destination as! ZoomPhotoFriendViewController
        
        setPhoto.linkForPhoto = self.myPhoto[selectedCellIndexRow?.first?.row ?? 0].photo

    }

}


extension MyPhotoCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}

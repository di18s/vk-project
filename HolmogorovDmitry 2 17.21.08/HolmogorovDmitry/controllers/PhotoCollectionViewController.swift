//
//  PhotoCollectionViewController.swift
//  contraints
//
//  Created by Дмитрий on 25/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

//Контроллер не используется в данный момент
import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    @IBOutlet weak var BackImg: UIImageView!
    private var photoFriend = [PhotoFriend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPhoto()
//        let recogn = UITapGestureRecognizer(target: self, action: #selector(groupAnimations))
//        collection_view.addGestureRecognizer(recogn)

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoFriend.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "cellPhoto"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("The dequeued cell is not an instance of PhotoCollectionViewCell.")
        }
    
        // Configure the cell
        let photoF = photoFriend[indexPath.row]
        cell.friendsPhoto.image = photoF.photo
        
        //Blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.backImg.addSubview(blurEffectView)
        cell.backImg.image = photoF.photo
        cell.backgroundColor = UIColor(patternImage: cell.backImg.image!)
        
        
        return cell
    }
    
    //MARK:- load photo
    private func loadPhoto(){
        let photo1 = UIImage(named: "Cristiano1")
        let photo2 = UIImage(named: "Cristiano2")
        let photo3 = UIImage(named: "Cristiano3")
        let photo4 = UIImage(named: "Pavel1")
        let photo5 = UIImage(named: "Pavel2")
        let photo6 = UIImage(named: "Pavel3")
        let photo7 = UIImage(named: "Robert1")
        let photo8 = UIImage(named: "Robert2")
        let photo9 = UIImage(named: "Robert3")

        
        guard let friendP1 = PhotoFriend(photo: photo1) else{
            fatalError("Unable to instantiate friendP1")
        }
        guard let friendP2 = PhotoFriend(photo: photo2) else{
            fatalError("Unable to instantiate friendP2")
        }
        guard let friendP3 = PhotoFriend(photo: photo3) else{
            fatalError("Unable to instantiate friendP3")
        }
        guard let friendP4 = PhotoFriend(photo: photo4) else{
            fatalError("Unable to instantiate friendP4")
        }
        guard let friendP5 = PhotoFriend(photo: photo5) else{
            fatalError("Unable to instantiate friendP5")
        }
        guard let friendP6 = PhotoFriend(photo: photo6) else{
            fatalError("Unable to instantiate friendP6")
        }
        guard let friendP7 = PhotoFriend(photo: photo7) else{
            fatalError("Unable to instantiate friendP4")
        }
        guard let friendP8 = PhotoFriend(photo: photo8) else{
            fatalError("Unable to instantiate friendP5")
        }
        guard let friendP9 = PhotoFriend(photo: photo9) else{
            fatalError("Unable to instantiate friendP6")
        }
        
        photoFriend += [friendP1, friendP2, friendP3, friendP4, friendP5, friendP6, friendP7, friendP8, friendP9]
    }
    // MARK: UICollectionViewDelegate

    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

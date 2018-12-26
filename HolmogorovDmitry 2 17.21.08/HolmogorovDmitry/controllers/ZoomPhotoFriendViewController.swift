import UIKit

class ZoomPhotoFriendViewController: UIViewController {

    @IBOutlet weak var zoomPhoto: UIImageView!
    var linkForPhoto: String?
    private var idZoom: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomPhoto.kf.setImage(with: URL(string: linkForPhoto ?? "https://vk.com/id1?z=photo1_456316241%2Fphotos1"))
        
        let zoomPhotoFriend = UITapGestureRecognizer(target: self, action: #selector(zoomzoom))
        self.zoomPhoto.addGestureRecognizer(zoomPhotoFriend)
        
        let closeAndReturnBack = UISwipeGestureRecognizer(target: self, action: #selector(closeAndBAck))
        closeAndReturnBack.direction = .down
        self.zoomPhoto.addGestureRecognizer(closeAndReturnBack)
    }
    
    @IBAction func handleRecognizer(_ sender: UIPanGestureRecognizer) {
        if idZoom {
            return
        } else{
            let location = sender.location(in: view)
            zoomPhoto.center = location
            if sender.state == UIGestureRecognizer.State.began{
            
            } else if sender.state == UIGestureRecognizer.State.changed{
            
            }else if sender.state == UIGestureRecognizer.State.ended{
            
            }
        }
    }
    
    @objc func closeAndBAck(){
        
        print("Тут будет код закрытия окна")
    }
    
    @objc func zoomzoom(){
        switch idZoom {
        case true:
            UIView.animateKeyframes(withDuration: 1,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.25,
                                                           animations: {
                                                            self.zoomPhoto.transform = CGAffineTransform(scaleX: 1.45, y: 1.45)
                                                            self.navigationController?.isNavigationBarHidden = true
                                                            
                                        })
                                        
            }, completion: { _ in
                self.idZoom = false
            })
        case false:
            UIView.animateKeyframes(withDuration: 1,
                                    delay: 0,
                                    options: [],
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.25,
                                                           animations: {
                                                            self.zoomPhoto.transform = .identity
                                                            self.navigationController?.isNavigationBarHidden = false
                                        })
            }, completion: { _ in
                self.idZoom = true
            })
        }
    }
}

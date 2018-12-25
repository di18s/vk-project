//Домашка №7 2 и 3 задание
//Не используется в данный момент
import UIKit

class PhotoViewController: UIViewController {

    //MARK:- Оутлеты кнопок и фото
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nextPhoto1: UIImageView!
    @IBOutlet weak var startTurnBtn: UIButton!
    @IBOutlet weak var stopTurnBtn: UIButton!
    
    //MARK:- локальные проперти
    private var arrayPhoto = [UIImage]()
    private var photo1: UIImage = UIImage(named: "cr7")!
    private var photo2: UIImage = UIImage(named: "cr71")!
    private var photo3: UIImage = UIImage(named: "cr72")!
    private var photo4: UIImage = UIImage(named: "durov")!
    private var photo5: UIImage = UIImage(named: "durov1")!
    private var photo6: UIImage = UIImage(named: "durov2")!
    private var x = 0
    private var y = 1
    private var periodTurnPhoto: Timer!
    
    //MARK:- вью дид лоад)
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayPhoto += [photo1, photo2, photo3, photo4, photo5, photo6]
        swipePhotoNext()
        swipePhotoBack()
        stopTurnBtn.isHidden = true
        stopTurnBtn.setImage(UIImage(named: "stop"), for: .normal)
        startTurnBtn.setImage(UIImage(named: "play"), for: .normal)
        shadowForPhoto(photoView: photo)
        shadowForPhoto(photoView: nextPhoto1)
    }
    
    //MARK:- Кнопки управления перелистыванием
    @IBAction func startTurnOver(_ sender: Any) {
        startTurnBtn.isHidden = true
        stopTurnBtn.setImage(UIImage(named: "stop"), for: .normal)
        stopTurnBtn.isHidden = false
        periodTurnPhoto = Timer.scheduledTimer(timeInterval: 2.10, target: self, selector: #selector(groupAnimations), userInfo: nil, repeats: true)
        
    }
    @IBAction func stopTurnOver(_ sender: Any) {
        stopTurnBtn.isHidden = true
        startTurnBtn.isHidden = false
        periodTurnPhoto.invalidate()
    }
    
    //MARK:- функции свайп рекогнайзера назад и вперед
    private func swipePhotoNext(){
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(groupAnimations))
        recognizer.direction = .left
        self.view.addGestureRecognizer(recognizer)
    }
    private func swipePhotoBack(){
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(groupAnimationsBack))
        recognizer.direction = .right
        self.view.addGestureRecognizer(recognizer)
    }
    private func shadowForPhoto(photoView: UIImageView){
        photoView.layer.shadowColor = UIColor.black.cgColor
        photoView.layer.backgroundColor = UIColor.white.cgColor
        photoView.layer.shadowOpacity = 5.8
        photoView.layer.shadowRadius = 20
        photoView.layer.shadowOffset = CGSize.init(width: 7, height: 0)
        
    }
    //MARK:- Анимация перелистывания
    @objc func groupAnimationsBack(_ sender: Any) {
        guard x >= 0 else {
            return x = arrayPhoto.count - 1
        }
        photo.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animateKeyframes(withDuration: 2,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.nextPhoto1.frame.origin.x += 1000
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.photo.image = self.arrayPhoto[self.x]
                                                        self.photo.transform = .identity
                                    })
                                    
        }, completion: { _ in
            self.nextPhoto1.image = self.photo.image
        })
        x -= 1
    }
    @objc func groupAnimations(_ sender: Any) {
        guard y < arrayPhoto.count else {
            return y = 0
        }
        nextPhoto1.transform = CGAffineTransform(translationX: +self.view.bounds.width*3, y:0)
        UIView.animateKeyframes(withDuration: 2,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.photo.image = self.nextPhoto1.image
                                                        self.photo.layer.bounds = CGRect.init(x: self.photo.layer.bounds.origin.x, y: self.photo.layer.bounds.origin.y, width: self.photo.layer.bounds.width/2, height: self.photo.layer.bounds.height/2)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        self.nextPhoto1.image = self.arrayPhoto[self.y]
                                                        self.nextPhoto1.transform = .identity
                                    })
        },completion: nil)
    y += 1
    }
}

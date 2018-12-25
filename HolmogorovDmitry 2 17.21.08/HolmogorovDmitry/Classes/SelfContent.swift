import UIKit

class SelfContent {
    var imageCell: UIImage?
    var nameCell: String = ""
    
    init?(imageCell: UIImage?, nameCell: String) {
        guard let image = imageCell else {return}
        
        self.imageCell = image
        self.nameCell = nameCell
    }
}

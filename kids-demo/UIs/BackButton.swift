import UIKit

final class BackButton: LoadableFromXibView {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet var contentView: UIView!
    @IBInspectable var buttonImage: UIImage = UIImage() {
        didSet{
            if let mainImage = mainImage {
                mainImage.image = buttonImage
            }
            
            
        }
    }
    
    @IBInspectable var rtlFlip: String?
    @IBInspectable var isFlipped: String?
    
    var dirFactor:CGFloat = 1
    var buttonClickFunction: (()-> Void)?
    var deltaHight : CGFloat!

    override func layoutSubviews() {
        super.layoutSubviews()
        var langFactor:CGFloat = 1
        var sideFactor:CGFloat = 1
        if  isFlipped != nil && isFlipped == "1" {
            langFactor = -1
        }
        if rtlFlip != nil && rtlFlip == "1" {
            sideFactor = -1
        }
        dirFactor = langFactor * sideFactor
        mainImage.transform = CGAffineTransform(scaleX: dirFactor, y: 1.0)
    }
    
    func animateButtonStatus (status: Int) {
        UIView.animate(withDuration: 0.08) {
            self.setButtonStatus (status : status )
        }
    }
    
    func setButtonStatus (status : Int ){
        if status == 1 {
            self.mainImage?.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        } else {
            self.mainImage?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        self.layoutIfNeeded()
    }
    
    @IBAction func touchDownBtn(_ sender: Any) {
        self.animateButtonStatus (status : 1)
    }
    
    @IBAction func touchUpBtn(_ sender: Any) {
        self.animateButtonStatus (status : 0)
        if buttonClickFunction != nil {
            buttonClickFunction!()
        }
    }
    
    @IBAction func DragOutBtn(_ sender: Any) {
        self.animateButtonStatus(status : 0)
    }
}

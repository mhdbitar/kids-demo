import UIKit

protocol GenderButttonDelegate: AnyObject {
    func setGender(gender: String)
}

final class SelectGenderButton: LoadableFromXibView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var genderText: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backGround: CustomView!
    @IBOutlet weak var checkMark: UIImageView!
    
    weak var delegate: GenderButttonDelegate?
    var myGender:String = "m"
    var locked:Bool = false
    var imgPart1: String = ""
    var imgPart2: String = ""
    
    func setup(gender:String, delegateView: GenderButttonDelegate?, selected:Bool = false) {
        delegate = delegateView
        checkMark.alpha = 0
        myGender = gender
        locked = false
        self.imgPart2 = "normal"
        if(gender == "f"){
            self.genderText.text = "Female"
            imgPart1 = "girl_"
            
        }else{
            self.genderText.text = "Male"
            imgPart1 = "boy_"
            self.avatar.image = UIImage(named: "Gender-Boy")
        }
        self.avatar.image = UIImage(named: "\(imgPart1)\(imgPart2)")
        animateSelected(selected: selected);
        
    }
    
    func animateSelected(selected:Bool) {
        if selected {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
                self.backGround.backgroundColor = self.UIColorFromHex(rgbValue: 0xFFCE12, alpha: 1.0)
                self.checkMark.isHidden = false
                self.checkMark.alpha = 1
            })
            
            self.imgPart2 = "active"
        } else {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
                self.backGround.backgroundColor = self.UIColorFromHex(rgbValue: 0xFFFFFF, alpha: 1.0)
                self.checkMark.alpha = 0
            })
            self.imgPart2 = "normal"
        }
        self.avatar.image = UIImage(named: "\(imgPart1)\(imgPart2)")
    }
    
    @IBAction func GenderButtonClick(_ sender: Any) {
        if(!locked){
            animateSelected(selected: true)
            delegate?.setGender(gender: myGender);
        }
    }
}

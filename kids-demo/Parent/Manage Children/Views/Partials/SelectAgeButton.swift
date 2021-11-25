import UIKit

struct AgeBut{
    let text: String
    let key: AgeGroups
    let index: Int
}

protocol AgeButttonDelegate: AnyObject {
    func setAge(ageBut: AgeBut)
}

class SelectAgeButton: LoadableFromXibView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var ageText: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var backGround: CustomView!
    @IBOutlet weak var checkMark: UIImageView!
    
    var delegate: AgeButttonDelegate!
    var locked: Bool = false
    var ageBut:AgeBut?
    
    func setup(ageData: AgeBut, delegateScene: AgeButttonDelegate, selectedGender: String) {
        self.delegate = delegateScene
        ageBut = ageData
        ageText.text = ageData.text;
        locked = false
        checkMark.alpha = 0
        ageText.textAlignment = .left
        
        var imageName = ""
        if(selectedGender == "m"){
            imageName = "boy_\(ageData.index+1)"
        }else{
            imageName = "girl_\(ageData.index+1)"
        }
        avatar.image = UIImage(named: imageName)
        animateSelected(selected: false);
    }
    
    func animateSelected(selected:Bool){
        if(selected){
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
                self.backGround.backgroundColor = self.UIColorFromHex(rgbValue: 0xFFCE12, alpha: 1.0)
                self.checkMark.isHidden = false
                self.checkMark.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
                self.backGround.backgroundColor = self.UIColorFromHex(rgbValue: 0xFFFFFF, alpha: 1.0)
                self.checkMark.alpha = 0
            })
        }
    }
    
    @IBAction func GenderButtonClick(_ sender: Any) {
        if(!locked){
            delegate?.setAge(ageBut: ageBut!)
        }
    }
}

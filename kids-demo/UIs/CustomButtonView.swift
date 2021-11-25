import UIKit
struct StyleSet {
    let buttonColor: UIColor!
    let darkenColor: UIColor!
    let lightenColor: UIColor!
    let textColor: UIColor!
}

enum ButtonAnimPhase {
    case StandBy
    case MovingDown
    case HoldAction
    case HoldNoAction
    case MovingUp
    case IsDown
}

class CustomButtonView: UIView {
    
    
    
    
    
    // MARK:- IBOutles
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var strokView: CustomView!
    
    @IBOutlet weak var main: CustomView!
    
    @IBOutlet weak var darkenColor: CustomView!
    
    @IBOutlet weak var lightenColor: CustomView!
    
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var leftImage: UIImageView!
    
    @IBOutlet weak var middleImage: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var labelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightImageConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var leftImageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageSizeConstraint: NSLayoutConstraint!
    //////
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            strokView.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            strokView.borderColor = uiColor
        }
        get {
            guard let color = strokView.borderColor else { return nil }
            return color
        }
    }
    @IBInspectable var buttonColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            self.main.backgroundColor  = uiColor
        }
        get {
            guard let color = self.main.backgroundColor else { return nil }
            return color
        }
    }
    @IBInspectable var buttonDarkenColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            self.darkenColor.backgroundColor  = uiColor
        }
        get {
            guard let color = self.darkenColor.backgroundColor else { return nil }
            return color
        }
    }
    @IBInspectable var buttonLightenColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            self.lightenColor.backgroundColor  = uiColor
        }
        get {
            guard let color = self.lightenColor.backgroundColor else { return nil }
            return color
        }
    }
    @IBInspectable var buttonText: String? {
        set {
            guard let newTitle = newValue else { return }
            self.label.text = newTitle
        }
        get {
            return self.label.text
        }
    }
    
    @IBInspectable var textAlign: String  = "center" {
        didSet {
            if(textAlign == "right"){
                label.textAlignment = .right
            }else if(textAlign == "left"){
                label.textAlignment = .left
            }else {
                label.textAlignment = .center
            }
            
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            //            self.button.setTitleColor(uiColor, for: .normal)
            self.label.textColor = uiColor
        }
        get {
            guard let color = self.label.textColor else { return nil }
            return color
        }
    }
    
    @IBInspectable var textFontSize: CGFloat = 20.0 {
        didSet {
            self.label.font = self.label.font.withSize(textFontSize)
            
        }
    }
    @IBInspectable var textFontStyle: String = "simi-bold" {
        didSet {
            if (textFontStyle=="Bold"){
                self.label.font =  UIFont(name: "Dosis-Bold", size: self.label.font!.pointSize)
            }
            
        }
    }
    
    @IBInspectable var rImage: UIImage = UIImage() {
        didSet {
            self.rightImage.image = rImage
            hasRightLabelConstaint = true
        }
    }
    @IBInspectable var lImage: UIImage = UIImage() {
        didSet {
            self.leftImage.image = lImage
            hasLeftLabelConstaint = true
        }
    }
    
    @IBInspectable var mImage: UIImage = UIImage() {
        didSet{
            self.middleImage.image = mImage//.imageFlippedForRightToLeftLayoutDirection()
        }
    }
    @IBInspectable var imageSize: CGFloat = 24{
        didSet{
            
            self.imageSizeConstraint.constant = imageSize
            print("\(imageSize) ++++ ++++ ++++ \(self.imageSizeConstraint.constant)")
        }
    }
    
    @IBInspectable var defaultConsrtaint: CGFloat = 20{
        didSet{
            self.leftImageConstraint.constant = defaultConsrtaint
            self.rightImageConstraint.constant = defaultConsrtaint
        }
    }
    
    // MARk: Variables
    let nib = "CustomButtonView"
    
    //    var isAnimating = false
    //    var isWaitingForAnimation = false
    //    var waitFunc = false
    var animPhase: ButtonAnimPhase = .StandBy
    
    
    var buttonClickFunction: (()-> Void)?
    var constraintsValues: [String:[CGFloat]] = [
        
        "mainB":[6,2],
        //    "mainB":[-6,-6],
        "strokH":[0,-4],
        //    "strokB":[0,0],
        "darkenH":[0,-4]
        //    "lightenH":[4,0],
        //    "lightenB":[-4,-2.5]
    ]
    var hScaleRatio : CGFloat = 1
    
    var hasLeftLabelConstaint = false
    var hasRightLabelConstaint = false
    //    var delegate : UIViewController!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setStyle ()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit () {
        Bundle.main.loadNibNamed(nib, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        container.isHidden = true
        // UIView.appearance().semanticContentAttribute = .forceLeftToRight
        self.backgroundColor = UIColor.clear
    }
    
    // Functions
    func setStyle (){
        setButtonStatus (status : 0)
        strokView.cornerRadius = main.bounds.height/2
        main.cornerRadius = main.bounds.height/2
        darkenColor.cornerRadius = main.bounds.height/2
        lightenColor.cornerRadius = main.bounds.height/2
        //hScaleRatio = self.bounds.height / 50
        
        container.isHidden = false
        
        if(hasLeftLabelConstaint){
            self.labelLeftConstraint.constant = defaultConsrtaint*2+imageSize-2
        }else{
            self.labelLeftConstraint.constant = defaultConsrtaint
        }
        
        if(hasRightLabelConstaint){
            self.labelRightConstraint.constant = defaultConsrtaint*2+imageSize-2
        }else{
            self.labelRightConstraint.constant = defaultConsrtaint
        }
        
        
        backgroundColor = .clear
    }
    
    func setButtonStatus (status : Int ){
        self.constraintsValues.forEach {
            constraint in
            self.container.constraintWithIdentifier(constraint.key)?.constant = (constraint.value[status] )
        }
        self.layoutIfNeeded()
    }
    
    
    func animateDown(){
        animPhase = .MovingDown
        UIView.animate(withDuration: 0.08, delay: 0.0, options: [], animations: {
            self.setButtonStatus (status : 1 )
        }, completion: {[weak self] (finished: Bool) in
            guard let self = self else {return}
            print("completedown")
            if(self.animPhase == .HoldAction || self.animPhase == .HoldNoAction){
                self.animateUp(action: self.animPhase)
            }else{
                self.animPhase = .IsDown
            }
            
        })
        
    }
    
    func animateUp(action: ButtonAnimPhase){
        if(animPhase != .MovingDown){ // down - action - noaction -
            self.animPhase = action
            
            UIView.animate(withDuration: 0.08, delay: 0.0, options: [], animations: {
                self.setButtonStatus (status : 0 )
            }, completion: {[weak self] (finished: Bool) in
                guard let self = self else {return}
                if(self.animPhase == .HoldAction){
                    if let funcname = self.buttonClickFunction {
                        self.buttonClickFunction!()
                    }else{
                        
                    }
                }else{
                    
                }
                self.animPhase = .StandBy
            })
        }else{
            self.animPhase = action
        }
    }
    
    @IBAction func touchDownBtn(_ sender: Any) {
        animateDown()
    }
    
    @IBAction func touchUpBtn(_ sender: Any) {
        animateUp(action: .HoldAction)
    }
    
    @IBAction func DragOutBtn(_ sender: Any) {
        animateUp(action: .HoldNoAction)
    }
}

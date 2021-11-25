import UIKit

final class FloatingTextFieldView: LoadableFromXibView, UITextFieldDelegate {
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var containerView: CustomView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorView: CustomView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var fixedCommentLabel: UILabel!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var labelCenterVerticalConstraint: NSLayoutConstraint!
    
    var returnFunction: (()-> Void)?
    var onEditing: (()-> Void)?
    
    @IBInspectable var placeholder: String = "" {
        didSet {
            titleLabel.text = placeholder
            titleLabel.textColor = .violet
        }
    }
    
    @IBInspectable var fixedComment: String = "" {
        didSet {
            fixedCommentLabel.text = fixedComment
        }
    }
    
    @IBInspectable var isPassword: Bool = false {
        didSet {
            if isPassword {
                textField.isSecureTextEntry = true;
                textField.textContentType = UITextContentType.password
                textField.keyboardType = UIKeyboardType.default
                showPasswordButton.isHidden = false
            } else if !isNewPassword {
                showPasswordButton.isHidden = true
            }
        }
    }
    
    @IBInspectable var isNewPassword: Bool = false {
        didSet {
            if isNewPassword {
                textField.isSecureTextEntry = true;
                textField.textContentType = UITextContentType.newPassword
                textField.keyboardType = UIKeyboardType.default
                showPasswordButton.isHidden = false
            } else if !isPassword {
                showPasswordButton.isHidden = true
            }
        }
    }
    
    @IBInspectable var returnButton: String = "return"{
        didSet {
            if returnButton == "done" {
                textField.returnKeyType = UIReturnKeyType.done
            }
        }
    }
    
    @IBInspectable var isEmail: Bool = false {
        didSet {
            if isEmail {
                textField.textContentType = UITextContentType.emailAddress
                textField.keyboardType = UIKeyboardType.emailAddress
            }
        }
    }
    
    var showPassword:Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.delegate = self
        
        if(!isPassword && !isNewPassword){
            showPasswordButton.isHidden = true
        }
        
        textField.textAlignment = .left
        if !textField.text!.isEmpty {
            floatTitle()
        }
    }
    
    // MARK: - FUNCTIONS
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        floatTitle()
        performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }
    
    func activate (){
        textField.becomeFirstResponder()
        textFieldDidBeginEditing(textField)
    }
    
    private func floatTitle() {
        titleLabel.font = titleLabel.font?.withSize(12)
        titleLabel.textColor = .secondary
        labelTopConstraint.constant = -2
        labelTopConstraint.isActive = true
        labelCenterVerticalConstraint.isActive = false
    }
    
    private func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.titleLabel.transform = transform
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? false {
            configureEndEditing()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.returnFunction?()
        return true
    }
    
    func unFloatTitle() {
        textField.placeholder = nil
        titleLabel.textColor = .violet
        labelTopConstraint.constant = 10
        labelTopConstraint.isActive = false
        labelCenterVerticalConstraint.isActive = true
        titleLabel.font = titleLabel.font?.withSize(16)
    }
    
    private func configureEndEditing() {
        unFloatTitle()
        performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
    }
    
    func setError(error: String) {
        containerView.borderColor = .wrong
        errorView.isHidden = false
        errorLabel.text = error
        titleLabel.textColor = .wrong
    }
    func resetError() {
        containerView.borderColor = .secondary
        errorView.isHidden = true
        errorLabel.text = ""
        titleLabel.textColor = .secondary
    }
    
    
    @objc func textFieldDidChange() {
        onEditing?()
    }
    
    @IBAction func showPasswordClick(_ sender: Any) {
        showPassword = !showPassword
        if showPassword {
            showPasswordButton.setImage(UIImage(named: "Eye") , for: .normal )
        } else {
            showPasswordButton.setImage(UIImage(named: "Eye-closed") , for: .normal )
        }
        textField.isSecureTextEntry = !showPassword;
    }
}

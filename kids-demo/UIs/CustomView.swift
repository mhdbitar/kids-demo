
import UIKit

@IBDesignable
class CustomView: UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable  var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var set3dEffect: Bool {
        set {
            if newValue {
                self.set3DEffect(color: self.backgroundColor ?? UIColor.clear, shadowColor: self.shadowColor ?? UIColor.clear, cornerRadius: self.cornerRadius, borderWidth: self.borderWidth)
            }
        }
        get {
            return true
        }
    }
    
    func set3DEffect(color: UIColor, shadowColor: UIColor, cornerRadius: CGFloat, borderWidth: CGFloat) {
        self.backgroundColor = color
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.clear.cgColor
        
        // Shadow
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 8)
    }
    
}



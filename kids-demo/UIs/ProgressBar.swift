import UIKit

class ProgressBar: LoadableFromXibView {
    
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    
    var progress: CGFloat  = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        setProgress(progress : progress)
    }
    
    func setProgress(progress: CGFloat){
        self.progress = progress
        let minWidth: CGFloat = view.frame.height
        let maxDeltaWidth = view.frame.width - minWidth
        let currentWidth = (CGFloat(progress) * maxDeltaWidth) + minWidth
        print(" \(currentWidth)  \(maxDeltaWidth)  \(minWidth)")
        progressBarWidthConstraint.constant = currentWidth
    }
    
    

}

//
//  ManageChildrenTableViewCell.swift
//  AlifBee Kids
//
//  Created by Yaman on 26.10.2021.
//  Copyright © 2021 ALEMI. All rights reserved.
//

import UIKit

protocol ManageChildrenTableViewCellDelegate: AnyObject {
    func deleteChild(id: Int , name: String)
}

final class ManageChildrenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var learningTimeLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: ManageChildrenTableViewCellDelegate!
    var id: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(child: Child, delegate: ManageChildrenTableViewCellDelegate, canDelete: Bool) {
        self.id = child.id
        self.childNameLabel.text = child.name
        self.learningTimeLabel.text = child.elapsedTime
        self.progressLabel.text = "\(child.finishedLessons)"
        self.progressBar.setProgress(progress: CGFloat(child.progress))
        self.avatar.image = UIImage(named: child.avatar)
        self.delegate = delegate
        deleteButton.isHidden = !canDelete
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        guard let delegate = self.delegate else {return}
        delegate.deleteChild(id: self.id, name: childNameLabel.text!)
    }
}

//
//  MKTableViewCellTasks.swift
//  GoogleTasks
//
//  Created by Patricio González on 3/11/15.
//  Copyright (c) 2015 Patricio Gonz&#225;lez. All rights reserved.
//

import MaterialKit




@objc protocol TaskCellDelegate{
    
    func didSelectCheckButtonAtIndexPath(indexPath: NSIndexPath)

}

class TasksCell: MKTableViewCell {

    var task = Task()
    
    var checkstatus:Bool!
    
    var indexPath:NSIndexPath!
    
    var delegate:TaskCellDelegate?
    
    @IBOutlet weak var TaskTitle: UILabel!
    
    @IBOutlet weak var TaskDetail: UILabel!
    
    @IBOutlet weak var TaskCheck: MKImageView!
    
    @IBOutlet weak var TaskCellToggle: UIButton!
    
    @IBAction func check(sender: UIButton) {
        self.delegate?.didSelectCheckButtonAtIndexPath(self.indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
    
}


//
//  TagCell.swift
//  DebateApp
//
//  Created by 境将輝 on 2020/05/09.
//  Copyright © 2020 Masaki Sakai. All rights reserved.
//

import UIKit

protocol TagCellDelegate {
    func goEditVC(cellNum:Int)
}

class TagCell: UITableViewCell {

    
    
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    

    
    var delegate:TagCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //var delegate2:TagListTableViewController?
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func editTag(_ sender: UIButton) {
        delegate?.goEditVC(cellNum: sender.tag)
        
        print("editTag")
        print(sender.tag)
       
    }
    
    
    
}

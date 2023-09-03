//
//  ListTableViewCell.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/27.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var statusButton: UIButton!
    @IBOutlet var targetNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }
}


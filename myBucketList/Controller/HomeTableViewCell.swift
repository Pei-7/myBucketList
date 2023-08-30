//
//  HomeTableViewCell.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/30.
//

import UIKit

class HomeTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var titleTextField: UITextField!
    
    var list : [List]!{
        didSet{
            List.saveList(list: list)
        }
    }
    
    var index : Int!
    
    override func awakeFromNib() {
        titleTextField.delegate = self
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if titleTextField.text!.count < 1 {
            textField.resignFirstResponder()
            list.removeLast()
            List.saveList(list: list)
            
            print("cell",list)
            
            
        } else {
            textField.resignFirstResponder()
            titleTextField.isUserInteractionEnabled = false
            list[index].title = textField.text!
            
        }
        return true
    }

    
    
    
    
}


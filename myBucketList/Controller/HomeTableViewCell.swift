//
//  HomeTableViewCell.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/30.
//

import UIKit

class HomeTableViewCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var numberLabel: UITextField!
    @IBOutlet var titleTextField: UITextField!
    
    var lists : [List]!{
        didSet{
            List.saveList(list: lists)
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
            print("lists.count -- cell before remove",lists.count)
            lists.removeLast()
            print("lists.count -- cell after remove",lists.count)
            //print("inCell-Nil",lists!)
            
        } else {
            textField.resignFirstResponder()
            titleTextField.isUserInteractionEnabled = false
            lists[index].title = textField.text!
            //print("inCell-filled",lists!)
            
        }
        List.saveList(list: lists)
        //print("retunToHome",lists!)
        return true
    }

    
    
    
    
}


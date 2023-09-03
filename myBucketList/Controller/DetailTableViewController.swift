//
//  DetailTableViewController.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/27.
//

import UIKit
import PhotosUI

class DetailTableViewController: UITableViewController, PHPickerViewControllerDelegate {
    
    @IBOutlet var targetName: UITextField!
    
    @IBOutlet var targetStatus: UISwitch!
    
    @IBOutlet var targetRemarks: UITextView!
    
    @IBOutlet var targetPhotoButton: UIButton!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    var list: List!
    
    var target: Target?

    var ImageUpdated: Bool!
    
    var editable = true
    
    @IBOutlet var addPhotoButton: UIBarButtonItem!
    
    func updateUI() {
        if let target {
            targetName.text = target.name
            targetStatus.isOn = target.status
            targetRemarks.text = target.remarks
            
            if let imageName = target.imageName {
                let imageUrl = URL.documentsDirectory.appending(path: imageName).appendingPathExtension(for: .jpeg)
                let image = UIImage(contentsOfFile: imageUrl.path)
                targetPhotoButton.imageView?.contentMode = .scaleAspectFill
                targetPhotoButton.setImage(image, for: .normal)
            }
        }
        
        if editable == true {
            targetName.becomeFirstResponder()
            editButton.isHidden = true
            saveButton.isHidden = false
            addPhotoButton.isHidden = false
            targetName.isUserInteractionEnabled = true
            targetStatus.isUserInteractionEnabled = true
            targetRemarks.isEditable = true
            
        } else {
            targetName.isUserInteractionEnabled = false
            targetStatus.isUserInteractionEnabled = false
            targetRemarks.isEditable = false
            editButton.isHidden = false
            saveButton.isHidden = true
            addPhotoButton.isHidden = true
        }
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let selectedImage = results.first {
            selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self.targetPhotoButton.setImage(image, for: .normal)
                        self.ImageUpdated = true
                        self.tableView.reloadData()
                    }
                    else if let error {
                        print(error)
                        
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        updateUI()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let targetName = targetName.text ?? ""
        let status = targetStatus.isOn
        let remarks = targetRemarks.text ?? ""
        var imageName = target?.imageName
        
        if ImageUpdated == true {
            if let target {
                imageName = target.imageName
            }
            if imageName == nil {
                imageName = UUID().uuidString
            }
            
            let imageData = targetPhotoButton.image(for: .normal)?.jpegData(compressionQuality: 0.8)
            let imageUrl = URL.documentsDirectory.appending(path: imageName!).appendingPathExtension(for: .jpeg)
            try? imageData?.write(to: imageUrl)
        }
        
        target = Target(name: targetName, status: status, remarks: remarks, imageName: imageName)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if targetName.text?.isEmpty == false {
            return true
        } else {
            let alertController = UIAlertController(title: "提示", message: "尚未輸入目標", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "返回", style: .default))
            present(alertController,animated: true)
            return false
        }
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            if targetPhotoButton.currentImage == nil {
                return 0
            } else {
                return 200
            }
          
        case 3:
            return 560
        default:
            return 60
        }
    }
    
    @IBAction func edit(_ sender: UIButton) {
        editable = true
        updateUI()
    }
    

    @IBSegueAction func showFullImage(_ coder: NSCoder) -> FullImageViewController? {
        let controller = FullImageViewController(coder: coder)
        if let imageName = target?.imageName {
            controller?.imageName = imageName
        }
            return controller
    }
    
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

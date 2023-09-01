//
//  ListTableViewController.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/27.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var list : List!
    
    var listIndex : Int!
    
//    var targets = [Target]()
//    {
//        didSet {
//            Target.saveTarget(target: targets)
//        }
//    }
    
    func updateContent(index:Int) {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "list\(listIndex!)") {
            do {
                list = try decoder.decode(List.self, from: data)
                print("*****updateContent","list\(index)",list!)
            } catch {
                print(error)
            }
        }
    }
    
    func saveContent(content: List,index: Int) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(content) else {return}
        UserDefaults.standard.set(data, forKey: "list\(listIndex!)")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        47.2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateContent(index: listIndex)
        print("checkListIndex!!",listIndex!)
//        tableView.backgroundView = UIImageView(image: UIImage(named: "note background"))
        
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        list.content.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        updateContent(index: listIndex)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.targetNameLabel.text = list.content[indexPath.row].name
        
        print("8888","\(indexPath.row) / \(list.content.count)",list.content[indexPath.row].name)
        cell.statusButton.tag = indexPath.row
        
        if list.content[indexPath.row].status == true {
            cell.statusButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            cell.targetNameLabel.isEnabled = false
        } else {
            cell.statusButton.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.targetNameLabel.isEnabled = true
        }
        
        return cell
    }
    
    @IBAction func unwindToListTableViewController(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
        
        if let source = unwindSegue.source as? DetailTableViewController, let updatedTarget = source.target {

            if let indexPath = tableView.indexPathForSelectedRow {
                list.content[indexPath.row] = updatedTarget
                saveContent(content: list, index: indexPath.row)
                print("1111",list.content)
            } else {
                print("2222",updatedTarget)
                list.content.append(updatedTarget)
                saveContent(content: list, index: list.content.count-1)
                print("midCheck",list.content)
            }
            print("3333")
//            List.saveListContent(listContent: list)
//            List.saveListContent(list: [list], index: listIndex)
            print("final check",list)
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.content.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
//        List.saveListContent(list: [list], index: listIndex)
        saveContent(content: list, index: listIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailTableViewController, let row = tableView.indexPathForSelectedRow?.row {
            controller.list = list
            controller.target = list.content[row]
            print("detailcontroller",controller.target)
            controller.editable = false
        }
    }
    
    @IBAction func markComplete(_ sender: UIButton) {
        print("button clicked")
        if sender.currentImage == UIImage(systemName: "circle") {
            sender.setImage(UIImage(systemName: "circle.inset.filled"), for: .normal)
            let index = sender.tag
            list.content[index].status = true
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                cell.targetNameLabel.isEnabled = false
            }
        } else {
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            let index = sender.tag
            list.content[index].status = false
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                cell.targetNameLabel.isEnabled = true
            }
        }
        saveContent(content: list, index: listIndex)
    }

    
    func checkListsInfo() {
        if let data = UserDefaults.standard.data(forKey: "lists") {
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode([List].self, from: data)
                print("*****checkListsInfo:",item)
            } catch {
                print(error)
            }
        }
    }
    
    func checkTargetInfo(key: String) {
        
        print("*****checkTargetInfo - KeyName:",listIndex!,key)
        
        if let data = UserDefaults.standard.data(forKey: key) {
            let decoder = JSONDecoder()
            print("1111")
            do {
                print("2222")
                let item = try decoder.decode(List.self, from: data)
                print("*****checkTargetInfo:",item)
            } catch {
                print("3333")
                print(error ?? "checkTargetInfoError")
            }
        }
    }

    @IBAction func check(_ sender: Any) {
        checkListsInfo()
        checkTargetInfo(key: "list\(listIndex!)")
    }
    
    
    //    @IBSegueAction func addData(_ coder: NSCoder) -> DetailTableViewController? {
//        let controller = DetailTableViewController(coder: coder)
//        controller?.targetName?.isEnabled = true
//        controller?.targetName?.becomeFirstResponder()
//        controller?.targetRemarks?.isEditable = true
//        controller?.targetStatus?.isEnabled = true
//        controller?.targetPhotoButton?.isEnabled = true
//        return controller
//    }
//
//
//    @IBSegueAction func showData(_ coder: NSCoder) -> DetailTableViewController? {
//        let controller = DetailTableViewController(coder: coder)
//        controller?.targetName?.isUserInteractionEnabled = false
//        print("1",controller?.targetName?.isUserInteractionEnabled)
//        print("2",controller?.targetName ?? "error here" )
//        print("3",controller  ?? "error here" )
//        controller?.targetRemarks?.isEditable = false
//        controller?.targetRemarks?.backgroundColor = .white
//        controller?.targetStatus?.isUserInteractionEnabled = false
//        controller?.targetPhotoButton?.isUserInteractionEnabled = false
//        return controller
//    }
//
    
    
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

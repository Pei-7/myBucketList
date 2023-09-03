//
//  HomeViewController.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/30.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var homeTableView: UITableView!
    
    var lists = [List]() {
        didSet{
            List.saveList(list: lists)
        }
    }
    
    var checkNil = false
    var emptyRow : Int?
    var editingIndexPath : IndexPath?
    
    var completionCount: Int!
    var totalCount: Int!

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        updateInfo()
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        let row = indexPath.row
        cell.numberLabel.text = "\(row + 1)."
        cell.titleTextField.text = lists[row].title
        cell.titleTextField.isUserInteractionEnabled = false
        cell.lists = lists
        cell.index = row
        
        checkCompletion(row: row)
        cell.completionCount = completionCount
        cell.totalCount = totalCount
        cell.completionLabel.text = "\(cell.completionCount) / \(cell.totalCount)"

        if let editingIndexPath {
            if editingIndexPath == indexPath {
                DispatchQueue.main.async {
                    cell.titleTextField.isUserInteractionEnabled = true
                    cell.titleTextField.becomeFirstResponder()
                }
            }
        }
        editingIndexPath = nil
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeTableView.reloadData()
    }
    
    fileprivate func updateInfo() {
        // Do any additional setup after loading the view.
        
        if let data = UserDefaults.standard.data(forKey: "lists") {
            let decoder = JSONDecoder()
            do {
                lists = try decoder.decode([List].self, from: data)
//                print("*****updateInfo:",lists)
            } catch {
                print(error)
            }
        }
    }
    
    func checkCompletion(row: Int) {
        completionCount = 0
        totalCount = 0
        let uuid = lists[row].uuid
        let keyName = "list\(uuid)"
        print("*_*_*_*_*_*_* keyName",keyName)
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: keyName) {
            do {
                let items = try decoder.decode(List.self, from: data)
                totalCount = items.content.count
                
                for item in items.content {
                    if item.status == true {
                        completionCount += 1
                    }
                }
                print("*_*_*_*_*_*_* ",items,"count: ",items.content.count)
            } catch {
                print(error)
            }
        }
//        print("*_*_*_*_*_*_* totalCount",totalCount,"completionCount",completionCount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeTableView.delegate = self
        homeTableView.dataSource = self
        updateInfo()
  
    }
    
    @IBAction func addList(_ sender: Any) {
        updateInfo()
        List.saveList(list: lists)

        for (index,list) in lists.enumerated() {
            if list.title == "" {
                emptyRow = index
                checkNil = true
            } else {
                checkNil = false
            }
        }
        
        if checkNil == false {
            let newList = List(title: "", uuid: UUID().uuidString,content: [])
            lists.append(newList)
        }

        homeTableView.reloadData()
        
        let indexPath = IndexPath(row: lists.count-1, section: 0)
        let cell = homeTableView.cellForRow(at: indexPath) as? HomeTableViewCell
    
        cell?.titleTextField.placeholder = "請輸入心願清單名稱"
        cell?.titleTextField.isUserInteractionEnabled = true
        cell?.titleTextField.becomeFirstResponder()
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
            UserDefaults.standard.removeObject(forKey: "lists\(lists[indexPath.row].uuid)")
            lists.remove(at: indexPath.row)
            homeTableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.reloadData()
        }
        
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { contextualAction, view, completionHandler in
            
            self.editingIndexPath = indexPath
            self.homeTableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)

        }
    
        return UISwipeActionsConfiguration(actions: [editAction])
    }
        

//    func changeName(indexPath: IndexPath) {
//            print("change name!")
//
//            let cell = homeTableView.cellForRow(at: indexPath) as? HomeTableViewCell
//            cell?.titleTextField.isUserInteractionEnabled = true
//            cell?.titleTextField.becomeFirstResponder()
//        }
        
        
    @IBAction func reset(_ sender: Any) {
        lists.removeAll()
        List.saveList(list: lists)
        homeTableView.reloadData()
    }
    
    
    @IBSegueAction func showContent(_ coder: NSCoder) -> ListTableViewController? {
        updateInfo()
        let controller = ListTableViewController(coder: coder)
        if let index = homeTableView.indexPathForSelectedRow?.row {
            print("out of range??",index,"lists.count",lists.count)
            controller?.listUuid = lists[index].uuid
            controller?.list = lists[index]
            print("segue at Home page: ",index,lists[index])
        }
        return controller
    }
    
//
//
//    @IBAction func check(_ sender: Any) {
//        //updateInfo()
//        checkListsInfo(item: lists)
//        //print(lists)
//        print("lists.count -- check button",lists.count)
//    }
//
//    func checkListsInfo(item: [List]) {
//        if let data = UserDefaults.standard.data(forKey: "lists") {
//            let decoder = JSONDecoder()
//            do {
//                let item = try decoder.decode([List].self, from: data)
//                print("*****checkInfo:",item)
//            } catch {
//                print(error)
//            }
//        }
//
//    }

    
    /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
}


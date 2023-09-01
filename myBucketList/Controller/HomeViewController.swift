//
//  HomeViewController.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/8/30.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    @IBOutlet var homeTableView: UITableView!
    
    var lists = [List]() {
        didSet{
            List.saveList(list: lists)
            print("home didSet",lists)
        }
    }
    
    var checkNil = false
    var emptyRow : Int?
    var editingIndexPath : IndexPath?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.numberLabel.text = "\(indexPath.row + 1)."
        cell.titleTextField.text = lists[indexPath.row].title
        cell.titleTextField.isUserInteractionEnabled = false
//        cell.titleTextField.tag = indexPath.row
        cell.lists = lists
        cell.index = indexPath.row
        
        print(editingIndexPath,"ready to change name")
        if let editingIndexPath {
            if editingIndexPath == indexPath {
            print(editingIndexPath,"changing name")
                DispatchQueue.main.async {
                    cell.titleTextField.isUserInteractionEnabled = true
                    cell.titleTextField.becomeFirstResponder()
                }

            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        47.2
    }

    fileprivate func updateInfo() {
        // Do any additional setup after loading the view.
        
        if let data = UserDefaults.standard.data(forKey: "lists") {
            let decoder = JSONDecoder()
            do {
                lists = try decoder.decode([List].self, from: data)
                print("*****updateInfo:",lists)
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(lists)
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        updateInfo()
  
    }
    
    @IBAction func addList(_ sender: Any) {
        updateInfo()
        List.saveList(list: lists)
        //print("01",lists)
        for (index,list) in lists.enumerated() {
            if list.title == "" {
                //print("nilTitle",index)
                emptyRow = index
                checkNil = true
            } else {
                checkNil = false
            }
        }
        //print("標題是否為空值",checkNil)
        if checkNil == false {
            let newList = List(title: "",content: [])
            lists.append(newList)
        }

        homeTableView.reloadData()
        
        let indexPath = IndexPath(row: lists.count-1, section: 0)
        let cell = homeTableView.cellForRow(at: indexPath) as? HomeTableViewCell
    
        cell?.titleTextField.placeholder = "請輸入心願清單名稱"
//        DispatchQueue.main.async {
            cell?.titleTextField.isUserInteractionEnabled = true
//        }
        
        
        
        cell?.titleTextField.becomeFirstResponder()
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            print("lists.count - commit before",lists.count)
            lists.remove(at: indexPath.row)
            homeTableView.deleteRows(at: [indexPath], with: .automatic)
            print("lists.count - commit after",lists.count)
        }
        
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { contextualAction, view, completionHandler in
            
            self.editingIndexPath = indexPath
            self.homeTableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)

        }
    
        return UISwipeActionsConfiguration(actions: [editAction])
    }
        
        
    func changeName(indexPath: IndexPath) {
            print("change name!")
            
            let cell = homeTableView.cellForRow(at: indexPath) as? HomeTableViewCell
            cell?.titleTextField.isUserInteractionEnabled = true
            cell?.titleTextField.becomeFirstResponder()
        }
        
        
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
            controller?.listIndex = index
            controller?.list = lists[index]
            print("segue at Home page: ",index,lists[index])
            
            //print(lists[index])
        }
        return controller
    }
    
    

    @IBAction func check(_ sender: Any) {
        //updateInfo()
        checkListsInfo(item: lists)
        //print(lists)
        print("lists.count -- check button",lists.count)

    }
    
    
    
    
    func checkListsInfo(item: [List]) {
        if let data = UserDefaults.standard.data(forKey: "lists") {
            let decoder = JSONDecoder()
            do {
                let item = try decoder.decode([List].self, from: data)
                print("*****checkInfo:",item)
            } catch {
                print(error)
            }
        }
        
    }
    
    
    
    /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
}

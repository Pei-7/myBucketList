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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.titleTextField.text = lists[indexPath.row].title
        cell.titleTextField.tag = indexPath.row
        cell.list = lists
        cell.index = indexPath.row
        return cell
    }
    
    
    fileprivate func updateInfo() {
        // Do any additional setup after loading the view.
        
        if let data = UserDefaults.standard.data(forKey: "lists") {
            let decoder = JSONDecoder()
            do {
                lists = try decoder.decode([List].self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.delegate = self
        homeTableView.dataSource = self
        updateInfo()
        
    }
    
    @IBAction func addList(_ sender: Any) {
        
        updateInfo()
        
        for list in lists {
            if list.title == "" {
                print(list.title)
                checkNil = true
            }
        }
        
        if checkNil == false {
            let newList = List(title: "", content: nil)
            lists.append(newList)
        }
        print("view",lists)
        homeTableView.reloadData()
        
        let indexPath = IndexPath(row: lists.count-1, section: 0)
        let cell = homeTableView.cellForRow(at: indexPath) as? HomeTableViewCell
        cell?.titleTextField.placeholder = "請輸入心願清單名稱"
        cell?.titleTextField.becomeFirstResponder()
            
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            lists.remove(at: indexPath.row)
            homeTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        
        
        
        @IBAction func changeName(_ sender: Any) {
            
        }
        
        
    @IBAction func reset(_ sender: Any) {
        lists.removeAll()
        List.saveList(list: lists)
        homeTableView.reloadData()
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

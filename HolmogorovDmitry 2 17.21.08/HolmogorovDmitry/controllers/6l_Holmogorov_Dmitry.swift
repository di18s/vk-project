//
//  GroupTableViewController.swift
//  contraints
//
//  Created by Дмитрий on 25/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {

    private var myGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMyGroup()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyGroupTableViewCell else {
            fatalError("The dequeued cell is not an instance of VKTableViewCell.")
        }
        let group = myGroups[indexPath.row]
        cell.imageGroup.image = group.avatarGroup
        cell.labelGroup.text = group.nameGroup
        cell.infoLabelMyGroup.text = group.infoLabel


        return cell
    }
    
    //MARK:- load group
    private func loadMyGroup(){
        let photo1 = UIImage(named: "geek")
        let photo2 = UIImage(named: "touch")
        
        guard let group1 = Group(nameGroup: "Geekbrains", avatarGroup: photo1, infoLabel: "Наука") else {
            fatalError("Unable to instantiate group1")
        }
        
        guard  let group2 = Group(nameGroup: "Touch Instinct", avatarGroup: photo2, infoLabel: "Публичная страница") else {
                fatalError("Unable to instantiate group2")
        }
        myGroups += [group1, group2]
    }
    //MARK:- add new group
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедится, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let newGroupController = segue.source as! NewGroupTableViewController
            
            // Получаем индекс выделенной ячейки
            if let indexPath = newGroupController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = newGroupController.newGroups[indexPath.row]
                
                guard !myGroups.contains(where: { (element) -> Bool in //не работает причину не понял
                    return element.nameGroup == group.nameGroup
                }) else{return}
                // Добавляем группу в список выбранных групп
                myGroups.append(group)
                // Обновляем таблицу
                tableView.reloadData()
            }
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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

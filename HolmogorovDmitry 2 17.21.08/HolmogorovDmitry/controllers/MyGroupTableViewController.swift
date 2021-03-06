import UIKit
import SwiftyJSON
import RealmSwift
import  FirebaseDatabase

class GroupTableViewController: UITableViewController {

    private let networkService = GroupNetwork()
    private var myGroups: Results<Group>?
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myGroups = DatabaseService.loadFromRealm(Group.self)
        
        networkService.loadUserGroupsAlamofire(){(my_Groups, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let myGroups = my_Groups else { return }
            DatabaseService.saveToRealm(items: myGroups, config: DatabaseService.configuration, update: true)
        }
        
        update()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
    }
    
    //MARK: - update tableView
    private func update(){
 
        self.token = self.myGroups?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                self?.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        }
    }
    
}

//MARK: - Работа с сетью: добавление, удаление групп
extension GroupTableViewController{
    
    //MARK:- add new group segue
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        // Проверяем идентификатор, чтобы убедится, что это нужный переход
        if segue.identifier == "addGroup" {
            // Получаем ссылку на контроллер, с которого осуществлен переход
            let newGroupController = segue.source as! NewGroupTableViewController
            
            // Получаем индекс выделенной ячейки
            if let indexPath = newGroupController.tableView.indexPathForSelectedRow {
                // Получаем группу по индексу
                let group = newGroupController.newGroups[indexPath.row]
                addGroup(group: group)
                
                self.networkService.joinInNewGroupAlamofire(groupId: group.idGroup)
            }
        }
    }
    
    //MARK: - add new group func
    func addGroup(group: Group) {
        do {
            let realm = try? Realm()
            realm?.beginWrite()
            realm?.add(group, update: true)
            try realm?.commitWrite()
        } catch {
            print(error)
        }
        
        Session.instance.userAddGroup.append(group)
        
        let data = [Session.instance].map{$0.toAnyObject}
        let dbLink = Database.database().reference()
        dbLink.child("User").setValue(data)
        self.tableView.reloadData()
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //MARK: - leave from group
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let group = self.myGroups?[indexPath.row] else {return}
        if editingStyle == .delete {
            self.networkService.leaveFromGroupAlamofire(groupId: group.idGroup)
            do {
                let realm = try? Realm()
                realm?.beginWrite()
                realm?.delete(group)
                try realm?.commitWrite()
            } catch {
                print(error)
            }
        }
    }
}


//MARK: - Работа с DataSource
extension GroupTableViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myGroups?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "GroupCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyGroupTableViewCell, let myGroups = myGroups else {
            fatalError("The dequeued cell is not an instance of VKTableViewCell.")
        }
        
        cell.configureGroupCell(with: myGroups[indexPath.row])
        
        return cell
    }
}

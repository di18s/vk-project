import UIKit
import SwiftyJSON
import  Kingfisher
import  RealmSwift
import FirebaseDatabase

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var friendsForSearch: Results<Friend>?
    var userId = 1
    
    private var headerTitles = [String]()
    var friendDict = [String:[Friend]]()
    private var token: NotificationToken?

    private let networkService = FriendsNetwork()
    @IBOutlet weak var friendSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        self.friendsForSearch = DatabaseService.loadFromRealm(Friend.self)
        
        guard let results = self.friendsForSearch else {fatalError()}
        self.createHeaderLetters(results: results)
        
        networkService.loadUserFriendsAlamofire(){(friends, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let friends = friends else { return }
            DatabaseService.saveToRealm(items: friends, config: DatabaseService.configuration, update: true)
        }

        let nib = UINib.init(nibName: "FriendsHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "FriendsHeader")
        
        self.tableView.prefetchDataSource = self
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
    }
    
    //MARK: - update realm
    private func update(){
        
        self.token = self.friendsForSearch?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, _, _, _):
                guard let result = self?.friendsForSearch else {return}
                self?.createHeaderLetters(results: result)
                self?.tableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }

    //MARK:- настройка хедера секций
    func createHeaderLetters(results: Results<Friend>){  //самая главная функция
        
            var headerTitles = Array<String>()
            var friendDict = Dictionary<String, [Friend]>()
            
            for friend in results {
                let friendKey = String(friend.last_Name.first ?? "D")
                
                if var friendValue = friendDict[friendKey]{
                    friendValue.append(friend)
                    friendDict[friendKey] = friendValue
                } else {
                    friendDict[friendKey] = [friend]
                }
            }
            
            headerTitles = (friendDict.keys).sorted(by:{$0 < $1})
            
                self.friendDict = friendDict
                self.headerTitles = headerTitles
        
    }

   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let friendsPhotos = segue.destination as? AllPhotoCollectionViewController {

            if let indexPath = self.tableView.indexPathForSelectedRow {
                let friend = self.tableView.cellForRow(at: indexPath) as! FriendTableViewCell
                let friendId = friend.user_id
                friendsPhotos.friendId = friendId //приравниваем значение из класса друзей к значению переменной класса AllPhotoCVC
            }
        }
    }

    
}

//MARK:- Работа с search bar
extension FriendsTableViewController{
    
    func setupSearchBar(){
        friendSearchBar.delegate = self
    }
    
    @objc func hideKb(_ sender: UITapGestureRecognizer){
        self.friendSearchBar.endEditing(true)
        self.friendSearchBar.text = nil
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        self.tableView.endEditing(true)
        guard let results = self.friendsForSearch else {fatalError()}
        self.createHeaderLetters(results: results)
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        let uiButton = searchBar.value(forKey: "cancelButton") as! UIButton
        uiButton.setTitle("Отменить", for: UIControl.State.normal)
        
        searchBar.setNeedsLayout()
        searchBar.layoutIfNeeded()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let results = self.friendsForSearch else {fatalError()}
        let res = results.filter("last_Name CONTAINS %@", searchText)
        self.createHeaderLetters(results: res)
        self.tableView.reloadData()
        if searchText.isEmpty {
            self.createHeaderLetters(results: results)
            self.tableView.reloadData()
        }
    }
}


//MARK: - Создание ячеек, хедера, бокового меню
extension FriendsTableViewController{
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FriendsHeader") as? FriendsHeader, headerTitles.count > section {
            
            view.myLabel.text = headerTitles[section]
            return view
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    //MARK:- настройка бокового поиска
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return headerTitles
    }
    
    //MARK:- Настраиваем ячейки
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return headerTitles.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendKey = headerTitles[section]
        if let friendValue = friendDict[friendKey]{
            return friendValue.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellView"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FriendTableViewCell  else {
            fatalError("The dequeued cell is not an instance of VKTableViewCell.")
        }
        
        let friendKey = headerTitles[indexPath.section]
        if let friendValue = friendDict[friendKey]{
            cell.configureFriendCell(with: friendValue[indexPath.row])
        }
        return cell
    }
    
}


//MARK:- anim cell
extension FriendsTableViewController{

        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let degree: Double = 90
            let rotationAngle = CGFloat(degree * Double.pi / 180)
            let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 1, 0)
            cell.layer.transform = rotationTransform
            UIView.animate(withDuration: 0.6, delay: 0.1 /** Double(indexPath.row)*/, options: .curveEaseInOut, animations: {
                cell.layer.transform = CATransform3DIdentity
            })
        }
}

//MARK: - Prefetching
extension FriendsTableViewController: UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap { indexPath -> URL? in
            let friendKey = headerTitles[indexPath.section]
            guard let friendValue = friendDict[friendKey] else {return nil}
            return PhotoNetwork.urlForPhoto(friendValue[indexPath.row].avatar)
        }
        ImagePrefetcher(urls: urls).start()
    }
}


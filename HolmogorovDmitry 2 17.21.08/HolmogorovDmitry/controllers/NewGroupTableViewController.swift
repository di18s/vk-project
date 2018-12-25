//
//  NewGroupTableViewController.swift
//  contraints
//
//  Created by Дмитрий on 25/09/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewGroupTableViewController: UITableViewController, UISearchBarDelegate {
    
    public var newGroups = [Group]()
    @IBOutlet weak var searchNewGroup: UISearchBar!
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "NewGroupCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewGroupTableViewCell else {
            fatalError("The dequeued cell is not an instance of VKTableViewCell.")
        }
        cell.configureNewsGroupCell(with: newGroups[indexPath.row])

        return cell
    }

    //MARK:- search bar
    private func setUpSearchBar(){
        searchNewGroup.delegate = self
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        networkService.loadGroupSearchAlamofire(keyword: searchText ){ [weak self ] (newGroups, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let newGroups = newGroups, let self = self else { return }
            
            self.newGroups = newGroups
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }

   
    //MARK:- Alert
//    private func errorAlert(title: String, message: String, style: UIAlertController.UIAlertController.Style){
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
//        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
//            
//        }
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
//    }

}

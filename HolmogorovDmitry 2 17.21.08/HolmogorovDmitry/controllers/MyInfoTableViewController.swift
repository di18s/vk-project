//
//  SelfInfoTableViewController.swift
//  HolmogorovDmitry
//
//  Created by Дмитрий on 02/12/2018.
//  Copyright © 2018 Dmitry. All rights reserved.
//

import UIKit
import SwiftyJSON
import  Kingfisher


class MyInfoTableViewController: UITableViewController {

    var selfContent = [SelfContent]()
    var myInfo = [MyInfo]()
    private let networkService = MyInfoNetwork()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
        
        networkService.loadSelfInfoAlamofire(){ [weak self ] (myInform, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let myInfo = myInform, let self = self else { return }
            self.myInfo = myInfo
            
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        
        let nibSelfInfo = UINib.init(nibName: "MyInfoHeader", bundle: nil)
        self.tableView.register(nibSelfInfo, forHeaderFooterViewReuseIdentifier: "MyInfoHeader")
        
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MyInfoHeader") as? MyInfoHeader, self.myInfo.count > section{
            
            view.selfAvatar.kf.setImage(with: PhotoNetwork.urlForPhoto(myInfo[0].myAvatar))
            view.myName.text = self.myInfo[0].name
            view.myLastName.text = self.myInfo[0].lastName
            view.backView.backgroundColor = UIColor.white
            
            return view
        }
        
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selfContent.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selfCell", for: indexPath) as? SelfInfoTableViewCell else {fatalError()}
        
        let content_cell = selfContent[indexPath.row]
        cell.imageForCell.image = content_cell.imageCell
        cell.nameForCell.text = content_cell.nameCell
        return cell
    }
 
    func loadContent(){
        let image_cell1 = UIImage(named: "friend")
        let image_cell3 = UIImage(named: "group")
        let image_cell4 = UIImage(named: "photo")
        
        guard let content1 = SelfContent(imageCell: image_cell1, nameCell: "Друзья") else {
            fatalError()
        }
        guard let content3 = SelfContent(imageCell: image_cell3, nameCell: "Мои группы") else {
            fatalError()
        }
        guard let content4 = SelfContent(imageCell: image_cell4, nameCell: "Мои фото") else {
            fatalError()
        }
        selfContent += [content1, content3, content4]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index_Path = self.tableView.indexPathForSelectedRow
        performSegue(withIdentifier: String(index_Path!.row), sender: nil)
    }
    
}

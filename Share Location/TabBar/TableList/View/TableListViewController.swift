//
//  TableListViewController.swift
//  Share Location
//
//  Created by Tiago Oliveira on 07/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

class TableListViewController: BaseViewController {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var indicator = Indicator()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTableView()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        print("Logout")
    }
    
    @IBAction func addButton(_ sender: Any) {
        print("Add")
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        indicator.loadingView(true)
        loadTableView()
    }
    
    func loadTableView() {
        let requester = Requester()
        requester.getUsersData {(success, error) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.indicator.loadingView(false)
                }
            } else {                
                self.indicator.stopAnimating()
            }
        }
    }
}

extension TableListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = UsersInfo.UsersArray.count < 100 ? UsersInfo.UsersArray.count : 100
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "infoCell")!
        let user = UsersInfo.UsersArray[indexPath.row]


        infoCell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        infoCell.imageView?.image = UIImage(named: "Pin")
        infoCell.detailTextLabel?.text = user.mediaURL

        return infoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = UsersInfo.UsersArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let url = URL(string: user.mediaURL), checkURL(user.mediaURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func checkURL(_ url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

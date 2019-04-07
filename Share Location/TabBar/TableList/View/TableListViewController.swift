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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

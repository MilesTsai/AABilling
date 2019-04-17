//
//  BaseTableViewController.swift
//  Project-2
//
//  Created by User on 2019/4/17.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class BaseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }
    
    func setTableView() {
        
        if tableView == nil {
            
            let tableView = UITableView()
            
            view.stickSubView(tableView)
            
            self.tableView = tableView
        }
        
        tableView.dataSource = self
        
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: String(describing: BaseTableViewController.self))
    }
}

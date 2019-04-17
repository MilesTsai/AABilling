//
//  IndividualViewController.swift
//  Project-2
//
//  Created by User on 2019/4/17.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class IndividualViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        
        tableView.mls_registerCellWithNib(identifier: String(describing: IndividualCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: String(describing: IndividualCell.self), for: indexPath)
        
        guard let equalCell =
            cell as? IndividualCell else { return cell }
        
        return equalCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

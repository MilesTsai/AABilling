//
//  EqualViewController.swift
//  Project-2
//
//  Created by User on 2019/4/17.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class EqualViewController: BaseTableViewController {
    
    var equalView: EqualCell?
    
    var averageView: AverageValueCell?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        
        tableView.mls_registerCellWithNib(identifier: String(describing: EqualCell.self), bundle: nil)
        
        tableView.mls_registerCellWithNib(identifier: String(describing: AverageValueCell.self), bundle: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: String(describing: AverageValueCell.self), for: indexPath)
            
            guard let averageCell = cell as? AverageValueCell else { return cell }
            
            return averageCell
            
        } else {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: String(describing: EqualCell.self), for: indexPath)
            
            guard let equalCell =
                cell as? EqualCell else { return cell }
            
            equalCell.paySelectBtn.addTarget(self, action: #selector(self.paySelect(_:)), for: .touchUpInside)
            
            return equalCell
        }
    }
    
    @objc func paySelect(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

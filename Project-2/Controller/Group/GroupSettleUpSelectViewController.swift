//
//  GroupSettleUpSelectViewController.swift
//  Project-2
//
//  Created by User on 2019/4/10.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class GroupSettleUpSelectViewController: BaseViewController {
    
    @IBOutlet weak var groupSettleUpSelectTableView: UITableView! {
        
        didSet {
            
            groupSettleUpSelectTableView.dataSource = self
            
            groupSettleUpSelectTableView.delegate = self
            
            groupSettleUpSelectTableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        
        groupSettleUpSelectTableView.mls_registerCellWithNib(
            identifier: String(describing: GroupSettleUpSelectCell.self),
            bundle: nil
        )
    }
    
    @IBAction func cancelSettleUpSelect(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension GroupSettleUpSelectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: GroupSettleUpSelectCell.self), for: indexPath)
        
        guard let groupSettleUpSelectCell = cell as? GroupSettleUpSelectCell else { return cell }
        
        return groupSettleUpSelectCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "SegueSettleUpSelect", sender: nil)
    }
    
}

extension GroupSettleUpSelectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

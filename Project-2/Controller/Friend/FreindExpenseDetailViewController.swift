//
//  FreindExpenseDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FreindExpenseDetailViewController: BaseViewController {
    
    var vc1: EqualViewController?
    
    var vc2: IndividualViewController?
    
    private enum ShareType: Int {
        
        case equal = 0
        
        case individual = 1
    }
    
    private struct Segue {
        
        static let equal = "SegueEqual"
        
        static let individual = "SegueIndividual"
    }
    
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var equalContainerView: UIView!
    
    @IBOutlet weak var individualContainerView: UIView!
    
    @IBOutlet var selectExpenseBtns: [UIButton]!
    
    @IBOutlet weak var payer: UILabel!
    
    var containerViews: [UIView] {
        
        return [equalContainerView, individualContainerView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancelExpenseDetail(_ sender: UIBarButtonItem) {

        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changePage(_ sender: UIButton) {
        
        for btn in selectExpenseBtns {
            
            btn.isSelected = false
        }
        
        sender.isSelected = true
        
        moveIndicatorView(toPage: sender.tag)
        
        guard let type = ShareType(rawValue: sender.tag) else { return }
        
        updateContainer(type: type)
    }
    
//    @IBAction func firstBtnAct(_ sender: UIButton) {
//
//        sender.isSelected = !sender.isSelected
//    }
//
//    @IBAction func secondBtnAct(_ sender: UIButton) {
//
//        sender.isSelected = !sender.isSelected
//    }
    
    private func moveIndicatorView(toPage: Int) {
        
        indicatorLeadingConstraint.constant = CGFloat(toPage) * UIScreen.width / 2
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.scrollView.contentOffset.x = CGFloat(toPage) * UIScreen.width
            
            self?.view.layoutIfNeeded()
        })
    }
    
    private func updateContainer(type: ShareType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .equal: equalContainerView.isHidden = false
            
        case .individual: individualContainerView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let equalVC = segue.destination as? EqualViewController else { return }
        
        guard let individualVC = segue.destination as? IndividualViewController else { return }
        
        let identifier = segue.identifier
        
        if identifier == Segue.equal {
            vc1 = equalVC
        } else if identifier == Segue.individual {
            vc2 = individualVC
        }
    }
}

extension FreindExpenseDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        indicatorLeadingConstraint.constant = scrollView.contentOffset.x / 2
        
        let temp = Double(scrollView.contentOffset.x / UIScreen.width)
        
        let number = lround(temp)
        
        for btn in selectExpenseBtns {
            
            btn.isSelected = false
        }
        
        selectExpenseBtns[number].isSelected = true
        
        UIView.animate(withDuration: 0, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
}

//extension FreindExpenseDetailViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//}
//
//extension FreindExpenseDetailViewController: UITableViewDelegate {
//
//}

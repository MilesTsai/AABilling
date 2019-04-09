//
//  FreindExpenseDetailViewController.swift
//  Project-2
//
//  Created by User on 2019/4/9.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit

class FreindExpenseDetailViewController: BaseViewController {
    
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
    
    @IBOutlet weak var firstContainerView: UIView!
    
    @IBOutlet weak var secondContainerView: UIView!
    
    @IBOutlet var selectExpenseBtns: [UIButton]!
    
    
    
    
    var containerViews: [UIView] {
        
        return [firstContainerView, secondContainerView]
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
        
    }
    
    private func moveIndicatorView(toPage: Int) {
        
        indicatorLeadingConstraint.constant = CGFloat(toPage) * UIScreen.width / 2
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.scrollView.contentOffset.x = CGFloat(toPage) * UIScreen.width
            
            self?.view.layoutIfNeeded()
        })
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

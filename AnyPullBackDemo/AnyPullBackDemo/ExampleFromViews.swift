//
//  ExampleFromViews.swift
//  AnyPullBackDemo
//
//  Created by Vhyme on 2017/7/17.
//  Copyright © 2017年 Vhyme. All rights reserved.
//

import UIKit

class ExampleFromViewsViewController: UIViewController, AnyPullBackCustomizable {
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBAction func pushView1() {
        (navigationController as? AnyPullBackNavigationController)?.pushViewController(UITableViewController(), fromView: view1)
    }
    
    @IBAction func pushView2() {
        (navigationController as? AnyPullBackNavigationController)?.pushViewController(UITableViewController(), fromView: view2)
    }
    
    @IBAction func pushView3() {
        (navigationController as? AnyPullBackNavigationController)?.pushViewController(UITableViewController(), fromView: view3)
    }
    
    func apb_shouldPull(inDirection direction: SwipeOutDirection) -> Bool {
        return false
    }
}

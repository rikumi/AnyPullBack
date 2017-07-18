//
//  ExampleTableViewController.swift
//  AnyPullBackDemo
//
//  Created by Vhyme on 2017/7/18.
//  Copyright © 2017年 Vhyme. All rights reserved.
//

import UIKit

class ExampleTableViewController: UITableViewController {
    
    var nav: AnyPullBackNavigationController? {
        return navigationController as? AnyPullBackNavigationController
    }
    
    @IBOutlet var fromView: UIView!
    
    @IBOutlet var count: UILabel!
    
    override func viewDidLoad() {
        count.text = "Page" + String(nav?.viewControllers.count ?? 0)
        if (nav?.viewControllers.count ?? 0) > 1 {
            count.text = (count.text ?? "") + ", pull down / up / right to go back!"
        }
    }
    
    @IBAction func pushDefault() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "example") {
            nav?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func pushFromView() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "fromViews") {
            nav?.pushViewController(vc, fromView: fromView)
        }
    }
    
    @IBAction func pushFromRight() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "example") {
            nav?.pushViewController(vc, inDirection: .leftFromRight)
        }
    }
    
    @IBAction func pushFromBottom() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "example") {
            nav?.pushViewController(vc, inDirection: .upFromBottom)
        }
    }
    
    @IBAction func pushFromLeft() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "example") {
            nav?.pushViewController(vc, inDirection: .rightFromLeft)
        }
    }
    
    @IBAction func pushFromTop() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "example") {
            nav?.pushViewController(vc, inDirection: .downFromTop)
        }
    }
    
    @IBAction func popDown() {
        guard let _ = nav?.popViewController(inDirection: .downFromTop) else {
            alertRoot()
            return
        }
    }
    
    @IBAction func popUp() {
        guard let _ = nav?.popViewController(inDirection: .upFromBottom) else {
            alertRoot()
            return
        }
    }
    
    @IBAction func popToRight() {
        guard let _ = nav?.popViewController(inDirection: .rightFromLeft) else {
            alertRoot()
            return
        }
    }
    
    @IBAction func popToLeft() {
        guard let _ = nav?.popViewController(inDirection: .leftFromRight) else {
            alertRoot()
            return
        }
    }
    
    func alertRoot() {
        let alert = UIAlertController(title: "Nothing to pop", message: "You're in the root controller now.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

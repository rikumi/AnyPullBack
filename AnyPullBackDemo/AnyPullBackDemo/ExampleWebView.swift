//
//  ExampleWebView.swift
//  AnyPullBackDemo
//
//  Created by Vhyme on 2017/7/17.
//  Copyright © 2017年 Vhyme. All rights reserved.
//

import UIKit

class ExampleWebView: UIWebView {
    
    override func didMoveToSuperview() {
        loadRequest(URLRequest(url: URL(string: "https://github.com/vhyme/AnyPullBack")!))
    }
}

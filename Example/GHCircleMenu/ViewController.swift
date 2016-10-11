//
//  ViewController.swift
//  GHCircleMenu
//
//  Created by Copperfiled on 10/10/2016.
//  Copyright (c) 2016 Copperfiled. All rights reserved.
//

import UIKit
import GHCircleMenu

class ViewController: UIViewController, GHCircleMenuDataSource, GHCircleMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let menuView = GHCircleMenu(frame: CGRectMake(100, 200, 60, 60))
        menuView.dataSource = self
        menuView.delegate = self
        menuView.direction = .ClockWise
        self.view.addSubview(menuView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    //MARK: GHCircleMenuDataSource
    func numberOfItemsInCircleMenu(circleMenu: GHCircleMenu) -> Int {
        return 4
    }
    func circleMenu(circleMenu: GHCircleMenu, itemAtIndex index: Int) -> UIView {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.redColor()
        return view
    }
    func didOpenCircleMenu(circleMenu: GHCircleMenu) {
        circleMenu.centerView.backgroundColor = UIColor.greenColor()
    }
    func circleMenu(circleMenu: GHCircleMenu, didSelectAtIndex index: Int) {
        print(index)
    }
}


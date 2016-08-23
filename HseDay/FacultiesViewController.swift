//
//  FacultiesViewController.swift
//  HseDay
//
//  Created by Никита Римский on 28.07.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit

class FacultiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if (parent == nil) {
            self.navigationController?.navigationBarHidden = true
        }
    }

}

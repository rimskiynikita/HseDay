//
//  QuestPinViewController.swift
//  HseDay
//
//  Created by Никита Римский on 16.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit

class QuestPinViewController: MenuViewController, UITextFieldDelegate {
    
    var pin: PinInformation!
    
    @IBOutlet weak var questPinPageImage: UIImageView!
    @IBOutlet weak var questPinPageNameLabel: UILabel!
    @IBOutlet weak var questPinPageTextLabel: UILabel!
    @IBOutlet weak var questPasswordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questPinPageImage.image = UIImage(data: pin.infoPageImage!)
        questPinPageNameLabel.text = pin.annotation
        questPinPageTextLabel.text = pin.questPageTextOrFacOrgName
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

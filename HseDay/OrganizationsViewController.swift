//
//  FacultyViewController.swift
//  HseDay
//
//  Created by Никита Римский on 16.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit

class OrganizationViewController: MenuViewController {
    
    var organization: Organization!
    
    @IBOutlet weak var organizationPageImage: UIImageView!
    @IBOutlet weak var organizationPageName: UILabel!
    @IBOutlet weak var organizationPageInfoLabel: UILabel!
    @IBOutlet weak var organizationWebPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        organizationPageImage.image = UIImage(data: organization.pageImage!)
        organizationPageName.text = organization.name
        organizationPageInfoLabel.text = organization.pageInfo
        organizationWebPageButton.setTitle(organization.webPage, forState: .Normal)
    }
    
    @IBAction func showOrganizationWebPage(sender: UIButton) {
        if let url = NSURL(string: "http://" + sender.titleLabel!.text!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func showOrganizationOnMap(sender: AnyObject) {
        performSegueWithIdentifier("showMapFromOrganization", sender: OrganizationViewController())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMapFromOrganization" {
            for pin in pins {
                if pin.questPageTextOrFacOrgName == organization.name {
                    let destinationVC = segue.destinationViewController as! UINavigationController
                    let destinationMap = destinationVC.viewControllers.first as! MapViewController
                    destinationMap.pinFromMap = pin
                }
            }
        }
    }
}

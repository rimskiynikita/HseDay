//
//  FacultyViewController.swift
//  HseDay
//
//  Created by Никита Римский on 16.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit

class FacultyViewController: MenuViewController {
    
    var faculty: Faculty!
    
    @IBOutlet weak var facultyPageImage: UIImageView!
    @IBOutlet weak var facultyPageName: UILabel!
    @IBOutlet weak var facultyPageInfoLabel: UILabel!
    @IBOutlet weak var facultyPageDirectionsLabel: UILabel!
    @IBOutlet weak var facultyWebPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facultyPageImage.image = UIImage(data: faculty.pageImage!)
        facultyPageName.text = faculty.name
        facultyPageInfoLabel.text = faculty.pageInfo
        facultyPageDirectionsLabel.text = faculty.directions
        facultyWebPageButton.setTitle(faculty.webPage, forState: .Normal)
    }
    
    @IBAction func showFacultyWebPage(sender: UIButton) {
        if let url = NSURL(string: "http://" + sender.titleLabel!.text!) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func showFacultyOnMap(sender: AnyObject) {
        performSegueWithIdentifier("showMapFromFaculty", sender: FacultyViewController())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMapFromFaculty" {
            for pin in pins {
                if pin.questPageTextOrFacOrgName == faculty.name {
                    let destinationVC = segue.destinationViewController as! UINavigationController
                    let destinationMap = destinationVC.viewControllers.first as! MapViewController
                    destinationMap.pinFromMap = pin
                }
            }
        }
    }
}

//
//  FacultiesTableViewController.swift
//  HseDay
//
//  Created by Никита Римский on 02.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit

class FacultiesTableViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    var facultyName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Факультеты"
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tblView =  UIView(frame: CGRectZero)
        
        return tblView
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faculties.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FacultiesTableViewCell
        
        cell.facultyNameLabel.text = faculties[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! FacultiesTableViewCell
        facultyName = currentCell.facultyNameLabel.text
        
        performSegueWithIdentifier("showFaculty", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        hideMenuOnScrollInTables(scrollView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "showFaculty" {
            for faculty in faculties {
                if faculty.name == facultyName {
                    let destinatioVC = segue.destinationViewController as! FacultyViewController
                    destinatioVC.faculty = faculty
                }
            }
        }
    }
}

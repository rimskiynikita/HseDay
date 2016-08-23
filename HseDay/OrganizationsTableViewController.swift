//
//  OrganizationsTableViewController.swift
//
//
//  Created by Никита Римский on 20.08.16.
//
//

import UIKit

class OrganizationsTableViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    var organizationName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Организации"
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let tblView =  UIView(frame: CGRectZero)
        
        return tblView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizations.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! OrganizationsTableViewCell
        
        cell.organizationCellImage.image = UIImage(data: organizations[indexPath.row].logo!)
        cell.organizationNameLabel.text = organizations[indexPath.row].name
        
        cell.organizationCellImage.layer.cornerRadius =  cell.organizationCellImage.frame.size.height / 2
        cell.organizationCellImage.clipsToBounds = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! OrganizationsTableViewCell
        organizationName = currentCell.organizationNameLabel.text
        
        performSegueWithIdentifier("showOrganization", sender: self)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        hideMenuOnScrollInTables(scrollView)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "showOrganization" {
            for organization in organizations {
                if organization.name == organizationName {
                    let destinatioVC = segue.destinationViewController as! OrganizationViewController
                    destinatioVC.organization = organization
                }
            }
        }
    }
}
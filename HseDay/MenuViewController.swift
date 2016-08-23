//
//  MenuViewController.swift
//  HseDay
//
//  Created by Никита Римский on 11.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit
import CoreData
//import Alamofire

class MenuViewController: UIViewController {
    
    var viewTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.navigationItem.title != nil {
            viewTitle = self.navigationItem.title!
        }
        
        // Настраиваем меню
        for constraint in view.constraints as [NSLayoutConstraint] {
            if constraint.identifier == "menuConstraint" {
                constraint.constant = (view.bounds.size.height - 304)/8
            }
        }
    }
    
    // Функция на кнопки меню
    func menuClick(view: UIView) {
        for views in view.subviews as [UIView] {
            if let btn = views as? UIButton {
                btn.addTarget(self, action: #selector(goToMenuObjects), forControlEvents: .TouchUpInside)
            }
        }
    }
    
    // Переход на нужный контроллер
    func goToMenuObjects(btn: UIButton) {
        switch btn.titleLabel!.text! {
        case "КАРТА":
            let titleName = "Карта"
            presentMenuItem(titleName)
        case "ФАКУЛЬТЕТЫ":
            let titleName = "Факультеты"
            presentMenuItem(titleName)
        case "ОРГАНИЗАЦИИ":
            let titleName = "Организации"
            presentMenuItem(titleName)
        default:
            break
        }
    }
    
    // Презентация контроллера
    func presentMenuItem(titleName: String) {
        if titleName != viewTitle {
            let menuController = self.storyboard?.instantiateViewControllerWithIdentifier(titleName)
            presentViewController(menuController!, animated: true, completion: nil)
        } else {
            closeMenu()
        }
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        if self.title != "Меню" {
            let menuController = self.storyboard?.instantiateViewControllerWithIdentifier("menu") as! MenuViewController
            menuController.view.frame.origin.y = -64
            menuController.view.frame.origin.y -= menuController.view.frame.size.height
            self.view.addSubview(menuController.view)
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                menuController.view.frame.origin.y += menuController.view.frame.size.height
                }, completion: nil)

            self.navigationItem.rightBarButtonItems = []
        
            menuClick(menuController.view)
            
            self.title = "Меню"
            let menuButton: UIButton = UIButton()
            menuButton.setImage(UIImage(named: "closeImage"), forState: .Normal)
            menuButton.frame = CGRectMake(0, 0, 24, 24)
            menuButton.addTarget(self, action: #selector(showMenu), forControlEvents: .TouchUpInside)
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: menuButton), animated: true)
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.subviews.last!.frame.origin.y -= self.view.subviews.last!.frame.size.height
                }, completion: nil)
            
            self.title = viewTitle
            let menuButton: UIButton = UIButton()
            menuButton.setImage(UIImage(named: "hamburger"), forState: .Normal)
            menuButton.frame = CGRectMake(0, 0, 24, 16)
            menuButton.addTarget(self, action: #selector(showMenu), forControlEvents: .TouchUpInside)
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: menuButton), animated: true)
        }
    }
    
    // Прячем меню по нажатию на текущую страницу в меню
    func closeMenu() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.subviews.last!.frame.origin.y -= self.view.subviews.last!.frame.size.height
            }, completion: nil)
        
        self.title = viewTitle
        let menuButton: UIButton = UIButton()
        menuButton.setImage(UIImage(named: "hamburger"), forState: .Normal)
        menuButton.frame = CGRectMake(0, 0, 24, 16)
        menuButton.addTarget(self, action: #selector(showMenu), forControlEvents: .TouchUpInside)
        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: menuButton), animated: true)
        
        if viewTitle == "Карта" {
            let filterButton: UIButton = UIButton()
            filterButton.setImage(UIImage(named: "filter"), forState: .Normal)
            filterButton.frame = CGRectMake(0, 0, 22, 20)
            filterButton.addTarget(self, action: #selector(MapViewController.showFilter), forControlEvents: .TouchUpInside)
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: filterButton), animated: true)
        }
    }
    
    // Прячем в таблицах при прокрутке наверх
    func hideMenuOnScrollInTables(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -70 {
            for view in self.view.subviews {
                if view.tag == 1 {
                    view.hidden = true
                }
            }
        }
    }
}

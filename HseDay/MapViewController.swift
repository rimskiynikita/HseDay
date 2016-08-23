//
//  ViewController.swift
//  HseDay
//
//  Created by Никита Римский on 24.07.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit

class MapViewController: MenuViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var filterView: UIView!
    
    var pinFromMap: PinInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Карта"
        
        scrollView.delegate = self
        
        // Настраиваем скроллвью
        let heightScale = view.bounds.size.height / contentView.bounds.height
        scrollView.minimumZoomScale = heightScale * 4/3
        scrollView.maximumZoomScale = heightScale * 8/3
        scrollView.zoomScale = heightScale * 4/3
        
        // Начальная точка скроллвью
        scrollView.contentOffset = CGPoint(x: 260, y: 140)
        
        // Добавляем отметки на карту
        for pin in pins {
            addPins(pin)
        }
        
        // Прячем аннотации по нажатию вне кнопок
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollViewWillBeginZooming))
        singleTap.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(singleTap)
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeZoomScale))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Переход на карту со страницы факультета или организации
        if pinFromMap != nil {
            showAnnotaion(addPins(pinFromMap))
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Начальное положение меню фильтров
        filterView.hidden = true
        filterView.frame.origin.y = -(filterView.frame.size.height)
    
        // Настраиваем окно фильтров
        for subview in view.subviews as [UIView] {
            for constraint in subview.constraints as [NSLayoutConstraint] {
                if constraint.identifier == "filterViewWidthConstraint" {
                    constraint.constant = view.bounds.size.width/(11/3)
                }
                if constraint.identifier == "topImageConstraint" {
                    constraint.constant = (view.bounds.size.height - 64 - ((view.bounds.size.width/(22/3)) * 72/85 + 26) * 6) / 7
                }
            }
        
            for subview in filterView.subviews as [UIView] {
                for constraint in subview.constraints as [NSLayoutConstraint] {
                    if constraint.identifier == "widthConstraint" {
                        constraint.constant = view.bounds.size.width/(22/3)
                    }
                }
            }
        }
    }
    
    func addPins(pin: PinInformation) -> UIButton {
        let button = UIButton()
        button.frame = CGRect(x: CGFloat(pin.xPosition!), y: CGFloat(pin.yPosition!), width: 71, height: 60)
        button.setImage(UIImage(named: pin.image!), forState: .Normal)
        button.titleLabel!.text = pin.annotation
        
        button.accessibilityHint = pin.image
        button.tag = 0
        button.addTarget(self, action: #selector(showAnnotaion), forControlEvents: .TouchUpInside)
        contentView.addSubview(button)
        return button
    }
    
    func showAnnotaion(sender: UIButton) {
        pinFromMap = nil
        
        let buttonWidth = sender.frame.width
        let buttonHeight = sender.frame.height
        let buttonX = sender.frame.origin.x
        let buttonY = sender.frame.origin.y
        
        let heightScale = view.bounds.size.height / contentView.bounds.height
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollView.contentOffset = CGPoint(x: buttonX * self.scrollView.zoomScale - (self.view.frame.width/2) + (buttonWidth * self.scrollView.zoomScale/4), y: buttonY * self.scrollView.zoomScale - (self.view.frame.height/2) + (buttonHeight * self.scrollView.zoomScale/4))
                self.scrollView.zoomScale = heightScale * 8/3
                }, completion: nil)

        if contentView.viewWithTag(Int(sender.frame.origin.x)) == nil {
            
            // Вью надписи
            let annotationLabel = UILabel(frame: CGRectMake(123, 123, 250, 50))
            annotationLabel.text = sender.titleLabel!.text!
            annotationLabel.font = UIFont(name: "SFUIDisplay-Light", size: 26)
            annotationLabel.textColor = UIColor.whiteColor()
            annotationLabel.numberOfLines = 0
            annotationLabel.sizeToFit()
            annotationLabel.tag = Int(sender.frame.origin.x)
            let annotationLabelWidth = annotationLabel.frame.width
            let annotationLabelHeight = annotationLabel.frame.height
            annotationLabel.frame = CGRectMake(buttonX + (buttonWidth - annotationLabelWidth)/2 - 20, buttonY - annotationLabelHeight - 30 - 8.5, annotationLabelWidth, annotationLabelHeight)
            
            // Вью фонового прямоугольника
            let annotationBackground = UIButton(frame: CGRectMake(buttonX + (buttonWidth - annotationLabelWidth - 120)/2, buttonY - (annotationLabelHeight + 60) - 8.5, annotationLabelWidth + 120, annotationLabelHeight + 60))
            annotationBackground.setImage(UIImage(named: "pinAnnotationBackground"), forState: .Normal)
            annotationBackground.tag = Int(sender.frame.origin.x)
            
            // Вью для стрелки перехода
            let arrowImage = UIImageView(frame: CGRectMake(buttonX + (buttonWidth + annotationLabelWidth)/2 + 20, buttonY - annotationLabelHeight/2 - 30 - 8.5 - 12, 12, 24))
            arrowImage.image = UIImage(named: "arrowImage")
            arrowImage.tag = Int(sender.frame.origin.x)
            
            // Вью для стрелки аннотации
            let downArrow = UIImageView(frame: CGRectMake(buttonX + buttonWidth/2 - 7.75, buttonY - 17.0, 15.5, 15.5))
            downArrow.image = UIImage(named: "downArrow")
            downArrow.tag = Int(sender.frame.origin.x)
            
            contentView.addSubview(downArrow)
            contentView.addSubview(annotationBackground)
            contentView.addSubview(annotationLabel)
            contentView.addSubview(arrowImage)
            
            annotationBackground.titleLabel?.text = sender.accessibilityHint!
            annotationBackground.addTarget(self, action: #selector(showPinPage), forControlEvents: .TouchUpInside)
            
            for subview in contentView.subviews {
                if subview.tag != 0 && subview.tag != Int(sender.frame.origin.x){
                    subview.removeFromSuperview()
                }
            }
        } else {
            for subview in contentView.subviews {
                if subview.tag != 0 && subview.tag == Int(sender.frame.origin.x){
                    subview.removeFromSuperview()
                }
            }
        }
        
        if filterView.frame.origin.y > 0 {
            hideFilterWithAnimation()
        }
    }
    
    // Открываем страницу отметки
    func showPinPage(pinBtn: UIButton) {
        if pinBtn.titleLabel!.text! == "Шатер" {
            performSegueWithIdentifier("tentPin", sender: pinBtn)
        } else if pinBtn.titleLabel!.text! == "Первак" {
            performSegueWithIdentifier("questPin", sender: pinBtn)
        } else {
            performSegueWithIdentifier("infoPin", sender: pinBtn)
        }
    }
    
    @IBAction override func showMenu(sender: AnyObject) {
        hideFilterWithAnimation()
        
        for subview in contentView.subviews {
            if subview.tag != 0 {
                subview.removeFromSuperview()
            }
        }
        
        if self.title != "Меню" {
            let menuController = self.storyboard?.instantiateViewControllerWithIdentifier("menu") as! MenuViewController
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
            closeMenu()
            
            filterView.frame.origin.y += (filterView.frame.size.height + 64)
        }
    }

    
    @IBAction func showFilter(sender: AnyObject) {
        filterView.hidden = false
        
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
        if filterView.frame.origin.y < 0 {
            for subview in contentView.subviews {
                if subview.tag != 0 {
                    subview.removeFromSuperview()
                }
            }
            showFilterWithAnimation()
        } else {
            hideFilterWithAnimation()
        }
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        if filterView.frame.origin.y > 0 {
            hideFilterWithAnimation()
        }
        
        for subview in contentView.subviews {
            if subview.tag != 0 {
                subview.removeFromSuperview()
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if filterView.frame.origin.y > 0 {
            hideFilterWithAnimation()
        }
        
        for subview in contentView.subviews {
            if subview.tag != 0 {
                subview.removeFromSuperview()
            }
        }
    }
    
    func changeZoomScale() {
        let heightScale = view.bounds.size.height / contentView.bounds.height
        if scrollView.zoomScale == heightScale * 4/3 {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollView.zoomScale = heightScale * 8/3
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.scrollView.zoomScale = heightScale * 4/3
                }, completion: nil)
        }
    }
    
    func showFilterWithAnimation() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.filterView.frame.origin.y += (self.filterView.frame.size.height + 64)
            }, completion: nil)
        let filterButton: UIButton = UIButton()
        filterButton.setImage(UIImage(named: "closeImage"), forState: .Normal)
        filterButton.frame = CGRectMake(0, 0, 24, 24)
        filterButton.addTarget(self, action: #selector(showFilter), forControlEvents: .TouchUpInside)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: filterButton), animated: true)
    }

    func hideFilterWithAnimation() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.filterView.frame.origin.y -= (self.filterView.frame.size.height + 64)
            }, completion: nil)
        let filterButton: UIButton = UIButton()
        filterButton.setImage(UIImage(named: "filter"), forState: .Normal)
        filterButton.frame = CGRectMake(0, 0, 22, 20)
        filterButton.addTarget(self, action: #selector(showFilter), forControlEvents: .TouchUpInside)
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: filterButton), animated: true)

    }
    
    @IBAction func pinsFilter(sender: UIButton) {
        for view in contentView.subviews as [UIView] {
            if let btn = view as? UIButton {
                if btn.currentImage == sender.currentImage {
                    if btn.hidden == false {
                        btn.hidden = true
                        sender.alpha = 0.4
                        changeLabelAlpha(sender, alpha: 0.6)
                    } else {
                        btn.hidden = false
                        sender.alpha = 1.0
                        changeLabelAlpha(sender, alpha: 1.0)
                    }
                }
            }
        }
    }
    
    // Меняем прозрачность надписей в меню фильтров
    func changeLabelAlpha(btn: UIButton, alpha: CGFloat) {
        for view in filterView.subviews as [UIView] {
            if let label = view as? UILabel {
                if label.text! == btn.titleLabel!.text! {
                    label.alpha = alpha
                }
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "tentPin" {
            for pin in pins {
                if pin.xPosition == sender!.tag {
                    let destinationVC = segue.destinationViewController as! TentPinViewController
                    destinationVC.pin = pin
                }
            }
        } else if segue.identifier == "questPin" {
            for pin in pins {
                if pin.xPosition == sender!.tag {
                    let destinationVC = segue.destinationViewController as! QuestPinViewController
                    destinationVC.pin = pin
                }
            }
        } else {
            for pin in pins {
                if pin.xPosition == sender!.tag {
                    let destinationVC = segue.destinationViewController as! InfoPinViewController
                    destinationVC.pin = pin
                }
            }
        }
    }
}


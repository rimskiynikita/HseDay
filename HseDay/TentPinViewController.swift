//
//  TentPinViewController.swift
//  HseDay
//
//  Created by Никита Римский on 14.08.16.
//  Copyright © 2016 Никита Римский. All rights reserved.
//

import UIKit
import Foundation

class TentPinViewController: MenuViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tentPinPageImage: UIImageView!
    @IBOutlet weak var tentPinPageNameLabel: UILabel!
    @IBOutlet weak var tentPinPageInfo: ReadMoreTextView!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var pin: PinInformation!
    var userName: String!
    var userPhoto: UIImage!
    
    //var comments: [String] = ["jhnrthkjntjkhntkjhnkhjnrkjhntkjnhjktrnhjkrtnhjtnh", "ngjnbjknbjknbtkrjnjktnbkjrnbkrjtnkjtnnkn"]
    
    var photo = UIImageView()
    //var photos: [UIImage] = [UIImage(named: "mainPhoto")!, UIImage(named: "mainPhoto")!, UIImage(named: "mainPhoto")!, UIImage(named: "mainPhoto")!]
    var photos: [UIImage] = []
    
    @IBOutlet weak var commentsLabelTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let req = VK.API.Users.get([VK.Arg.photo: ""])
//        req.httpMethod = .GET
//        req.successBlock = { response in print(response) }
//        req.errorBlock = {error in print(error)}
//        req.send()
        
//        VK.API.custom(method: "photos.get").send(
//            method: .Get
//            success: {response in print(response)},
//            error: {error in print(error)}
//        )
//        let req = VK.API.custom(method: "users.get", parameters: [VK.Arg.:"photo_50"])
//        req.httpMethod = .GET
//        req.successBlock = { response in print(response) }
//        req.errorBlock = {error in print(error)}
//        req.send()
//
//        
//        
//        request.executeWithResultBlock(
//            {
//                (response) -> Void in
//                
//                println(response.json)
//                
//            }, errorBlock: {
//                (error) -> Void in
//                println("error")
//                
//        })
        
        for faculty in faculties {
            if faculty.name == pin.questPageTextOrFacOrgName {
                tentPinPageInfo.text = faculty.pageInfo
            } else {
                for organization in organizations {
                    if organization.name == pin.questPageTextOrFacOrgName {
                        tentPinPageInfo.text = organization.pageInfo
                    }
                }
            }
        }
        
        tentPinPageImage.image = UIImage(data: pin.infoPageImage!)
        tentPinPageNameLabel.text = pin.annotation
        
        // Если уже зарегистрировались
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // Берем данные из соц.сетей
            returnUserData()
        }
}
    
    override func viewDidLayoutSubviews() {
        presentPhotos(photos)
        
        // Если уже зарегистрировались
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // Берем данные из соц.сетей
            returnUserData()
        }

        
        //VK.API.execute("return \"Hello World\"")
        //VK.API.custom(method: "users.get", parameters: [VK.Arg.userId : "1"])
        
//        let req = VK.API.Users.get([VK.Arg.userId : "1"])
//        req.httpMethod = .GET 
//        req.successBlock = {response in print(response)}
//        req.errorBlock = {error in print(error)}
//        req.send()
    }
    
    @IBAction func addPhoto() {
        // Если уже зарегистрировались
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
            let cancelAction = UIAlertAction(title: "Отменить", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
        
            let takePhoto = UIAlertAction(title: "Сделать фотографию", style: .Default) { (action) in
                // Добавляем сделанное на камеру фото
                if UIImagePickerController.isSourceTypeAvailable(.Camera){
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .Camera
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            alertController.addAction(takePhoto)
        
            let addFromLibrary = UIAlertAction(title: "Загрузить из галереи", style: .Default) { (action) in
                // Добавляем фото из галлереи
                if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .PhotoLibrary
                    self.presentViewController(imagePicker, animated: true, completion: nil)
                }
            }
            alertController.addAction(addFromLibrary)
        
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            performSegueWithIdentifier("login", sender: self)
        }
    }
    
    @IBAction func showMore() {
        for faculty in faculties {
            if faculty.name == pin.questPageTextOrFacOrgName {
                performSegueWithIdentifier("showFacultyFromPin", sender: TentPinViewController())
            }
        }
        for organization in organizations {
            if organization.name == pin.questPageTextOrFacOrgName {
                performSegueWithIdentifier("showOrganizationFromPin", sender: TentPinViewController())
            }
        }
    }
    
    func presentPhotos(photosArray: [UIImage]) {
        let width = (view.bounds.size.width - 6)/3
        
        let photoSpace = CGFloat(Int(ceil(Double(photos.count)/3))) * width
        var x: CGFloat = 0
        var y: CGFloat = view.bounds.size.width * (2/3) + 200
        
        for photoFromArray in photosArray {
            let photo = UIImageView()
            photo.image = cropToBounds(photoFromArray, width: width, height: width)
            photo.frame = CGRectMake(x, y, width, width)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            photo.userInteractionEnabled = true
            photo.addGestureRecognizer(tapGestureRecognizer)
            scrollView.addSubview(photo)
            
            x += (width + 3)
            if x > view.bounds.size.width {
                y += (width + 3)
                x = 0
            }
        }
        
        commentsLabelTopConstraint.constant = photoSpace
        self.scrollView.contentSize = CGSizeMake(view.bounds.size.width, y + photoSpace + 40)
    }
    
    // Обрезаем фотографию в квадрат
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        let tappedImageView = gestureRecognizer.view! as! UIImageView
    }
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        photo.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        photo.contentMode = .ScaleAspectFit
        photo.clipsToBounds = true
        photos.insert(photo.image!, atIndex: 0)
        dismissViewControllerAnimated(true, completion: nil)
        presentPhotos(photos)
    }
    
    

    func returnUserData()
    {
            let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"name, picture.type(large)"])
            graphRequest.startWithCompletionHandler({ (connection, result, error) in
                self.userName = result.valueForKey("name") as! String
            
                let photoURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
                let userPhotoData = NSData(contentsOfURL: NSURL(string: photoURL)!)!
                self.userPhoto = UIImage(data: userPhotoData)
            
                print(self.userName)
                print(self.userPhoto)
            })     }
    
    @IBAction func addComment() {
        //commentsTableView.cel
//        
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        commentsTableView.beginUpdates()
//        commentsTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        commentsTableView.endUpdates()
//        print(indexPath)
        
    }
    
    @IBAction func unwindBackToTent(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "showFacultyFromPin" {
            for faculty in faculties {
                if faculty.name == pin.questPageTextOrFacOrgName {
                    let destinatioVC = segue.destinationViewController as! FacultyViewController
                    destinatioVC.faculty = faculty
                }
            }
        } else {
            for organization in organizations {
                if organization.name == pin.questPageTextOrFacOrgName {
                    let destinatioVC = segue.destinationViewController as! OrganizationViewController
                    destinatioVC.organization = organization
                }
            }
        }
    }
}

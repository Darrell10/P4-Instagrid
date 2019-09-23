//
//  ViewController.swift
//  Instagrid
//
//  Created by Frederick Port on 18/08/2019.
//  Copyright © 2019 StudiOS 21. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var addPicture1: addPhotoButton!
    @IBOutlet weak var addPicture2: addPhotoButton!
    @IBOutlet weak var addPicture3: addPhotoButton!
    @IBOutlet weak var addPicture4: addPhotoButton!
    
    @IBOutlet weak var swipeUpLabel: UILabel!
    
    @IBOutlet weak var swipeView: ArrowSwipe!
    
    @IBOutlet weak var pictureView1: UIImageView!
    @IBOutlet weak var pictureView2: UIImageView!
    @IBOutlet weak var pictureView3: UIImageView!
    @IBOutlet weak var pictureView4: UIImageView!
    
    @IBOutlet weak var selectedLayout1: UIImageView!
    @IBOutlet weak var selectedLayout2: UIImageView!
    @IBOutlet weak var selectedLayout3: UIImageView!
    
    var imageTmp =  UIImageView()
    var imagePicker = UIImagePickerController()
    enum ViewDirection { case out, backIn }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // alow user to editing picture's choice
        imagePicker.allowsEditing = true
        // add swipe gesture
        createSwipeGesture()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        selectedLayout1.isHidden = false
        selectedLayout2.isHidden = true
        selectedLayout3.isHidden = true
        addPicture4.isHidden = true
        pictureView4.isHidden = true
        orientationSwipe()
    }
    
    func orientationSwipe() {
        if UIDevice.current.orientation.isPortrait {
            // if device is portrait
            swipeView.image = UIImage(named:"Arrow Up.png")
            swipeUpLabel.text = "Swipe up to share"
        } else if UIDevice.current.orientation.isLandscape {
            // else if device is portrait
            swipeView.image = UIImage(named:"Arrow Left.png")
            swipeUpLabel.text = "Swipe left to share"
        }
    }
    
    // MARK:Swip function
    private func createSwipeGesture() {
            let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipedByUser(_:)))
            swipeGestureUp.direction = .up
            self.contentView.addGestureRecognizer(swipeGestureUp)
            let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipedByUser(_:)))
            swipeGestureLeft.direction = .left
            self.contentView.addGestureRecognizer(swipeGestureLeft)
    }
    
    @objc func swipedByUser(_ gesture: UISwipeGestureRecognizer) {
        convertViewToImage()
        if UIDevice.current.orientation.isPortrait {
            moveViewVertically(movement: .out)
        } else {
            moveViewHorizontally(movement: .out)
        }
    }
    
    // MARK:Animation contentView
    private func moveViewVertically(movement: ViewDirection) {
        // verticall animation
        switch movement {
        case .out:
            UIView.animate(withDuration: 0.5) {
                self.contentView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            }
        case .backIn:
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: [],
                           animations: { self.contentView.transform = .identity},
                           completion: nil)
            }
        }
    private func moveViewHorizontally(movement: ViewDirection) {
        // Horizontall animation
        switch movement {
        case .out:
            UIView.animate(withDuration: 0.5) {
                self.contentView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }
        case .backIn:
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: [],
                           animations: { self.contentView.transform = .identity},
                           completion: nil)
        }
    }
    
    // MARK:Convert Image
    func presentWithSource(source: UIImagePickerController.SourceType) {
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func convertViewToImage(){
        // convert Grid view to an image
        UIGraphicsBeginImageContextWithOptions(contentView.frame.size, view.isOpaque, 0)
        contentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else
        { return }
        UIGraphicsEndImageContext()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(UIActivityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self.moveViewVertically(movement: .backIn)
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: Alert Function
    private func alerteAction() {
        // Show an alert to user
        let alerteActionSheet = UIAlertController(title: "Take a picture", message: "choose the media", preferredStyle: .actionSheet)
        let gallery = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.presentWithSource(source: .photoLibrary)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alerteActionSheet.addAction(gallery)
        alerteActionSheet.addAction(cancel)
        if let popover = alerteActionSheet.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.frame.midX, y: view.frame.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        present(alerteActionSheet, animated: true, completion: nil)
    }
    
    // MARK: Layout Function
    private func layoutFirstView() {
        // First layout in grid when user push on LayoutView1 button
        if UIDevice.current.orientation.isPortrait {
            // disposition when device is portrait
            // Button 1
            addPicture1.frame = CGRect(x: 15, y: 15, width: 270, height: 130)
            pictureView1.frame = addPicture1.frame
            // button 2
            addPicture2.frame = CGRect(x: 15, y: 155, width: 130, height: 130)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 155, y: 155, width: 130, height: 130)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.frame = CGRect(x: 285, y: 15, width: 0, height: 130)
            pictureView4.frame = addPicture4.frame
            addPicture4.isHidden = true
            pictureView4.isHidden = true
            
        } else if UIDevice.current.orientation.isLandscape {
            // layout when device is landscape
            // Button 1
            addPicture1.frame = CGRect(x: 10, y: 10, width: 230, height: 110)
            pictureView1.frame = addPicture1.frame
            // button 2
            addPicture2.frame = CGRect(x: 10, y: 130, width: 110, height: 110)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 130, y: 130, width: 110, height: 110)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.frame = CGRect(x: 240, y: 10, width: 0, height: 130)
            pictureView4.frame = addPicture4.frame
            addPicture4.isHidden = true
            pictureView4.isHidden = true
        }
    }
    
    private func layoutSecondView() {
        // second layout in grid when user push on LayoutView2 button
        if UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat{
            // layout when device is portrait
            // Button 1
            addPicture1.frame = CGRect(x: 15, y: 15, width: 130, height: 130)
            pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.frame = CGRect(x: 155, y: 15, width: 130, height: 130)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 15, y: 155, width: 270, height: 130)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.frame = CGRect(x: 285, y: 15, width: 0, height: 130)
            pictureView4.frame = addPicture4.frame
            pictureView4.isHidden = true
            addPicture4.isHidden = true
            
       } else if UIDevice.current.orientation.isLandscape {
            // layout when device is landscape
            // Button 1
            addPicture1.frame = CGRect(x: 10, y: 10, width: 110, height: 110)
            pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.frame = CGRect(x: 130, y: 10, width: 110, height: 110)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 10, y: 130, width: 230, height: 110)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.frame = CGRect(x: 240, y: 10, width: 0, height: 110)
            pictureView4.frame = addPicture4.frame
            pictureView4.isHidden = true
            addPicture4.isHidden = true
        }
    }
    
    private func layoutThirdView() {
        // third layout in grid when user push on LayoutView3 button
        if UIDevice.current.orientation.isPortrait {
            // layout when device is portrait
            // Button 1
            addPicture1.frame = CGRect(x: 15,y: 15,width: 130,height: 130)
            pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.frame = CGRect(x: 155,y: 15,width: 130,height: 130)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 15,y: 155,width: 130,height: 130)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.isHidden = false
            pictureView4.isHidden = false
            addPicture4.frame = CGRect(x: 155,y: 155,width: 130,height: 130)
            pictureView4.frame = addPicture4.frame
        } else if UIDevice.current.orientation.isLandscape {
            // layout when device is landscape
            // Button 1
            addPicture1.frame = CGRect(x: 10,y: 10,width: 110,height: 110)
            pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.frame = CGRect(x: 130,y: 10,width: 110,height: 110)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 10,y: 130,width: 110,height: 110)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.isHidden = false
            pictureView4.isHidden = false
            addPicture4.frame = CGRect(x: 130,y: 130,width: 110,height: 110)
            pictureView4.frame = addPicture4.frame
        }
    }
    
        // MARK: Button Action
    @IBAction func layoutView1(_ sender: Any) {
        selectedLayout1.isHidden = false
        selectedLayout2.isHidden = true
        selectedLayout3.isHidden = true
        layoutFirstView()
    }
    
    @IBAction func layoutView2(_ sender: Any) {
        selectedLayout1.isHidden = true
        selectedLayout2.isHidden = false
        selectedLayout3.isHidden = true
        layoutSecondView()
    }
    
    @IBAction func layoutView3(_ sender: Any) {
        selectedLayout1.isHidden = true
        selectedLayout2.isHidden = true
        selectedLayout3.isHidden = false
        layoutThirdView()
    }

    @IBAction func takePicture1(_ sender: addPhotoButton) {
        imageTmp = pictureView1
        alerteAction()
    }
    
    @IBAction func takePicture2(_ sender: addPhotoButton) {
        imageTmp = pictureView2
        alerteAction()
    }
    
    @IBAction func takePicture3(_ sender: addPhotoButton) {
        imageTmp = pictureView3
        alerteAction()
    }
    
    @IBAction func takePicture4(_ sender: addPhotoButton) {
        imageTmp = pictureView4
        alerteAction()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // extention for presentWithSource function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edite = info[.editedImage] as? UIImage {
            imageTmp.image = edite
        } else if let originale = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageTmp.image = originale
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

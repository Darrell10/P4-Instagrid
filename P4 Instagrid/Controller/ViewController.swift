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
    
    var imageTemp =  UIImageView()
    var imagePicker = UIImagePickerController()
    enum ViewDirection { case out, backIn }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
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
            swipeView.image = UIImage(named:"Arrow Up.png")
            swipeUpLabel.text = "Swipe up to share"
        } else if UIDevice.current.orientation.isLandscape{
            swipeView.image = UIImage(named:"Arrow Left.png")
            swipeUpLabel.text = "Swipe left to share"
        }
    }
    
    private func setUpView(){
        self.view.addSubview(swipeView)
        contentView.addSubview(addPicture1)
        addPicture1.isHidden = false
        addPicture1.frame = CGRect(x: 15, y: 15, width: 270, height: 130)
        contentView.addSubview(addPicture2)
        addPicture2.isHidden = false
        addPicture2.frame = CGRect(x: 15, y: contentView.frame.height - 145, width: 130, height: 130)
        contentView.addSubview(addPicture3)
        addPicture3.isHidden = false
        addPicture3.frame = CGRect(x: contentView.frame.width - 145, y: contentView.frame.height - 145, width: 130, height: 130)
        contentView.addSubview(addPicture4)
        addPicture4.isHidden = true
        pictureView4.isHidden = true
    }
    
    
    // MARK:Swip function
    func createSwipeGesture() {
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
        } else if UIDevice.current.orientation.isLandscape {
            moveViewHorizontally(movement: .out)
        }
    }
    
    // MARK:Animation contentView
    private func moveViewVertically(movement: ViewDirection) {
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
    
    func convertViewToImage(){
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
    func alerteAction() {
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
    func layoutFirstView() {
        selectedLayout1.isHidden = false
        selectedLayout2.isHidden = true
        selectedLayout3.isHidden = true
        if UIDevice.current.orientation.isPortrait {
            // Button 1
            addPicture1.frame = CGRect(x: 15, y: 15, width: 270, height: 130)
            pictureView1.frame = addPicture1.frame
            // button 2
            addPicture2.frame = CGRect(x: 15, y: contentView.frame.height - 145, width: 130, height: 130)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: contentView.frame.width - 145, y: contentView.frame.height - 145, width: 130, height: 130)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.isHidden = true
            pictureView4.isHidden = true
            
        } else if UIDevice.current.orientation.isLandscape{
            // Button 1
            addPicture1.frame = CGRect(x: 10, y: 10, width: 230, height: 110)
            pictureView1.frame = addPicture1.frame
            // button 2
            addPicture2.frame = CGRect(x: 10, y: contentView.frame.height - 120, width: 110, height: 110)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: contentView.frame.width - 120, y: contentView.frame.height - 120, width: 110, height: 110)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.isHidden = true
            pictureView4.isHidden = true
        }
        
    }
    
    func layoutSecondView() {
        selectedLayout1.isHidden = true
        selectedLayout2.isHidden = false
        selectedLayout3.isHidden = true
        if UIDevice.current.orientation.isPortrait {
            // Button 1
            addPicture1.frame = CGRect(x: 15, y: 15, width: 130, height: 130)
            //pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.frame = CGRect(x: contentView.frame.width - 145, y: 15, width: 130, height: 130)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 15, y: contentView.frame.height - 145, width: 270, height: 130)
            pictureView3.frame = addPicture3.frame
            // Button 4
            pictureView4.isHidden = true
            addPicture4.isHidden = true
            
       } else if UIDevice.current.orientation.isLandscape {
            addPicture1.frame = CGRect(x: 10, y: 10, width: 110, height: 110)
            pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.frame = CGRect(x: contentView.frame.width - 120, y: 10, width: 110, height: 110)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 10, y: contentView.frame.height - 120, width: 230, height: 110)
            pictureView3.frame = addPicture3.frame
            // Button 4
            pictureView4.isHidden = true
            addPicture4.isHidden = true
        }
    }
    
    func layoutThirdView() {
        selectedLayout1.isHidden = true
        selectedLayout2.isHidden = true
        selectedLayout3.isHidden = false
        if UIDevice.current.orientation.isPortrait {
            // Button 1
            addPicture1.frame = CGRect(x: 15,y: 15,width: 130,height: 130)
            pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.frame = CGRect(x: contentView.frame.width - 145,y: 15,width: 130,height: 130)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 15,y: contentView.frame.height - 145,width: 130,height: 130)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.isHidden = false
            pictureView4.isHidden = false
            addPicture4.frame = CGRect(x: contentView.frame.width - 145,y: contentView.frame.height - 145,width: 130,height: 130)
            pictureView4.frame = addPicture4.frame
        } else if UIDevice.current.orientation.isLandscape {
            // Button 1
            addPicture1.frame = CGRect(x: 10,y: 10,width: 110,height: 110)
            pictureView1.frame = addPicture1.frame
            // Button 2
            addPicture2.isHidden = false
            pictureView2.isHidden = false
            addPicture2.frame = CGRect(x: contentView.frame.width - 120,y: 10,width: 110,height: 110)
            pictureView2.frame = addPicture2.frame
            // Button 3
            addPicture3.frame = CGRect(x: 10,y: contentView.frame.height - 120,width: 110,height: 110)
            pictureView3.frame = addPicture3.frame
            // Button 4
            addPicture4.isHidden = false
            pictureView4.isHidden = false
            addPicture4.frame = CGRect(x: contentView.frame.width - 120,y: contentView.frame.height - 120,width: 110,height: 110)
            pictureView4.frame = addPicture4.frame
        }
    }
    
        // MARK: Button Action
    @IBAction func layoutView1(_ sender: Any) {
        layoutFirstView()
    }
    
    @IBAction func layoutView2(_ sender: Any) {
        layoutSecondView()
    }
    
    @IBAction func layoutView3(_ sender: Any) {
        layoutThirdView()
    }

    @IBAction func takePicture1(_ sender: addPhotoButton) {
        imageTemp = pictureView1
        alerteAction()
    }
    
    @IBAction func takePicture2(_ sender: addPhotoButton) {
        imageTemp = pictureView2
        alerteAction()
    }
    
    @IBAction func takePicture3(_ sender: addPhotoButton) {
        imageTemp = pictureView3
        alerteAction()
    }
    
    
    @IBAction func takePicture4(_ sender: addPhotoButton) {
        imageTemp = pictureView4
        alerteAction()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edite = info[.editedImage] as? UIImage {
            imageTemp.image = edite
        } else if let originale = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageTemp.image = originale
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

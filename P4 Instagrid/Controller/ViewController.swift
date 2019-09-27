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
    @IBOutlet weak var swipeUpLabel: UILabel!
    @IBOutlet weak var swipeView: ArrowSwipe!
    
    @IBOutlet weak var selectedLayout1: UIImageView!
    @IBOutlet weak var selectedLayout2: UIImageView!
    @IBOutlet weak var selectedLayout3: UIImageView!
    
    @IBOutlet var GridSwipe: UISwipeGestureRecognizer!
    
    let pictureView1 = UIImageView()
    let pictureView2 = UIImageView()
    let pictureView3 = UIImageView()
    let pictureView4 = UIImageView()
    
    var imageTmp =  UIImageView()
    var imagePicker = UIImagePickerController()
    enum ViewDirection { case out, backIn }
    
    let addPicture1 = addPhotoButton()
    let addPicture2 = addPhotoButton()
    let addPicture3 = addPhotoButton()
    let addPicture4 = addPhotoButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // set up first
        imagePicker.delegate = self
        // alow user to editing picture's choice
        imagePicker.allowsEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        orientationSwipe()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        orientationSwipe()
        updateFrame()
    }
    
    func orientationSwipe() {
        if UIDevice.current.orientation.isPortrait {
            // if device is portrait
            swipeView.image = UIImage(named:"Arrow Up.png")
            swipeUpLabel.text = "Swipe up to share"
            GridSwipe.direction = .up
        } else if UIDevice.current.orientation.isLandscape {
            // else if device is portrait
            swipeView.image = UIImage(named:"Arrow Left.png")
            swipeUpLabel.text = "Swipe left to share"
            GridSwipe.direction = .left
        }
    }
    
    func setupView(){
        contentView.addSubview(addPicture1)
        contentView.addSubview(addPicture2)
        contentView.addSubview(addPicture3)
        contentView.addSubview(addPicture4)
        contentView.addSubview(pictureView1)
        contentView.addSubview(pictureView2)
        contentView.addSubview(pictureView3)
        contentView.addSubview(pictureView4)
        pictureView1.isHidden = false
        pictureView2.isHidden = false
        pictureView3.isHidden = false
        pictureView4.isHidden = true
        addPicture1.addTarget(self, action: #selector(self.takePicture1(sender:)), for: .touchUpInside)
        addPicture2.addTarget(self, action: #selector(self.takePicture2(sender:)), for: .touchUpInside)
        addPicture3.addTarget(self, action: #selector(self.takePicture3(sender:)), for: .touchUpInside)
        addPicture4.addTarget(self, action: #selector(self.takePicture4(sender:)), for: .touchUpInside)
        layoutFirstView()
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
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { self.contentView.transform = .identity
            }
                ,completion: nil)
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
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: { self.contentView.transform = .identity
            }
                ,completion: nil)
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
        {
            return
            
        }
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
        addPicture1.frame = CGRect(x: 15, y: 15, width: contentView.frame.width - 30, height: (contentView.frame.height / 2 ) - 20)
        // button 2
        addPicture2.frame = CGRect(x: 15, y: addPicture1.frame.height + 25 , width: (contentView.frame.width / 2 ) - 20, height: addPicture1.frame.height)
        // Button 3
        addPicture3.frame = CGRect(x: addPicture2.frame.width + 25, y: addPicture1.frame.height + 25, width: addPicture2.frame.width, height: addPicture2.frame.height)
        // Button 4
        addPicture4.frame = CGRect(x: addPicture1.frame.width + 15, y: 15, width: 0, height: addPicture1.frame.height)
        addPicture4.isHidden = true
        pictureView4.isHidden = true
        updateFrame()
    }
    
    private func layoutSecondView() {
        // second layout in grid when user push on LayoutView2 button
        // Button 1
        addPicture1.frame = CGRect(x: 15, y: 15, width: (contentView.frame.width / 2) - 20, height: (contentView.frame.height / 2) - 20)
        // Button 2
        addPicture2.frame = CGRect(x: addPicture1.frame.width + 25, y: 15, width: addPicture1.frame.width, height: addPicture1.frame.height)
        // Button 3
        addPicture3.frame = CGRect(x: 15, y: addPicture1.frame.height + 25, width: contentView.frame.height - 30, height: addPicture1.frame.height)
        // Button 4
        addPicture4.frame = CGRect(x: 15, y: 15, width: 0, height: addPicture1.frame.height)
        pictureView4.isHidden = true
        addPicture4.isHidden = true
        updateFrame()
    }
    
    private func layoutThirdView() {
        // third layout in grid when user push on LayoutView3 button
        // Button 1
        addPicture1.frame = CGRect(x: 15,y: 15,width: (contentView.frame.width / 2) - 20, height: (contentView.frame.height / 2) - 20)
        // Button 2
        addPicture2.frame = CGRect(x: addPicture1.frame.width + 25, y: 15, width: addPicture1.frame.width, height: addPicture1.frame.height)
        // Button 3
        addPicture3.frame = CGRect(x: 15, y: addPicture1.frame.height + 25, width: addPicture1.frame.width, height: addPicture1.frame.height)
        // Button 4
        addPicture4.isHidden = false
        pictureView4.isHidden = false
        addPicture4.frame = CGRect(x: addPicture3.frame.width + 25 ,y: addPicture2.frame.height + 25 ,width: addPicture2.frame.width ,height: addPicture4.frame.height)
        updateFrame()
    }
    
    private func updateFrame(){
        pictureView1.frame = addPicture1.frame
        pictureView1.contentMode = .scaleToFill
        pictureView2.frame = addPicture2.frame
        pictureView1.contentMode = .scaleToFill
        pictureView3.frame = addPicture3.frame
        pictureView1.contentMode = .scaleToFill
        pictureView4.frame = addPicture4.frame
        pictureView1.contentMode = .scaleToFill
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
    
    @objc func takePicture1(sender: addPhotoButton){
        alerteAction()
        imageTmp = pictureView1
        pictureView1.frame = addPicture1.frame
    }
    
    @objc func takePicture2(sender: addPhotoButton){
        alerteAction()
        imageTmp = pictureView2
        pictureView2.frame = addPicture2.frame
    }
    
    @objc func takePicture3(sender: addPhotoButton){
        alerteAction()
        imageTmp = pictureView3
        pictureView3.frame = addPicture3.frame
    }
    
    @objc func takePicture4(sender: addPhotoButton){
        alerteAction()
        imageTmp = pictureView4
        pictureView4.frame = addPicture4.frame
    }
    
    // MARK:Swip function
    @IBAction func swipeGesure(_ sender: UISwipeGestureRecognizer) {
        convertViewToImage()
        if UIDevice.current.orientation.isPortrait {
            moveViewVertically(movement: .out)
        } else if UIDevice.current.orientation.isLandscape {
            moveViewHorizontally(movement: .out)
        }
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

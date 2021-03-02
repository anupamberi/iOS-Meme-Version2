//
//  MemeEditorViewController.swift
//  ImagePicker
//
//  Created by Anupam Beri on 31/01/2021.
//

import UIKit

/**
 The main view controller of the Meme editor. This view controller acts as a delegate for
 
 TOP  & BOTTOM text fields by implementing the protocol UITextFieldDelegate
 IMAGE PICKER view by implementing the protocols UIImagePickerControllerDelegate and UINavigationControllerDelegate
 */
class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Properties and outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var navbar: UINavigationBar!
    
    // MARK: Text Field Attributes
    
    let memeTextAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5.0,
    ];
    
    // MARK: Viewcontroller Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(image: UIImage(named: "Cancel"), style: .plain, target: self, action: #selector(cancel(_:)))
        self.navigationItem.rightBarButtonItem = cancelButton
        
        // Disable share button
        self.shareButton.isEnabled = false
        // Assign text properties & delegates
        self.setTextProperties()
    }

    @objc func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the status of the camera button based on if the source is available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Subscribed to keyboard show/hide notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    // Subscribes to keyboard show/hide notifications
    func subscribeToKeyboardNotifications() {
        // Subscribe to keyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Subscribe to keyboardWillHideNotification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Unsubscribe to keyboard show/hide notifications
    func unsubscribeToKeyboardNotifications() {
        // UnSubscribe to keyboardWillShowNotification
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        // UnSubscribe to keyboardWillHideNotification
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Move the display frame upwards to display text being ediited by subtracting the keyboard height
    @objc func keyboardWillShow(_ notification: Notification) {
        // Check if the first responder is the bottom text field. This is to avoid the sliding up when the
        // top text field is selected.
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Reset the keyboard display to its original frame
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // Calculates the keyboard height based on the input notification userInfo
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Select an image from photo library
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        self.pickAnImage(from: .photoLibrary)
    }
    
    // Select an image by activating the camera library
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        self.pickAnImage(from: .camera)
    }
    
    // Pick an image from the given input source
    func pickAnImage(from source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Dismiss the image picker on pressing the cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the image picker to select an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            // Activate the share button as the image has been chosen
            self.shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Utility function to set properties of top & bottom text fields
    func setTextProperties() {
        setTextFieldAttributes(topTextField, "TOP")
        setTextFieldAttributes(bottomTextField, "BOTTOM")
    }
    
    // Set the parameters of the top & bottom textfields
    func setTextFieldAttributes(_ textField: UITextField, _ placeholderText: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
    }
    
    func save(_ memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        // Add meme to the memes array on the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        // Notify observers about meme added
        NotificationCenter.default.post(name: NSNotification.Name(rawValue : "refresh"), object: nil)
    }
    
    // Generates a Memed image
    func generateMemeImage() -> UIImage {

        // Hide navbar and toolbar
        self.setNavAndToolbarHiddenStatus(hideStatus: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show navbar and toolbar
        self.setNavAndToolbarHiddenStatus(hideStatus: false)
        print("MemedImage Size \(memedImage.size)")
        return memedImage
    }
    
    // Set the navbar and toolbar isHidden property to given status
    func setNavAndToolbarHiddenStatus(hideStatus status: Bool) {
        self.navbar.isHidden = status
        self.toolbar.isHidden = status
    }
    
    // Present an activity controller to share the memed image
    @IBAction func shareMeme(_ sender: Any) {
        // Generate a memed image
        let memedImage = self.generateMemeImage()
        // Define an activity controller
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                // User completed activity. Dismiss the activity controller and save the memed image
                self.save(memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        // Present the activity view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}


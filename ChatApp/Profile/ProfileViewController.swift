//
//  ViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 14.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var operationSaveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let loadManager = GCDDataManager()
//    let loadManager = OperationDataManager()
    var saveManager: GetAndSaveProfileProtocol!
    var userProfile: UserProfile?
    var newUserProfile: UserProfile?
    
    var editMode: Bool = false
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //print("Init:", saveButton.frame)
        /* Ничего не напечаталось, так как на этапе инициализации мы только ищем и
         связываем .xib файл с UIViewController. Здесь еще нет аутлетов и вью.
         */
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        descriptionTextView.delegate = self
        editImageButton.isHidden = true
        activityIndicator.startAnimating()
        
        switchEditMode(isDataChanged: editMode)
        
        initialsLabel.isHidden = true
        self.nameTextField.borderStyle = .none
        self.nameTextField.isUserInteractionEnabled = false
        self.descriptionTextView.isEditable = false
        self.descriptionTextView.layer.borderWidth = 0
        
        //photoImageView.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.17, alpha: 1.00)
        photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2
        
        loadManager.getProfile { (userProfile) in
            self.nameTextField.text = userProfile.name
            self.descriptionTextView.text = userProfile.description
            self.photoImageView.image = userProfile.photo
            self.userProfile = userProfile
            self.activityIndicator.stopAnimating()
        }
        
        registerNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //print("ViewDidAppear:", saveButton.frame)
        /*
         frame отличаются, потому что в методе viewDidload еще не установлены финальные размеры и положения subviews
         */
    }
    
    @IBAction func saveGCDAction(_ sender: Any) {
        saveManager = GCDDataManager()
        operationSaveButton.layer.borderColor = UIColor.gray.cgColor
        operationSaveButton.setTitleColor(UIColor.gray, for: .normal)
        gcdSaveButton.layer.borderColor = UIColor.gray.cgColor
        gcdSaveButton.setTitleColor(UIColor.gray, for: .normal)
        gcdSaveButton.isEnabled = false
        operationSaveButton.isEnabled = false
        saveData()
        saveButtonsFadeFunction()
    }
    
    @IBAction func saveOperationAction(_ sender: Any) {
        saveManager = OperationDataManager()
        operationSaveButton.layer.borderColor = UIColor.gray.cgColor
        operationSaveButton.setTitleColor(UIColor.gray, for: .normal)
        gcdSaveButton.layer.borderColor = UIColor.gray.cgColor
        gcdSaveButton.setTitleColor(UIColor.gray, for: .normal)
        gcdSaveButton.isEnabled = false
        operationSaveButton.isEnabled = false
        saveData()
        saveButtonsFadeFunction()
    }
    
    func saveData() {
        
        guard newUserProfile?.dataWasChanged == true else {
            return
        }
        
        activityIndicator.startAnimating()
        
        let newName = nameTextField.text ?? "Name"
        let newDescription = descriptionTextView.text ?? "Description"
        let newPhoto = photoImageView.image ?? UIImage(named: "avatarPlaceholder")!
        
        newUserProfile?.name = newName
        newUserProfile?.description = newDescription
        newUserProfile?.photo = newPhoto
        
        saveManager.saveProfile(profile: newUserProfile!) { error in
            
            if error == nil {
                
                self.newUserProfile?.dataWasChanged = false
                self.switchEditMode(isDataChanged: self.newUserProfile?.dataWasChanged ?? false)
                
                let completeAlert = UIAlertController(title: "Changes saved", message: nil, preferredStyle: .alert)
                let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                completeAlert.addAction(continueAction)
                self.present(completeAlert, animated: true, completion: nil)
                
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Can't save changes", preferredStyle: .alert)
                let continueAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let repeatAction = UIAlertAction(title: "Repeat", style: .default, handler: { (_) in
                    self.saveData()
                })
                errorAlert.addAction(continueAction)
                errorAlert.addAction(repeatAction)
                self.present(errorAlert, animated: true, completion: nil)
            }
            
            self.activityIndicator.stopAnimating()
    }
        
    }
    
    @IBAction func editImageButtonAction(_ sender: Any) {
        
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Камера не обнаружена", message: "На вашем устройстве не обнаружена камера", preferredStyle: .alert)
                let result = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(result)
                self.present(alert, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: nil))
        
        let contentView = alert.view.subviews.first?.subviews.first?.subviews.first
        contentView?.backgroundColor = Theme.current.alertBackgroundColor
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        saveButtonsFadeFunction()
        newUserProfile = UserProfile()
    }
    
    func saveButtonsFadeFunction() {
        
        editMode = !editMode
        
        if editMode {
            self.nameTextField.isUserInteractionEnabled = true
            self.descriptionTextView.isEditable = true
            editImageButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.nameTextField.borderStyle = .roundedRect
                self.descriptionTextView.layer.borderWidth = 1
                self.descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.nameTextField.borderStyle = .none
                self.nameTextField.isUserInteractionEnabled = false
                self.descriptionTextView.isEditable = false
                self.descriptionTextView.layer.borderWidth = 0
            }, completion: { (_) in
                self.editImageButton.isHidden = true
            })
        }
        
    }
    
    @IBAction func nameFieldEditingChanged(_ sender: UITextField) {
        
        if sender.text != userProfile?.name {
            newUserProfile?.nameWasChanged = true
            newUserProfile?.dataWasChanged = true
        } else {
            newUserProfile?.nameWasChanged = false
            newUserProfile?.dataWasChanged = newUserProfile?.descriptionWasChanged ?? false || newUserProfile?.photoWasChanged ?? false
        }
        
        switchEditMode(isDataChanged: newUserProfile?.dataWasChanged ?? false)
        
    }
    
    func switchEditMode(isDataChanged: Bool) {
        
        if isDataChanged {
            operationSaveButton.layer.borderColor = UIColor.black.cgColor
            operationSaveButton.setTitleColor(UIColor.systemBlue, for: .normal)
            gcdSaveButton.layer.borderColor = UIColor.black.cgColor
            gcdSaveButton.setTitleColor(UIColor.systemBlue, for: .normal)
            gcdSaveButton.isEnabled = true
            operationSaveButton.isEnabled = true
        } else {
            operationSaveButton.layer.borderColor = UIColor.gray.cgColor
            operationSaveButton.setTitleColor(UIColor.gray, for: .normal)
            gcdSaveButton.layer.borderColor = UIColor.gray.cgColor
            gcdSaveButton.setTitleColor(UIColor.gray, for: .normal)
            gcdSaveButton.isEnabled = false
            operationSaveButton.isEnabled = false
        }
        
    }
    
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        nameTextField?.textColor = Theme.current.textColor
        descriptionTextView?.textColor = Theme.current.textColor
        descriptionTextView?.backgroundColor = Theme.current.backgroundColor
        gcdSaveButton?.backgroundColor = Theme.current.saveButtonColor
        operationSaveButton?.backgroundColor = Theme.current.saveButtonColor
        headerLabel?.textColor = Theme.current.textColor
        headerView?.backgroundColor = Theme.current.profileHeaderColor
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiilDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidAppear(_ notification: NSNotification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        view.frame.origin.y = -keyboardRect.height
    }
    
    @objc func keyboardWiilDissapear() {
        view.frame.origin.y = 0
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        photoImageView.image = pickedImage
        photoImageView.backgroundColor = .clear
        initialsLabel.isHidden = true
        newUserProfile?.photoWasChanged = true
        newUserProfile?.dataWasChanged = true
        picker.dismiss(animated: true, completion: nil)
        switchEditMode(isDataChanged: newUserProfile?.dataWasChanged ?? false)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text != userProfile?.description {
            newUserProfile?.descriptionWasChanged = true
            newUserProfile?.dataWasChanged = true
        } else {
            newUserProfile?.descriptionWasChanged = false
            newUserProfile?.dataWasChanged = newUserProfile?.nameWasChanged ?? false || newUserProfile?.photoWasChanged ?? false
        }
        
        switchEditMode(isDataChanged: newUserProfile?.dataWasChanged ?? false)
        
    }
}

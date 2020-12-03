//
//  ViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 14.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

enum ProfileSavingType {
  case operation
  case gcd
}

final class ProfileViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var setImageButton: UIButton!
    @IBOutlet weak var initialsLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var GCDButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var GCDButtonIsClick = false
    var savingType: ProfileSavingType = .gcd
    
    var presentationAssembly: IPresentationAssembly!
    var profile: Profile!
    var model: IProfileModel!

    let imagePicker = UIImagePickerController()
    
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        profile = Profile(userName: nameTextField.text ?? "", userBio: bioTextView.text, userData: avatarImageView.image?.pngData() ?? Data())
        
        self.configure()
        guard let model = self.model
        else { return }
        
        model.retriveProfile { [weak self] result in
          guard let self = self
          else { return }
          switch result {
          case .success(let profile):
            self.nameTextField.text = profile.userName
            self.bioTextView.text = profile.userBio
            self.avatarImageView.image = UIImage(data: profile.userData)
          case .failure(let error):
            print(error.localizedDescription)
          }
        }
        addKeyboardGesture()
    }
    
    func setupDepenencies(model: IProfileModel?,
                          presentationAssembly: IPresentationAssembly?) {
      self.model = model
      self.presentationAssembly = presentationAssembly
    }
    
    private func configure() {
        
      imagePicker.delegate = self
      
      addNotifications()
      unEnabledUIElements()
      
      activityIndicator.stopAnimating()
      activityIndicator.hidesWhenStopped = true
      
      operationButton.clipsToBounds = true
      operationButton.layer.cornerRadius = 10
      
      GCDButton.clipsToBounds = true
      GCDButton.layer.cornerRadius = 10
      GCDButton.addTarget(self, action: #selector(GCDButtonTapped), for: .touchUpInside)
        
      setTheme()
      initialsLabel.isHidden = true
      self.bioTextView.isEditable = false
      avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    private func enabledUIElements() {
      setImageButton.isHidden = false
      nameTextField.isEnabled = true
      bioTextView.isEditable = true
    }
    
    private func unEnabledUIElements() {
      setImageButton.isHidden = true
      nameTextField.isEnabled = false
      bioTextView.isEditable = false
      unEnabledButtons()
    }
    
    func enabledButtons() {
      self.GCDButton.isEnabled = true
      self.operationButton.isEnabled = true
    }
    
    func unEnabledButtons() {
      GCDButton.isEnabled = false
      operationButton.isEnabled = false
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if isEditMode {
          unEnabledUIElements()
          unEnabledButtons()
          ButtonAnimation.stopShake(editButton)
          isEditMode = false
        } else {
          enabledUIElements()
          enabledButtons()
          ButtonAnimation.shake(editButton)
          isEditMode = true
        }
    }
    
    @IBAction func setImageButtonTapped(_ sender: Any) {
        
        imagePicker.delegate = self

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
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

        alert.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: { (_) in
            guard let galleryVC = self.presentationAssembly?.galleryViewController() else { return }
            galleryVC.delegate = self
            self.present(galleryVC, animated: true)
        }))

        alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: nil))

        let contentView = alert.view.subviews.first?.subviews.first?.subviews.first
        contentView?.backgroundColor = Theme.current.alertBackgroundColor

        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func operationButtonTapped(_ sender: Any) {
        unEnabledButtons()
        activityIndicator.startAnimating()
        guard let profile = self.profile
        else { return }
        model.save(profile: profile) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success:
            self.updateUI()
          case .failure:
            print("Не удалось сохранить изменения")
          }
        }
    }
  
    @IBAction func GCDButtonTapped(_ sender: Any) {
        GCDButtonIsClick = true
        activityIndicator.startAnimating()
        unEnabledButtons()
        
        guard let profile = self.profile,
              let model = self.model
        else { return }
        model.save(profile: profile) { [weak self] result in
          guard let self = self else { return }
          switch result {
          case .success:
            self.updateUI()
          case .failure:
            print("Не удалось сохранить изменения")
          }
        }
    }
    
    private func updateUI() {
      activityIndicator.stopAnimating()
      unEnabledUIElements()
      editButton.isEnabled = true
    }
    
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
        nameTextField?.textColor = Theme.current.textColor
        bioTextView?.textColor = Theme.current.textColor
        bioTextView?.backgroundColor = Theme.current.backgroundColor
        GCDButton?.backgroundColor = Theme.current.saveButtonColor
        operationButton?.backgroundColor = Theme.current.saveButtonColor
        headerLabel?.textColor = Theme.current.textColor
        headerView?.backgroundColor = Theme.current.profileHeaderColor
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }

        avatarImageView.image = pickedImage
        avatarImageView.backgroundColor = .clear
        initialsLabel.isHidden = true
        self.profile?.userData = avatarImageView.image?.pngData() ?? Data()
        self.profile?.photoChanged = true
        enabledButtons()
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension ProfileViewController {
    private func addKeyboardGesture() {
        let keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        keyboardHideGesture.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(keyboardHideGesture)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let size = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue)?.cgRectValue
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: ((size?.height ?? 0) - (bottomPadding ?? 0)), right: 0)
        self.scrollView?.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
    }
    
    @objc private func hideKeyboard() {
        self.scrollView.endEditing(true)
    }
}

extension ProfileViewController: GalleryViewControllerDelegate {
  func updateProfile(_ galleryViewController: GalleryViewController, urlImageData: Data) {
    avatarImageView.image = UIImage(data: urlImageData)
    updateProfile()
  }
  
  private func updateProfile() {
    avatarImageView.contentMode = .scaleAspectFill
    avatarImageView.clipsToBounds = true
    self.profile?.userData = avatarImageView.image?.pngData() ?? Data()
    self.profile?.photoChanged = true
    enabledButtons()
  }
}

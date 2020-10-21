//
//  ViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 14.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var initialsLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        print("Init:", saveButton.frame)
        /* Ничего не напечаталось, так как на этапе инициализации мы только ищем и
         связываем .xib файл с UIViewController. Здесь еще нет аутлетов и вью.
         */
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad:", saveButton.frame)
        
        saveButton.isUserInteractionEnabled = false // чтобы приложение не крашилось, пока не назначен action
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        photoImageView.backgroundColor = UIColor(red: 0.89, green: 0.91, blue: 0.17, alpha: 1.00)
        photoImageView.layer.cornerRadius = photoImageView.bounds.width / 2
        saveButton.layer.cornerRadius = 14
        saveButton.clipsToBounds = true
    }
    
    @IBAction func actionEditButton(_ sender: Any) {
        
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
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        photoImageView.image = pickedImage
        photoImageView.backgroundColor = .clear
        initialsLabel.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("ViewDidAppear:", saveButton.frame)
        /*
         frame отличаются, потому что в методе viewDidload еще не установлены финальные размеры и положения subviews
         */
    }
}

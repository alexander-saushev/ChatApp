//
//  ProfileVC + UITextField + UITextView.swift
//  ChatApp
//
//  Created by Александр Саушев on 08.11.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

extension ProfileViewController: UITextFieldDelegate {

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    nameTextField = textField
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == nameTextField {
      self.nameTextField.resignFirstResponder()
      self.nameTextField = nil
    }
    return true
  }
}

extension ProfileViewController: UITextViewDelegate {
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    bioTextView = textView
    return true
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      if text == "\n" {
          textView.resignFirstResponder()
          return false
      }
      return true
  }
}

extension ProfileViewController {
  
  func addNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextView.textDidChangeNotification, object: nil)
  }
  
  @objc func textFieldDidChange(notification: Notification) {
    enabledButtons()
    
    self.profile?.userName = nameTextField.text ?? ""
    self.profile?.nameChanged = true
  }
  
  @objc func textDidChange(notification: Notification) {
    enabledButtons()
    
    self.profile?.userBio = bioTextView.text ?? ""
    self.profile?.bioChanged = true
  }
  
  @objc
  func returnTextView(gesture: UIGestureRecognizer) {
    guard nameTextField != nil, bioTextView != nil
    else {
      nameTextField = nil
      bioTextView = nil
      return
    }
    nameTextField.resignFirstResponder()
    bioTextView.resignFirstResponder()
  }
}

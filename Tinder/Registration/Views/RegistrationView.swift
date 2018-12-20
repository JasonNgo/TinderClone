//
//  RegistrationView.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class RegistrationView: UIView {
  
  let gradientLayer = CAGradientLayer()
  
  let selectPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Select Photo", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
    button.backgroundColor = .white
    button.layer.cornerRadius = 16
    button.heightAnchor.constraint(equalToConstant: 275).isActive = true
    return button
  }()
  
  let fullNameTextfield: RegistrationTextField = {
    let tf = RegistrationTextField(padding: 16)
    tf.placeholder = "Enter full name"
    return tf
  }()
  
  let emailTextfield: RegistrationTextField = {
    let tf = RegistrationTextField(padding: 16)
    tf.placeholder = "Enter email"
    tf.keyboardType = .emailAddress
    return tf
  }()
  
  let passwordTextfield: RegistrationTextField = {
    let tf = RegistrationTextField(padding: 16)
    tf.placeholder = "Enter password"
    tf.isSecureTextEntry = true
    return tf
  }()
  
  let registerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Register", for: .normal)
    button.setTitleColor(.darkGray, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    button.titleLabel?.textAlignment = .center
    button.backgroundColor = #colorLiteral(red: 0.6693089008, green: 0.666139245, blue: 0.6693861485, alpha: 1)
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.layer.cornerRadius = 22
    button.isEnabled = false
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews:
      [selectPhotoButton, fullNameTextfield, emailTextfield, passwordTextfield,registerButton]
    )
    sv.spacing = 12
    sv.axis = .vertical
    return sv
  }()
  
  // MARK: - Overrides
  
  override func layoutSubviews() {
    gradientLayer.frame = self.frame
  }
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupGradientLayer()
    setupSubviews()
  }
  
  // MARK: - Setup
  
  fileprivate func setupGradientLayer() {
    gradientLayer.colors = [#colorLiteral(red: 0.9927631021, green: 0.3520521522, blue: 0.3868964016, alpha: 1).cgColor, #colorLiteral(red: 0.8971359134, green: 0.1123924479, blue: 0.4676757455, alpha: 1).cgColor]
    gradientLayer.locations = [0, 1]
    layer.addSublayer(gradientLayer)
  }
  
  fileprivate func setupSubviews() {
    addSubview(stackView)
    stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    stackView.anchor(
      top: nil,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 0, left: 50, bottom: 0, right: 50)
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
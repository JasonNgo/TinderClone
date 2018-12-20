//
//  RegistrationTextField.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-20.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class RegistrationTextField: UITextField {
  
  let padding: CGFloat
  
  init(padding: CGFloat) {
    self.padding = padding
    super.init(frame: .zero)
    backgroundColor = .white
    layer.cornerRadius = 25
  }
  
  override var intrinsicContentSize: CGSize {
    return .init(width: 0, height: 50)
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: padding, dy: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

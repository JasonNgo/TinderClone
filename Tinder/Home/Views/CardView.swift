//
//  CardView.swift
//  Tinder
//
//  Created by Jason Ngo on 2018-12-19.
//  Copyright © 2018 Jason Ngo. All rights reserved.
//

import UIKit

class CardView: UIView {
  
  // MARK: - Views
  
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let gradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    gradientLayer.locations = [0.5, 1.1]
    return gradientLayer
  }()
  
  private let imageSelectionStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let informationLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .white
    return label
  }()
  
  // MARK: - Configuration Constants
  
  fileprivate let panGestureThreshold: CGFloat = 80
  fileprivate let unselectedImageColor = UIColor(white: 0, alpha: 0.1)
  
  // MARK: - View Model
  
  var cardViewModel: CardViewModel! {
    didSet {
      informationLabel.attributedText = cardViewModel.attributedText
      informationLabel.textAlignment = cardViewModel.textAlignment

      (0..<cardViewModel.imageNames.count).forEach { (_) in
        let view = UIView()
        view.backgroundColor = unselectedImageColor
        imageSelectionStackView.addArrangedSubview(view)
      }
      
      // setup observer
      cardViewModel.selectedImageObserver = { [weak self] (index, image) in
        guard let self = self else { return }
        guard let image = image else { return }
        
        self.backgroundImageView.image = image
        self.imageSelectionStackView.arrangedSubviews.forEach { $0.backgroundColor = self.unselectedImageColor }
        self.imageSelectionStackView.arrangedSubviews[index].backgroundColor = .white
      }
      
      guard let firstImage = UIImage(named: cardViewModel.imageNames.first ?? "") else { return }
      backgroundImageView.image = firstImage
      imageSelectionStackView.arrangedSubviews.first?.backgroundColor = .white
    }
  }
  
  // MARK: - Overrides
  
  override func layoutSubviews() {
    gradientLayer.frame = self.frame
  }
  
  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
    setupGestures()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Setup 
  
  fileprivate func setupSubviews() {
    layer.cornerRadius = 10
    clipsToBounds = true
    
    addSubview(backgroundImageView)
    backgroundImageView.fillSuperview()
    
    setupImageSelectionStackView()
    
    layer.addSublayer(gradientLayer)
    
    addSubview(informationLabel)
    informationLabel.anchor(
      top: nil,
      leading: backgroundImageView.leadingAnchor,
      bottom: backgroundImageView.bottomAnchor,
      trailing: backgroundImageView.trailingAnchor,
      padding: .init(top: 0, left: 20, bottom: 20, right: 20)
    )
  }
  
  fileprivate func setupImageSelectionStackView() {
    addSubview(imageSelectionStackView)
    imageSelectionStackView.anchor(
      top: topAnchor,
      leading: leadingAnchor,
      bottom: nil,
      trailing: trailingAnchor,
      padding: .init(top: 8, left: 8, bottom: 0, right: 8),
      size: .init(width: 0, height: 4)
    )
  }
  
  fileprivate func setupGestures() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
    [panGesture, tapGesture].forEach { addGestureRecognizer($0) }
  }
  
}

// MARK: - Gestures
extension CardView {
  
  @objc fileprivate func handleTapGesture(_ gesture: UITapGestureRecognizer) {
    let tapLocation = gesture.location(in: nil)
    let shouldAdvanceToNextPhoto = tapLocation.x > (frame.width / 2) ? true : false
    if shouldAdvanceToNextPhoto {
      cardViewModel.goToNextPhoto()
    } else {
      cardViewModel.goToPreviousPhoto()
    }
  }
  
  @objc fileprivate func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      superview?.subviews.forEach { $0.layer.removeAllAnimations() }
    case .changed:
      handlePanGestureChanged(gesture)
    case .ended:
      handlePanGestureEnded(gesture)
    default:
      ()
    }
  }
  
  fileprivate func handlePanGestureChanged(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    let degree = translation.x / 20
    let rotationAngle = degree * .pi / 180
    let rotationalTransformation = CGAffineTransform(rotationAngle: rotationAngle)
    let rotateAndTranslateTransformation = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    transform = rotateAndTranslateTransformation
  }
  
  fileprivate func handlePanGestureEnded(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: nil)
    let shouldDismissCard = translation.x > panGestureThreshold || translation.x < -panGestureThreshold
    
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
      if shouldDismissCard {
        if translation.x > 0 {
          self.frame = CGRect(x: 1000, y: 0, width: self.frame.width, height: self.frame.height)
        } else {
          self.frame = CGRect(x: -1000, y: 0, width: self.frame.width, height: self.frame.height)
        }
      } else {
        self.transform = .identity
      }
    }) { (_) in
      self.transform = .identity
      if shouldDismissCard {
        self.removeFromSuperview()
      }
    }
  }
  
}


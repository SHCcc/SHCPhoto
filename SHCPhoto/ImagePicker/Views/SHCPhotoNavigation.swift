//
//  SHCPhotoNavigation.swift
//  Kingfisher
//
//  Created by 邵焕超 on 2018/7/9.
//

import UIKit

class SHCPhotoNavigation: UINavigationController {

  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    buildUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setAlphe(alpha: 0.9)
    UIApplication.shared.statusBarStyle = .lightContent
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.statusBarStyle = .default
  }
}


extension SHCPhotoNavigation{
  func buildUI() {
    self.navigationBar.barTintColor = UIColor.black
    self.navigationBar.tintColor = UIColor.white
    self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
  }
  
  func setAlphe(alpha: CGFloat) {
    guard let barBackgroundView = self.navigationBar.subviews.first else { return }
    let backgroundImageView = barBackgroundView.subviews.first as? UIImageView

    if !navigationBar.isTranslucent || (backgroundImageView != nil && backgroundImageView?.image != nil) {
      barBackgroundView.alpha = alpha
      backgroundImageView?.alpha = alpha
    }else {
      if barBackgroundView.subviews.count < 2 { return }
      let backgroundEffectView = barBackgroundView.subviews[1]
      backgroundEffectView.alpha = alpha
    }
  }
}

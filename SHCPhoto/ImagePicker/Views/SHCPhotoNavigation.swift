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
  
}


extension SHCPhotoNavigation{
  func buildUI() {
    self.navigationBar.barTintColor = UIColor.black
    self.navigationBar.tintColor = UIColor.white
    
    self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

    
  }
}

extension SHCPhotoNavigation {
  @objc func backEvent() {
    
  }
  
  @objc func cancelEvent() {
    
  }
}

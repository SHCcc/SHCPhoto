//
//  UIImage+Bundle.swift
//  SHCHUD
//
//  Created by 邵焕超 on 2018/7/18.
//

import UIKit

extension UIImage {
  
  /// 从bundle里面获取图片
  ///
  /// - Parameters:
  ///   - named: 图片名字
  ///   - selfClass: 当前类
  convenience init?(named: String, selfClass: AnyClass) {
    let bundle = UIImage.bundle(selfClass: selfClass)
    self.init(named: named, in: bundle, compatibleWith: nil)
  }
  
  class func bundle(selfClass: AnyClass) ->Bundle {
    guard let path = Bundle(for: selfClass.self).path(forResource: "Photo", ofType: "bundle") else { return Bundle() }
    guard let bundle = Bundle(path: path) else { return Bundle() }
    return bundle
  }
}




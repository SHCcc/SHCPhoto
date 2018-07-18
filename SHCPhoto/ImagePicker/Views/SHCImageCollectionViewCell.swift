//
//  SHCImageCollectionViewCell.swift
//  PhotoPicker
//
//  Created by 邵焕超 on 2018/5/28.
//  Copyright © 2018年 邵焕超. All rights reserved.
//

import UIKit

class SHCImageCollectionViewCell: UICollectionViewCell {
  
  var  isDisabled: Bool = false {
    didSet{
      grayView.isHidden = (isDisabled && !isSelected) ? false : true
    }
  }
  
  override var isSelected: Bool {
    didSet {
      iconView.image = isSelected ? getImage(named: "btn_check_selected_40") : getImage(named: "btn_check_normal_40")
      if !isSelected || isDisabled { return }
      UIView.animate(withDuration: 0.1, animations: {
        self.iconView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      }) { (Bool) in
        UIView.animate(withDuration: 0.2, animations: {
          self.iconView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
      }
    }
  }
  
  
  let imageView = UIImageView()
  let iconView  = UIImageView()
  private let grayView  = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    buildUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SHCImageCollectionViewCell {
  fileprivate func buildUI() {
    contentView.addSubview(imageView)
    contentView.addSubview(iconView)
    contentView.addSubview(grayView)
    
    iconView.image = getImage(named: "btn_check_normal_40")
    
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    grayView.isHidden = true
    grayView.backgroundColor = UIColor.gray
    grayView.alpha = 0.5
    
    imageView.frame = self.bounds
    grayView.frame = self.bounds
    iconView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(2)
      make.right.equalToSuperview().offset(-2)
      make.width.height.equalTo(23)
    }
    
  }
}

extension SHCImageCollectionViewCell {
  func bundle() ->Bundle {
      guard let path = Bundle(for: SHCImageCollectionViewCell.self).path(forResource: "Photo", ofType: "bundle") else { return Bundle() }
      guard let bundle = Bundle(path: path) else { return Bundle() }
      return bundle
  }

  func getImage(named: String) -> UIImage? {
    return UIImage(named: named,
                   in: bundle(),
                   compatibleWith: nil)
  }
}

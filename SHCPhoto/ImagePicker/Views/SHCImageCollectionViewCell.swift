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
      iconView.image = isSelected ? UIImage(named: "btn-add-theme-normal") : UIImage(named: "btn-add-disabled2")
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
    
    iconView.image = UIImage(named: "btn-add-disabled2")
    
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    grayView.isHidden = true
    grayView.backgroundColor = UIColor.gray
    grayView.alpha = 0.5
    
    imageView.frame = self.bounds
    grayView.frame = self.bounds
    iconView.snp.makeConstraints { (make) in
      make.right.top.equalToSuperview()
      make.width.height.equalTo(25)
    }
    
  }
}

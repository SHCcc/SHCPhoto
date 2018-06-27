//
//  SHCImageCollectionViewCell.swift
//  PhotoPicker
//
//  Created by 邵焕超 on 2018/5/28.
//  Copyright © 2018年 邵焕超. All rights reserved.
//

import UIKit

class SHCImageCollectionViewCell: UICollectionViewCell {
  
  override var isSelected: Bool {
    didSet {
      iconView.image = isSelected ? UIImage(named: "btn-select-selected") : UIImage(named: "btn-select-normal")
    }
  }
  
  var imageView = UIImageView()
  var iconView  = UIImageView()
  
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
    
    iconView.image = UIImage(named: "btn-select-normal")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    
    imageView.frame = self.bounds
    iconView.snp.makeConstraints { (make) in
      make.right.top.equalToSuperview()
      make.width.height.equalTo(25)
    }
  }
}

//
//  ViewController.swift
//  SHCPhoto
//
//  Created by 578013836@qq.com on 06/27/2018.
//  Copyright (c) 2018 578013836@qq.com. All rights reserved.
//

import UIKit
import SnapKit
import SHCPhoto

class ViewController: UIViewController {
  
  var photos = [UIImage]()
  
  var flowLayout = UICollectionViewFlowLayout()
  
  let imagePicker = UIButton()
  lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    buildUI()
  }
  
  func buildUI() {
    automaticallyAdjustsScrollViewInsets = false

    view.addSubview(imagePicker)
    view.addSubview(collectionView)
    
    flowLayout.itemSize = CGSize(width: 100, height: 100)
    flowLayout.minimumLineSpacing = 10
    flowLayout.minimumInteritemSpacing = 10
    
    collectionView.backgroundColor = UIColor.gray
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(100)
      make.left.right.equalToSuperview()
      make.height.equalTo(450)
    }
    
    imagePicker.setTitle("图片选择", for: .normal)
    imagePicker.backgroundColor = UIColor.blue
    imagePicker.addTarget(self,
                          action: #selector(imagePickerEvent),
                          for: .touchUpInside)
    imagePicker.snp.makeConstraints { (make) in
      make.width.equalTo(100)
      make.height.equalTo(44)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-30)
    }
    
  }
  
  @objc func imagePickerEvent() {
    print("imagePicker")
    SHCImagePickerViewController.show(vc: self, maxSelected: 4) { (item) in
      self.photos = item!
      self.collectionView.reloadData()
    }
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    cell.backgroundColor = UIColor.lightGray
    
    let image = photos[indexPath.item]
    
    if cell.contentView.subviews.isEmpty {
      let imageView = UIImageView(image: image)
      cell.contentView.addSubview(imageView)
      imageView.frame = cell.contentView.bounds
    }else {
      let view = cell.contentView.subviews.first!
      (view as! UIImageView).image = image
    }

    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = PhotoBrowserViewController(viewCotroller: self, delegate: self)
    vc.show(index: indexPath.item)
  }
}

extension ViewController: PhotoBrowserViewDelegate{
  func numberOfPhotos(in photoBrowser: PhotoBrowserViewController) -> Int {
    return photos.count
  }
  
  /// 实现本方法以返回默认图片，缩略图或占位图
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, thumbnailImageForIndex index: Int) -> UIImage? {
    return photos[index]
  }
  
  /// 实现本方法以返回默认图所在view，在转场动画完成后将会修改这个view的hidden属性
  /// 比如你可返回ImageView，或整个Cell
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, thumbnailViewForIndex index: Int) -> UIView? {
    let indexPath = IndexPath(item: index, section: 0)
    return collectionView.cellForItem(at: indexPath)
  }
  
  /// 实现本方法以返回高质量图片。可选
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityImageForIndex index: Int) -> UIImage? {
    return nil
  }
  
  /// 实现本方法以返回高质量图片的url。可选
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityUrlStringForIndex index: Int) -> URL? {
    return nil
  }
  
  /// 长按时回调。可选
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, didLongPressForIndex index: Int, image: UIImage) {
    
  }

}

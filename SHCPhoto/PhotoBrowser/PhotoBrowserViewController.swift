//
//  PhotoBrowserViewController.swift
//  testPhotoBrowser
//
//  Created by 邵焕超 on 2017/5/15.
//  Copyright © 2017年 邵焕超. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoBrowserViewDelegate: NSObjectProtocol {
  /// 实现本方法以返回图片数量
  func numberOfPhotos(in photoBrowser: PhotoBrowserViewController) -> Int
  
  /// 实现本方法以返回默认图片，缩略图或占位图
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, thumbnailImageForIndex index: Int) -> UIImage?
  
  /// 实现本方法以返回默认图所在view，在转场动画完成后将会修改这个view的hidden属性
  /// 比如你可返回ImageView，或整个Cell
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, thumbnailViewForIndex index: Int) -> UIView?
  
  /// 实现本方法以返回高质量图片。可选
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityImageForIndex index: Int) -> UIImage?
  
  /// 实现本方法以返回高质量图片的url。可选
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityUrlStringForIndex index: Int) -> URL?
  
  /// 长按时回调。可选
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, didLongPressForIndex index: Int, image: UIImage)
}

/// PhotoBrowserDelegate适配器
extension PhotoBrowserViewDelegate {
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityImageForIndex: Int) -> UIImage? {
    return nil
  }
  
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, highQualityUrlStringForIndex: Int) -> URL? {
    return nil
  }
  
  func photoBrowser(_ photoBrowser: PhotoBrowserViewController, didLongPressForIndex index: Int, image: UIImage) {}
  
  func pageControlOfPhotoBrowser<T: UIView>(_ photoBrowser: PhotoBrowserViewController) -> T? {
    return nil
  }
}

// MARK: - PhotoBrowserPageControl
protocol PhotoBrowserPageControlDelegate {
  /// 取PageControl，只会取一次
  func pageControlOfPhotoBrowser(_ photoBrowser: PhotoBrowserViewController) -> UIView
  
  /// 添加到父视图上时调用
  func photoBrowserPageControl(_ pageControl: UIView, didMoveTo superView: UIView)
  
  /// 让pageControl布局时调用
  func photoBrowserPageControl(_ pageControl: UIView, needLayoutIn superView: UIView)
  
  /// 页码变更时调用
  func photoBrowserPageControl(_ pageControl: UIView, didChangedCurrentPage currentPage: Int)
}

class PhotoBrowserViewController: UIViewController {
  
  weak var delegate: PhotoBrowserViewDelegate?
  
  /// 实现了PhotoBrowserPageControlDelegate协议的对象
  public var pageControlDelegate: PhotoBrowserPageControlDelegate?
  
  /// 左右两张图之间的间隙
  public var photoSpacing: CGFloat = 30
  
  /// 图片缩放模式
  public var imageScaleMode = UIViewContentMode.scaleAspectFill
  
  var presentingVC = UIViewController()
  
  var collectionView: UICollectionView
  var flowLayout = PhotoBrowserLayout()
  
  /// PageControl
  private lazy var pageControl: UIView? = { [unowned self] in
    guard let dlg = self.pageControlDelegate else {
      return nil
    }
    return dlg.pageControlOfPhotoBrowser(self)
    }()
  
  var currentIndex = 0 {
    didSet {
      animatorCoordinator?.updateCurrentHiddenView(relatedView)
      guard let dlg = pageControlDelegate, let pageControl = self.pageControl else {
        return
      }
      dlg.photoBrowserPageControl(pageControl, didChangedCurrentPage: currentIndex)
    }
  }
  
  /// 当前正在显示视图的前一个页面关联视图
  fileprivate var relatedView: UIView? {
    return delegate?.photoBrowser(self, thumbnailViewForIndex: currentIndex)
  }
  
  /// 转场协调器
  fileprivate weak var animatorCoordinator: ScaleAnimatorCoordinator?
  
  /// presentation转场动画
  fileprivate weak var presentationAnimator: ScaleAnimator?
  
  /// 标记第一次viewDidAppeared
  private var onceViewDidAppeared = false
  
  /// 保存原windowLevel
  private var originWindowLevel: UIWindowLevel!
  
  public init(viewCotroller: UIViewController, delegate: PhotoBrowserViewDelegate) {
    self.presentingVC = viewCotroller
    self.delegate = delegate
    self.flowLayout = PhotoBrowserLayout()
    self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// 展示，传入图片序号，从0开始
  public func show(index: Int) {
    currentIndex = index
    self.transitioningDelegate = self
    self.modalPresentationStyle = .custom
    self.modalPresentationCapturesStatusBarAppearance = true
    presentingVC.present(self, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // flowLayout
    flowLayout.minimumLineSpacing = photoSpacing
    flowLayout.itemSize = view.bounds.size
    
    // collectionView
    collectionView.frame = view.bounds
    collectionView.backgroundColor = UIColor.clear
    collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    collectionView.showsVerticalScrollIndicator = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: NSStringFromClass(PhotoBrowserCell.self))
    view.addSubview(collectionView)
    
    // 立即加载collectionView
    let indexPath = IndexPath(item: currentIndex, section: 0)
    collectionView.reloadData()
    collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    collectionView.layoutIfNeeded()
    // 取当前应显示的cell，完善转场动画器的设置
    if let cell = collectionView.cellForItem(at: indexPath) as? PhotoBrowserCell {
      presentationAnimator?.endView = cell.imageView
      let imageView = UIImageView(image: cell.imageView.image)
      imageView.contentMode = imageScaleMode
      imageView.clipsToBounds = true
      presentationAnimator?.scaleView = imageView
    }
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 遮盖状态栏
    coverStatusBar(true)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // 页面出来后，再显示pageControl
    guard let dlg = pageControlDelegate else {
      return
    }
    if !onceViewDidAppeared, let pc = pageControl {
      onceViewDidAppeared = true
      view.addSubview(pc)
      dlg.photoBrowserPageControl(pc, didMoveTo: view)
    }
    dlg.photoBrowserPageControl(self.pageControl!, needLayoutIn: view)
  }
  
  /// 禁止旋转
  public override var shouldAutorotate: Bool {
    return false
  }
  
  /// 遮盖状态栏。以改变windowLevel的方式遮盖
  fileprivate func coverStatusBar(_ cover: Bool) {
    let win = view.window ?? UIApplication.shared.keyWindow
    guard let window = win else {
      return
    }
    
    if originWindowLevel == nil {
      originWindowLevel = window.windowLevel
    }
    if cover {
      if window.windowLevel == UIWindowLevelStatusBar + 1 {
        return
      }
      window.windowLevel = UIWindowLevelStatusBar + 1
    } else {
      if window.windowLevel == originWindowLevel {
        return
      }
      window.windowLevel = originWindowLevel
    }
  }
}

extension PhotoBrowserViewController: UICollectionViewDataSource {
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.delegate?.numberOfPhotos(in: self) ?? 0
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PhotoBrowserCell.self), for: indexPath) as! PhotoBrowserCell
    cell.imageView.contentMode = imageScaleMode
    cell.photoBrowserCellDelegate = self
    let (image, url) = imageFor(index: indexPath.item)
    cell.setImage(image, url: url)
    return cell
  }
  
  /// 取已有图像，若有高清图，只返回高清图，否则返回缩略图和url
  private func imageFor(index: Int) -> (UIImage, URL?) {
    if let highQualityImage = delegate?.photoBrowser(self, highQualityImageForIndex: index) {
      return (highQualityImage, nil)
    }
    var highQualityUrl: URL?
    if let url = delegate?.photoBrowser(self, highQualityUrlStringForIndex: index) {
      var cacheImage: UIImage?
      let cacheType = KingfisherManager.shared.cache.imageCachedType(forKey: url.cacheKey)
      if cacheType.cached {
        switch cacheType {
        case .memory:
          cacheImage = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: url.cacheKey)
        case .disk:
          cacheImage = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: url.cacheKey)
        default:
          cacheImage = nil
        }
      }
      if cacheImage != nil {
        return (cacheImage!, nil)
      }
      highQualityUrl = url
    }
    let thumbnailImage = delegate?.photoBrowser(self, thumbnailImageForIndex: index)
    return (thumbnailImage!, highQualityUrl)
  }
}

extension PhotoBrowserViewController: UICollectionViewDelegate {
  /// 减速完成后，计算当前页
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let offsetX = scrollView.contentOffset.x
    let width = scrollView.bounds.width + photoSpacing
    currentIndex = Int(offsetX / width)
  }
}

// MARK: - 转场动画
extension PhotoBrowserViewController: UIViewControllerTransitioningDelegate {
  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // 在本方法被调用时，endView和scaleView还未确定。需于viewDidLoad方法中给animator赋值endView
    let animator = ScaleAnimator(startView: relatedView, endView: nil, scaleView: nil)
    presentationAnimator = animator
    return animator
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    // dismiss的时候
    guard let cell = collectionView.visibleCells.first as? PhotoBrowserCell else {
      return nil
    }
    let imageView = UIImageView(image: cell.imageView.image)
    imageView.contentMode = imageScaleMode
    imageView.clipsToBounds = true
    return ScaleAnimator(startView: cell.imageView, endView: relatedView, scaleView: imageView)
  }
  
  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let coordinator = ScaleAnimatorCoordinator(presentedViewController: presented, presenting: presenting)
    coordinator.currentHiddenView = relatedView
    animatorCoordinator = coordinator
    return coordinator
  }
}

extension PhotoBrowserViewController: PhotoBrowserCellDelegate {
  public func photoBrowserCellDidSingleTap(_ view: PhotoBrowserCell) {
    coverStatusBar(false)
    dismiss(animated: true, completion: nil)
  }
  
  public func photoBrowserCell(_ view: PhotoBrowserCell, didPanScale scale: CGFloat) {
    // 实测用scale的平方，效果比线性好些
    let alpha = scale * scale
    animatorCoordinator?.maskView.alpha = alpha
    // 半透明时重现状态栏，否则遮盖状态栏
    coverStatusBar(alpha >= 1.0)
  }
  
  public func photoBrowserCell(_ cell: PhotoBrowserCell, didLongPressWith image: UIImage) {
    if let indexPath = collectionView.indexPath(for: cell) {
      delegate?.photoBrowser(self, didLongPressForIndex: indexPath.item, image: image)
    }
  }
}


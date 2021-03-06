//
//  PhotoBrowserDefaultPageControlDelegate.swift
//  testPhotoBrowser
//
//  Created by 邵焕超 on 2017/5/15.
//  Copyright © 2017年 邵焕超. All rights reserved.
//

import UIKit

/// 给图片浏览器提供一个UIPageControl
class PhotoBrowserDefaultPageControlDelegate: PhotoBrowserPageControlDelegate {
    /// 总页数
    public var numberOfPages: Int
    
    public init(numberOfPages: Int) {
        self.numberOfPages = numberOfPages
    }
    
    public func pageControlOfPhotoBrowser(_ photoBrowser: PhotoBrowserViewController) -> UIView {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = numberOfPages
        return pageControl
    }
    
    public func photoBrowserPageControl(_ pageControl: UIView, didMoveTo superView: UIView) {
        // 这里可以不作任何操作
    }
    
    public func photoBrowserPageControl(_ pageControl: UIView, needLayoutIn superView: UIView) {
        pageControl.sizeToFit()
        pageControl.center = CGPoint(x: superView.bounds.midX, y: superView.bounds.maxY - 20)
    }
    
    public func photoBrowserPageControl(_ pageControl: UIView, didChangedCurrentPage currentPage: Int) {
        guard let pageControl = pageControl as? UIPageControl else {
            return
        }
        pageControl.currentPage = currentPage
    }
}

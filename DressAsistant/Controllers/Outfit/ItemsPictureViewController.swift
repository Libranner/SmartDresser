//
//  ItemsPictureViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/07/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import SnapKit

class ItemsPictureViewController: BaseViewController {
  
  convenience init(picturesURLs: [URL]) {
    self.init()
    setupUI()
    self.picturesURLs = picturesURLs
  }
  
  var picturesURLs = [URL]() {
    didSet {
      mainStackView.removeAllArrangedSubviews()
      for url in picturesURLs {
        let imageView = AsyncImageView()
        imageView.fillWithURL(url, placeholder: nil)
        mainStackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints { make in
          make.width.equalTo(view)
        }
      }
      self.pageControl.numberOfPages = picturesURLs.count
    }
  }
  
  private lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.tintColor = .white
    pageControl.currentPageIndicatorTintColor = CustomColor.selectedItemColor
    
    return pageControl
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.delegate = self
    scrollView.isScrollEnabled = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = true
    return scrollView
  }()
  
  private lazy var mainStackView: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .horizontal
    stackview.distribution = .fillEqually
    stackview.alignment = .fill
    stackview.spacing = 2
    return stackview
  }()
  
  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    scrollView.addSubview(mainStackView)
    view.addSubview(pageControl)
    
    pageControl.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().offset(-20)
    }
    
    scrollView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }
    
    mainStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension ItemsPictureViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageWidth = scrollView.bounds.width
    if pageWidth > 0 {
      pageControl.currentPage = Int(scrollView.contentOffset.x / pageWidth)
    }
  }
}

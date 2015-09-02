//
//  UIScrollView+SORefreshPrivate.h
//  SORefreshDemo
//
//  Created by scfhao on 15/9/2.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SORefreshHeaderContainer;
@class SORefreshFooterContainer;

@interface UIScrollView (SORefreshPrivate)

@property (nonatomic) CGFloat SOTopInset;
@property (nonatomic) CGFloat SOBottomInset;

@property (strong, nonatomic) SORefreshHeaderContainer *headerContainer;
@property (strong, nonatomic) SORefreshFooterContainer *footerContainer;


@end

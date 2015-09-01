//
//  UIScrollView.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContainer.h"

@class SORefreshScrollObserver;

@class SORefreshHeaderContainer;
@class SORefreshFooterContainer;

@interface UIScrollView (SORefresh)

@property (nonatomic) CGFloat SOTopInset;
@property (nonatomic) CGFloat SOBottomInset;

@property (strong, nonatomic) SORefreshScrollObserver *scrollObserver;

@property (strong, nonatomic, readonly) SORefreshHeaderContainer *headerContainer;
@property (strong, nonatomic, readonly) SORefreshFooterContainer *footerContainer;

- (void)addSORefreshNormalHeaderWithRefreshBlock:(SORefreshingBlock)refreshBlock;
- (void)addSORefreshNormalFooterWithRefreshBlock:(SORefreshingBlock)refreshBlock;

- (void)addHeaderView:(UIView<SORefreshHeaderContent> *)headerView refreshBlock:(SORefreshingBlock)refreshBlock;
- (void)addFooterView:(UIView<SORefreshFooterContent> *)footerView refreshBlock:(SORefreshingBlock)refreshBlock;

@end

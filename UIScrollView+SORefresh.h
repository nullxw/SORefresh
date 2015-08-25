//
//  UIScrollView.h
//  SORefreshDemo
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContainer.h"
@class SORefreshHeaderContainer;
@class SORefreshFooterContainer;

@interface UIScrollView (SORefresh)

@property (strong, nonatomic, readonly) SORefreshHeaderContainer *headerContainer;
@property (strong, nonatomic, readonly) SORefreshFooterContainer *footerContainer;

- (void)addSORefreshNormalHeaderWithRefreshBlock:(SORefreshingBlock)refreshBlock;
- (void)addSORefreshNormalFooterWithRefreshBlock:(SORefreshingBlock)refreshBlock;

- (void)addHeaderView:(UIView<SORefreshHeaderContent> *)headerView refreshBlock:(SORefreshingBlock)refreshBlock;
- (void)addFooterView:(UIView<SORefreshFooterContent> *)footerView refreshBlock:(SORefreshingBlock)refreshBlock;

@end

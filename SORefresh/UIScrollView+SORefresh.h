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

@interface UIScrollView (SORefresh)

@property (strong, nonatomic) SORefreshScrollObserver *scrollObserver;

/*!
    @brief 为UIScrollView或其子类对象通过block参数创建SORefresh默认提供的header。
    @param header刷新时将会执行的block。
 */
- (void)addSORefreshNormalHeaderWithRefreshBlock:(SORefreshingBlock)refreshBlock;
/*!
    @brief 为UIScrollView或其子类对象通过block参数创建SORefresh默认提供的footer。
    @param footer刷新时将会执行的block。
 */
- (void)addSORefreshNormalFooterWithRefreshBlock:(SORefreshingBlock)refreshBlock;

/*!
     @brief 为UIScrollView或其子类对象通过block参数创建自定义的header。
     @param 由用户自定义的header对象
     @param header刷新时将会执行的block。
 */
- (void)addHeaderView:(UIView<SORefreshHeaderContent> *)headerView refreshBlock:(SORefreshingBlock)refreshBlock;
/*!
     @brief 为UIScrollView或其子类对象通过block参数创建自定义的footer。
     @param 由用户自定义的footer对象
     @param footer刷新时将会执行的block。
 */
- (void)addFooterView:(UIView<SORefreshFooterContent> *)footerView refreshBlock:(SORefreshingBlock)refreshBlock;

@end

//
//  SORefreshContainer.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContent.h"
@class SORefreshScrollObserver;

typedef void(^SORefreshingBlock)();

/*!
    @interface SORefreshContainer
    @superclass superclass: UIView
    
    @brief SORefreshHeaderContainer和SORefreshFooterContainer的共同父类。
 */
@interface SORefreshContainer : UIView

/** 刷新界面，可自定义，只有实现SORefreshHeaderContent或SORefreshFooterContent协议即可 */
@property (strong, nonatomic) UIView<SORefreshContent> *content;
/* 刷新回调 */
@property (copy, nonatomic) SORefreshingBlock refreshingBlock;
/** 刷新界面的高度 */
- (CGFloat)contentHeight;

@end

#pragma mark - 下拉刷新界面容器
@interface SORefreshHeaderContainer : SORefreshContainer

@property (strong, nonatomic) UIView<SORefreshHeaderContent> *content;

@end

#pragma mark - 上拉刷新界面容器
@interface SORefreshFooterContainer : SORefreshContainer

@property (strong, nonatomic) UIView <SORefreshFooterContent> *content;

@end

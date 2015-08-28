//
//  SORefreshContainer.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContent.h"

typedef void(^SORefreshingBlock)();

/*!
 @enum SORefreshState
 @brief SORefreshContainer内部状态，不需要向用户
 */
typedef NS_ENUM(NSUInteger, SORefreshState) {
    /* 空闲，在header和footer中都有效 */
    SORefreshStateIdle,
    /* 下拉，在header中有效 */
    SORefreshStatePulling,
    /* 刷新中，在header和footer中都有效 */
    SORefreshStateRefreshing,
    /* 将要刷新，在header中有效 */
    SORefreshStateWillRefresh,
    /* 没有更多数据，在footer中有效 */
    SORefreshStateNoMoreData,
};

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
@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) SORefreshState state;
/* 是否处于刷新状态 */
- (BOOL)isRefreshing;

/** 刷新控制 */
- (void)beginRefresh;
- (void)endRefresh;

@end

#pragma mark - 下拉刷新界面容器
@interface SORefreshHeaderContainer : SORefreshContainer

@property (strong, nonatomic) UIView<SORefreshHeaderContent> *content;

@end

#pragma mark - 上拉刷新界面容器
@interface SORefreshFooterContainer : SORefreshContainer

@property (strong, nonatomic) UIView <SORefreshFooterContent> *content;

/* 没有更多数据后可通过调用footContainer的这个方法来设置container的状态 */
- (void)setNoMoreData;

@end

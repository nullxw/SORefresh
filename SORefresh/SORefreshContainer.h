//
//  SORefreshContainer.h
//  SORefreshDemo
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContent.h"

typedef NS_ENUM(NSUInteger, SORefreshState) {
    SORefreshStateIdle,
    SORefreshStatePulling,
    SORefreshStateRefreshing,
    SORefreshStateWillRefresh,
    SORefreshStateNoMoreData,
};

typedef void(^SORefreshingBlock)();

@interface SORefreshContainer : UIView

/** 可见的刷新界面 */
@property (strong, nonatomic) UIView<SORefreshContent> *content;
/** 刷新界面的高度 */
@property (assign, nonatomic) CGFloat contentHeight;

/** 需要刷新的界面 */
@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) UIEdgeInsets scrollViewOriginalInset;

/** 刷新回调 */
@property (copy, nonatomic) SORefreshingBlock refreshingBlock;

/** 状态 */
@property (assign, nonatomic) SORefreshState state;

/** 供SORefreshHeaderContainer和SORefreshFooterContainer继承 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;

/** 刷新控制 */
- (void)beginRefresh;
- (void)endRefresh;

@end

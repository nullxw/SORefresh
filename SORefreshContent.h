//
//  SORefreshProtocol.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
    @protocol SORefreshContent
 
    @brief 自定义刷新界面通过实现此协议中的方法来响应不同刷新状态的改变。
 
    @discussion 此协议有两个子协议SORefreshHeaderContent和SORefreshFooterContent分别由下拉界面和上拉界面实现。这个协议中的方法不需要自己去调用，SORefreshScrollObserver会自动调用。
 */
@protocol SORefreshContent <NSObject>

// 设置刷新界面为刷新中的状态
- (void)setBeginRefresh;
// 设置刷新界面为刷新后的状态
- (void)setEndRefresh;
// 指定刷新界面高度
- (CGFloat)contentHeight;

@end

/* 仅下拉刷新界面需要实现的协议 */
@protocol SORefreshHeaderContent <SORefreshContent>

// 设置下拉比例，自定义下拉界面可根据下拉比例控制界面样式或动画进度等。
- (void)setPullPercent:(float)pullPercent;

@end

/* 仅上拉刷新界面需要实现的协议 */
@protocol SORefreshFooterContent <SORefreshContent>

// 设置上拉刷新界面为没有更多数据的状态。
- (void)setNoMoreData;

@end

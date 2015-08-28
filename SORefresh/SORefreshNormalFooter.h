//
//  SORefreshNormalFooter.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContent.h"

#define kSORefreshNormalFooterMessagePull       @"上拉加载更多"
#define kSORefreshNormalFooterMessageNoMoreData @"全部数据加载完毕"
#define kSORefreshNormalFooterMessageLoading    @"加载中"

/*!
    @interface SORefreshNormalFooter
    @brief  SORefresh提供的上拉刷新控件，如果要使用自定义的view作为上拉刷新界面，需要实现SORefreshFooterContent协议，参考本类。
 */
@interface SORefreshNormalFooter : UIView<SORefreshFooterContent>

@end

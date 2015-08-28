//
//  SORefreshNormalHeader.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContent.h"

#define kSORefreshNormalHeaderMessagePull @"下拉即可刷新"
#define kSORefreshNormalHeaderMessageRefreshing @"正在刷新"
#define kSORefreshNormalHeaderMessageWillRefresh @"松开即可刷新"

/*!
    @interface SORefreshNormalHeader
    @brief  SORefresh提供的传统下拉刷新界面，当你要使用自定义的view作为下拉刷新界面时，需要实现SORefreshHeaderContent协议，参考本类的实现。
 */
@interface SORefreshNormalHeader : UIView<SORefreshHeaderContent>

@end

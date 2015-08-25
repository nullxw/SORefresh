//
//  SORefreshNormalHeader.h
//  SORefreshDemo
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SORefreshContent.h"

#define kSORefreshNormalHeaderMessagePull @"下拉即可刷新"
#define kSORefreshNormalHeaderMessageRefreshing @"正在刷新"
#define kSORefreshNormalHeaderMessageWillRefresh @"松开即可刷新"

@interface SORefreshNormalHeader : UIView<SORefreshHeaderContent>

@end

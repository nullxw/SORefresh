//
//  SORefreshScrollObserver.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/26.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    @interface  SORefreshScrollObserver
    @brief      封装SORefresh对集成上下拉刷新的UIScrollView的状态监听逻辑。
 */
@interface SORefreshScrollObserver : NSObject

@property (nonatomic, getter=isHeaderRefreshing) BOOL headerRefreshing;// 控制header的刷新与否
@property (nonatomic, getter=isFooterRefreshing) BOOL footerRefreshing;// 控制footer的刷新与否
@property (nonatomic) BOOL hasMoreData;// 如果没有更多数据需要刷新，可设置此属性为NO；

@end

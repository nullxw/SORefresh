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

+ (instancetype)observerWithScrollView:(UIScrollView *)scrollView;
- (void)stopObserver;

@end

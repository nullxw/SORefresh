//
//  SORefreshProtocol.h
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SORefreshContent <NSObject>

- (void)setBeginRefresh;

- (void)setEndRefresh;

@end

/* 下拉刷新界面需要实现的协议 */
@protocol SORefreshHeaderContent <SORefreshContent>

- (void)setPullPercent:(float)pullPercent;

@end

/* 上拉刷新界面需要实现的协议 */
@protocol SORefreshFooterContent <SORefreshContent>

- (void)setNoMoreData;

@end

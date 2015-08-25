//
//  SORefreshProtocol.h
//  SORefreshDemo
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SORefreshContent <NSObject>

- (void)setBeginRefresh;

- (void)setEndRefresh;

@end

@protocol SORefreshHeaderContent <SORefreshContent>

- (void)setPullPercent:(float)pullPercent;

@end

@protocol SORefreshFooterContent <SORefreshContent>

- (void)setNoMoreData;

@end

//
//  SORefreshFooterContainer.m
//  SORefreshDemo
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshFooterContainer.h"

@implementation SORefreshFooterContainer

@dynamic content;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentHeight = 44.f;
    }
    return self;
}

@end

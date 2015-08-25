//
//  SORefreshHeaderContainer.m
//  SORefreshDemo
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshHeaderContainer.h"
#import "SORefresh.h"

@interface SORefreshHeaderContainer ()

@property (assign, nonatomic) float pullPercent;

@end

@implementation SORefreshHeaderContainer

@dynamic content;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentHeight = 54.f;
    }
    return self;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.state == SORefreshStateRefreshing) {
        return;
    }
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat topInset = self.scrollView.contentInset.top;
    if (offsetY > topInset) {
        self.state = SORefreshStateIdle;
        return;
    }
    self.pullPercent = ((-offsetY - topInset) / self.contentHeight);
}

- (void)setPullPercent:(float)pullPercent
{
    _pullPercent = pullPercent;
    if (pullPercent > 0 && pullPercent < 1 && (self.state == SORefreshStateIdle || self.state == SORefreshStateWillRefresh)) {
        self.state = SORefreshStatePulling;
    } else if (pullPercent > 1 && self.state == SORefreshStatePulling) {
        self.state = SORefreshStateWillRefresh;
    } else if (pullPercent <= 0) {
        self.state = SORefreshStateIdle;
    }
    
    [self.content setPullPercent:pullPercent];
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded && self.state == SORefreshStateWillRefresh) {
        [self beginRefresh];
    }
}

- (void)beginRefresh
{
    [super beginRefresh];
    self.state = SORefreshStateRefreshing;
    [self.content setBeginRefresh];
    [UIView animateWithDuration:SORefreshFastAnimationDuration animations:^{
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top += self.contentHeight;
        self.scrollView.contentInset = contentInset;
    }];
}

- (void)endRefresh
{
    [super endRefresh];
    self.state = SORefreshStateIdle;
    [self.content setEndRefresh];
    [UIView animateWithDuration:SORefreshSlowAnimationDuration animations:^{
        UIEdgeInsets contentInset = self.scrollView.contentInset;
        contentInset.top -= self.contentHeight;
        self.scrollView.contentInset = contentInset;
    }];
}

@end

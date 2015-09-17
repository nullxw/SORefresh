//
//  SORefreshScrollObserver.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/26.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshScrollObserver.h"
#import "UIScrollView+SORefresh.h"
#import "SORefreshConfigure.h"
#import "UIScrollView+SORefreshPrivate.h"

#pragma mark - Const
NSString *const SORefreshContentOffsetKeyPath = @"contentOffset";
NSString *const SORefreshContentSizeKeyPath = @"contentSize";
NSString *const SORefreshStateKeyPath = @"state";

typedef NS_ENUM(NSUInteger, SORefreshScrollState) {
    /* 普通，没露出header和footer */
    SORefreshScrollStateNormal,
    /* 露出部分header */
    SORefreshScrollStateHeaderPull,
    /* 露出全部header */
    SORefreshScrollStateHeaderWillRefresh,
    /* header刷新 */
    SORefreshScrollStateHeaderRefreshing,
    /* footer刷新 */
    SORefreshScrollStateFooterRefreshing
};

@interface SORefreshScrollObserver ()

@property (weak, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) SORefreshScrollState scrollState;
@property (assign, nonatomic) BOOL headerHidden;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation SORefreshScrollObserver

+ (instancetype)observerWithScrollView:(UIScrollView *)scrollView
{
    SORefreshScrollObserver *scrollObserver = [[SORefreshScrollObserver alloc]initWithScrollView:scrollView];
    return scrollObserver;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super init];
    if (self) {
        _hasMoreData = YES;
        _scrollState = SORefreshScrollStateNormal;
        self.scrollView = scrollView;
        [self startObserver];
    }
    return self;
}

- (void)setScrollState:(SORefreshScrollState)scrollState
{
    if (_scrollState == scrollState) {
        return;
    }
    _scrollState = scrollState;
#ifdef DEBUG
    [self logScrollState];
#endif
}

- (void)setHasMoreData:(BOOL)hasMoreData
{
    if (_hasMoreData == hasMoreData) {
        return;
    }
    _hasMoreData = hasMoreData;
    if (hasMoreData) {
        [self.scrollView.footerContainer.content setEndRefresh];
    } else {
        [self.scrollView.footerContainer.content setNoMoreData];
    }
}

#pragma mark - Observer

- (void)startObserver
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:SORefreshContentOffsetKeyPath options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:SORefreshContentSizeKeyPath options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:SORefreshStateKeyPath options:options context:nil];
}

- (void)stopObserveScrollView:(UIScrollView *)scrollView;
{
    if (self.pan) {
        [scrollView removeObserver:self forKeyPath:SORefreshContentOffsetKeyPath];
        [scrollView removeObserver:self forKeyPath:SORefreshContentSizeKeyPath];
        [self.pan removeObserver:self forKeyPath:SORefreshStateKeyPath];
        self.pan = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:SORefreshContentSizeKeyPath]) {
        [self scrollViewContentSizeDidChange:change];
    } else if ([keyPath isEqualToString:SORefreshContentOffsetKeyPath]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:SORefreshStateKeyPath]) {
        [self scrollViewPanStateDidChange:change];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    //  仅与footer有关
    if (!self.scrollView.footerContainer) {
        return;
    }
    //确定是否显示footer
    if (self.scrollView.footerContainer.hidden && self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
        self.scrollView.footerContainer.hidden = NO;
        [self.scrollView.footerContainer setNeedsUpdateConstraints];
    }
    //修正footer的位置
    for (NSLayoutConstraint *constraint in [self.scrollView constraints]) {
        if (constraint.firstItem == self.scrollView.footerContainer && constraint.secondItem == self.scrollView && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondAttribute == NSLayoutAttributeTop) {
            constraint.constant = self.scrollView.contentSize.height;
            break;
        }
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    if (self.scrollState == SORefreshScrollStateHeaderRefreshing || self.scrollState == SORefreshScrollStateFooterRefreshing) {
        return;
    }
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat topInset = self.scrollView.contentInset.top;
    CGFloat scrollViewHeight = self.scrollView.bounds.size.height;
    CGFloat contentHeight = self.scrollView.contentSize.height;
    if (offsetY < -topInset) {
        //  show header
        if (self.scrollView.headerContainer) {
            CGFloat headerReveal = ABS(offsetY) - topInset;
            if (self.scrollState == SORefreshScrollStateHeaderRefreshing) return;
            CGFloat pullPercent = headerReveal / self.scrollView.headerContainer.contentHeight;
            if (pullPercent > 1) {
                self.scrollState = SORefreshScrollStateHeaderWillRefresh;
            } else {
                self.scrollState = SORefreshScrollStateHeaderPull;
            }
            [self.scrollView.headerContainer.content setPullPercent:pullPercent];
        }
    } else if (offsetY + scrollViewHeight > contentHeight) {
        // show footer
        if (self.scrollView.footerContainer) {
            CGFloat footerReveal = offsetY + scrollViewHeight - contentHeight;
            if (footerReveal > self.scrollView.footerContainer.contentHeight) {
                self.footerRefreshing = YES;
            }
        }
    } else {
        self.scrollState = SORefreshScrollStateNormal;
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    //  仅与header有关
    if (!self.scrollView.headerContainer) {
        return;
    }
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded && self.scrollState == SORefreshScrollStateHeaderWillRefresh) {
        self.headerRefreshing = YES;
    }
}

#pragma mark - 刷新控制

- (BOOL)isHeaderRefreshing
{
    return self.scrollState == SORefreshScrollStateHeaderRefreshing;
}

- (BOOL)isFooterRefreshing
{
    return self.scrollState == SORefreshScrollStateFooterRefreshing;
}

- (void)setHeaderRefreshing:(BOOL)headerRefreshing
{
    if (headerRefreshing == self.headerRefreshing) {
        return;
    }
    self.headerHidden = !headerRefreshing;
}

- (void)setFooterRefreshing:(BOOL)footerRefreshing
{
    if (footerRefreshing == self.footerRefreshing) {
        return;
    }
    if (footerRefreshing && self.hasMoreData && self.scrollView.footerContainer.refreshingBlock) {
        self.scrollView.footerContainer.hidden = NO;
        self.scrollState = SORefreshScrollStateFooterRefreshing;
        [self.scrollView.footerContainer.content setBeginRefresh];
        self.scrollView.footerContainer.refreshingBlock();
    }
    if (!footerRefreshing) {
        self.scrollState = SORefreshScrollStateNormal;
        if (self.hasMoreData) {
            [self.scrollView.footerContainer.content setEndRefresh];
            if (self.scrollView.contentSize.height < self.scrollView.bounds.size.height) {
                self.scrollView.footerContainer.hidden = YES;
            }
        } else {
            self.scrollView.footerContainer.hidden = NO;
        }
    }
}

#pragma mark - Show & Hidden

- (void)setHeaderHidden:(BOOL)headerHidden
{
    if (headerHidden) {
        self.scrollState = SORefreshScrollStateNormal;
        [self.scrollView.headerContainer.content setEndRefresh];
        [UIView animateWithDuration:SORefreshSlowAnimationDuration animations:^{
            self.scrollView.SOTopInset -= self.scrollView.headerContainer.contentHeight;
        }];
    } else {
        self.scrollState = SORefreshScrollStateHeaderRefreshing;
        self.hasMoreData = YES;
        [self.scrollView.headerContainer.content setBeginRefresh];
        if (self.scrollView.headerContainer.refreshingBlock) {
            self.scrollView.headerContainer.refreshingBlock();
        }
        [UIView animateWithDuration:SORefreshFastAnimationDuration animations:^{
            self.scrollView.SOTopInset += self.scrollView.headerContainer.contentHeight;
        }];
    }
}

- (void)logScrollState
{
    switch (self.scrollState) {
        case SORefreshScrollStateNormal:
            NSLog(@"state normal");
            break;
        case SORefreshScrollStateHeaderRefreshing:
            NSLog(@"state header refreshing");
            break;
        case SORefreshScrollStateHeaderWillRefresh:
            NSLog(@"state will refresh");
            break;
        case SORefreshScrollStateFooterRefreshing:
            NSLog(@"state footer refreshing");
            break;
        case SORefreshScrollStateHeaderPull:
            NSLog(@"state header pull");
            break;
    }
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"[SORefresh]:Scroll observer dealloc");
#endif
}

@end

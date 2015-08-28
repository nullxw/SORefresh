//
//  SORefreshScrollObserver.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/26.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshScrollObserver.h"
#import "UIScrollView+SORefresh.h"

#pragma mark - Const
NSString *const SORefreshContentOffsetKeyPath = @"contentOffset";
NSString *const SORefreshContentSizeKeyPath = @"contentSize";
NSString *const SORefreshStateKeyPath = @"state";

@interface SORefreshScrollObserver ()

@property (weak, nonatomic) UIScrollView *scrollView;

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
        self.scrollView = scrollView;
        [self startObserver];
    }
    return self;
}

- (void)startObserver
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:SORefreshContentOffsetKeyPath options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:SORefreshContentSizeKeyPath options:options context:nil];
    [self.scrollView.panGestureRecognizer addObserver:self forKeyPath:SORefreshStateKeyPath options:options context:nil];
}

- (void)stopObserver
{
    [self.scrollView removeObserver:self forKeyPath:SORefreshContentOffsetKeyPath];
    [self.scrollView removeObserver:self forKeyPath:SORefreshContentSizeKeyPath];
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:SORefreshStateKeyPath];
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
    
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded && self.scrollView.headerContainer.state == SORefreshStateWillRefresh) {
        [self.scrollView.headerContainer beginRefresh];
    }
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"[SORefresh]:Scroll observer dealloc");
#endif
}

@end

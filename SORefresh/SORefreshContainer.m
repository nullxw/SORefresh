//
//  SORefreshContainer.m
//  SORefreshDemo
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshContainer.h"
#import "SORefresh.h"

#pragma mark - Const
NSString *const SORefreshContentOffsetKeyPath = @"contentOffset";
NSString *const SORefreshContentInsetKeyPath = @"contentInset";
NSString *const SORefreshContentSizeKeyPath = @"contentSize";
NSString *const SORefreshStateKeyPath = @"state";

@implementation SORefreshContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _state = SORefreshStateIdle;
    }
    return self;
}

- (void)setState:(SORefreshState)state
{
    if (_state == state) {
        return;
    }
    _state = state;
    switch (state) {
        case SORefreshStateIdle:
            NSLog(@"SORefreshState:Idle");
            break;
        case SORefreshStateWillRefresh:
            NSLog(@"SORefreshState:WillRefresh");
            break;
        case SORefreshStatePulling:
            NSLog(@"SORefreshState:Pulling");
            break;
        case SORefreshStateRefreshing:
            NSLog(@"SORefreshState:Refreshing");
            break;
        case SORefreshStateNoMoreData:
            NSLog(@"SORefreshState:NoMoreData");
            break;
        default:
            break;
    }
}

- (void)setContent:(UIView<SORefreshContent> *)content
{
    _content = content;
    content.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:content];
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(content)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(content)]];
    [self addConstraints:constraints];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    NSAssert([newSuperview isKindOfClass:[UIScrollView class]], @"SORefresh can only use for UIScrollView or subclass of UIScrollView");
    
    [self removeObserver];
    if (newSuperview) {
        self.scrollView = (UIScrollView *)newSuperview;
        self.scrollView.alwaysBounceVertical = YES;
        self.scrollViewOriginalInset = self.scrollView.contentInset;
        [self addObserver];
    } else if (self.refreshingBlock) {
        self.refreshingBlock = nil;
    }
}

- (void)removeObserver
{
    [self.scrollView removeObserver:self forKeyPath:SORefreshContentOffsetKeyPath];
    [self.scrollView removeObserver:self forKeyPath:SORefreshContentSizeKeyPath];
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:SORefreshStateKeyPath];
}

- (void)addObserver
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:SORefreshContentOffsetKeyPath options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:SORefreshContentSizeKeyPath options:options context:nil];
    [self.scrollView.panGestureRecognizer addObserver:self forKeyPath:SORefreshStateKeyPath options:options context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:SORefreshContentSizeKeyPath]) {
        [self scrollViewContentSizeDidChange:change];
    }
    if ([keyPath isEqualToString:SORefreshContentOffsetKeyPath]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    if ([keyPath isEqualToString:SORefreshStateKeyPath]) {
        [self scrollViewPanStateDidChange:change];
    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {};
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {};
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {};

- (void)beginRefresh
{
    self.state = SORefreshStateRefreshing;
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
}

- (void)endRefresh
{
    self.state = SORefreshStateIdle;
}

@end




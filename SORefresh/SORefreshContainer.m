//
//  SORefreshContainer.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshContainer.h"
#import "SORefresh.h"

@interface SORefreshContainer ()

@property (weak, nonatomic) UIScrollView *scrollView;


/* 验证状态的有效性 */
- (BOOL)validateState:(SORefreshState)state;

@end

@implementation SORefreshContainer

- (BOOL)isRefreshing
{
    return self.state == SORefreshStateRefreshing;
}

- (BOOL)validateState:(SORefreshState)state
{
    return YES;
}

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
    if ([self validateState:state]) {
        _state = state;
    } else {
        NSLog(@"设置了无效的state");
    }
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

- (BOOL)validateState:(SORefreshState)state
{
    return state != SORefreshStateNoMoreData;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
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

@implementation SORefreshFooterContainer

@dynamic content;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentHeight = 44.f;
        self.hidden = YES;
    }
    return self;
}

- (BOOL)validateState:(SORefreshState)state
{
    return state == SORefreshStateIdle || state == SORefreshStateRefreshing;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
{
    if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y - self.scrollView.bounds.size.height > 0) return;
    float pullHeight = -(self.scrollView.contentSize.height - self.scrollView.contentOffset.y - self.scrollView.bounds.size.height);
    if (pullHeight > self.contentHeight && self.state == SORefreshStateIdle) {
        [self beginRefresh];
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
{
    //确定是否显示footer
    if (self.hidden && self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
        self.hidden = NO;
        [self setNeedsUpdateConstraints];
    }
    //修正footer的位置
    for (NSLayoutConstraint *constraint in [self.scrollView constraints]) {
        if (constraint.firstItem == self && constraint.secondItem == self.scrollView && constraint.firstAttribute == NSLayoutAttributeTop && constraint.secondAttribute == NSLayoutAttributeTop) {
            constraint.constant = self.scrollView.contentSize.height;
            break;
        }
    }
}

/** 刷新控制 */
- (void)beginRefresh;
{
    if (self.hidden) {
        return;
    }
    [super beginRefresh];
    [self.content setBeginRefresh];
    self.state = SORefreshStateRefreshing;
    [UIView animateWithDuration:SORefreshFastAnimationDuration animations:^{
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.bottom += self.contentHeight;
        self.scrollView.contentInset = insets;
    }];
}

- (void)endRefresh;
{
    [super endRefresh];
    [self.content setEndRefresh];
    self.state = SORefreshStateIdle;
    [UIView animateWithDuration:SORefreshSlowAnimationDuration animations:^{
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.bottom -= self.contentHeight;
        self.scrollView.contentInset = insets;
    }];
}

- (void)setNoMoreData
{
    self.state = SORefreshStateNoMoreData;
    [self.content setNoMoreData];
}

@end

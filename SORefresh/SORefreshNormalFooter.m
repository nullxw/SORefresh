//
//  SORefreshNormalFooter.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshNormalFooter.h"

@interface SORefreshNormalFooter ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UILabel *tip;

@end

@implementation SORefreshNormalFooter

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _activityIndicatorView = [UIActivityIndicatorView new];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
        
        _tip = [UILabel new];
        _tip.text = kSORefreshNormalFooterMessagePull;
        [self addSubview:_tip];
        
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _tip.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSMutableArray *constraints = [NSMutableArray array];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_tip attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_tip attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_tip attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
    [self addConstraints:constraints];
}

- (void)setBeginRefresh
{
    [self.activityIndicatorView startAnimating];
    self.tip.text = kSORefreshNormalFooterMessageLoading;
}

- (void)setEndRefresh
{
    [self.activityIndicatorView stopAnimating];
    self.tip.text = kSORefreshNormalFooterMessagePull;
}

- (void)setNoMoreData
{
    [self.activityIndicatorView stopAnimating];
    self.tip.text = kSORefreshNormalFooterMessageNoMoreData;
}

@end

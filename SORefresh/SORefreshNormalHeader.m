//
//  SORefreshNormalHeader.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshNormalHeader.h"
#import "SORefresh.h"

@interface SORefreshNormalHeader ()

@property (strong, nonatomic) UIView *labelView;
@property (strong, nonatomic) UILabel *updateTime;
@property (strong, nonatomic) UILabel *tip;
@property (strong, nonatomic) UIImageView *arrowView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation SORefreshNormalHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _labelView = [UIView new];
        _labelView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_labelView];
        
        _updateTime = [UILabel new];
        _updateTime.textAlignment = NSTextAlignmentCenter;
        _updateTime.text = @"最后更新：8.25 22:11";
        [_labelView addSubview:_updateTime];
        
        _tip = [UILabel new];
        _tip.textAlignment = NSTextAlignmentCenter;
        [_labelView addSubview:_tip];
        
        _arrowView = [UIImageView new];
        UIImage *arraw = [UIImage imageNamed:SORefreshSrcName(@"arrow.png")];
        if (!arraw) {
            arraw = [UIImage imageNamed:SORefreshFrameworkSrcName(@"arrow.png")];
        }
        _arrowView.image = arraw;
        [self addSubview:_arrowView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:_activityIndicatorView];
        
        _labelView.translatesAutoresizingMaskIntoConstraints = NO;
        _updateTime.translatesAutoresizingMaskIntoConstraints = NO;
        _tip.translatesAutoresizingMaskIntoConstraints = NO;
        _arrowView.translatesAutoresizingMaskIntoConstraints = NO;
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    //_labelView
    NSMutableArray *labelViewConstraints = [NSMutableArray array];
    [labelViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_tip]-[_updateTime]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tip, _updateTime)]];
    [labelViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tip]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tip)]];
    [labelViewConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_updateTime]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_updateTime)]];
    [_labelView addConstraints:labelViewConstraints];
    //self
    NSMutableArray *selfConstraints = [NSMutableArray array];
    [selfConstraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_arrowView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [selfConstraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_arrowView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [selfConstraints addObject:[NSLayoutConstraint constraintWithItem:_activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [selfConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_activityIndicatorView]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_activityIndicatorView)]];
    [selfConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelView]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_labelView)]];
    [selfConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_arrowView(50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_arrowView)]];
    NSString *hLayout = [NSString stringWithFormat:@"H:[_arrowView(20)]-[_labelView(200)]-%.0f-|", ([UIScreen mainScreen].bounds.size.width - 228) / 2];
    [selfConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:hLayout options:0 metrics:nil views:NSDictionaryOfVariableBindings(_arrowView, _labelView)]];
    [self addConstraints:selfConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setPullPercent:(float)pullPercent
{
    if (pullPercent < 1.0) {
        self.tip.text = kSORefreshNormalHeaderMessagePull;
        self.arrowView.transform = CGAffineTransformMakeRotation(M_PI * pullPercent);
    } else {
        self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
        self.tip.text = kSORefreshNormalHeaderMessageWillRefresh;
    }
}

- (void)setBeginRefresh
{
    [self.activityIndicatorView startAnimating];
    self.arrowView.hidden = YES;
}

- (void)setEndRefresh
{
    [self.activityIndicatorView stopAnimating];
    self.arrowView.hidden = NO;
    self.arrowView.transform = CGAffineTransformIdentity;
}

@end

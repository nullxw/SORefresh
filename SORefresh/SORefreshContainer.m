//
//  SORefreshContainer.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshContainer.h"
#import "SORefreshScrollObserver.h"
#import "UIScrollView+SORefresh.h"
#import "UIScrollView+SORefreshPrivate.h"

@implementation SORefreshContainer

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

- (CGFloat)contentHeight
{
    return [self.content contentHeight];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        [scrollView.scrollObserver stopObserveScrollView:scrollView];
        self.refreshingBlock = nil;
    }
}

@end

@implementation SORefreshHeaderContainer

@dynamic content;

@end

@implementation SORefreshFooterContainer

@dynamic content;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

@end

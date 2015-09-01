//
//  SORefreshContainer.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshContainer.h"

@implementation SORefreshContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
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

@end

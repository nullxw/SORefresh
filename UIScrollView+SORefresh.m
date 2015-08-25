//
//  UIScrollView.m
//  SORefreshDemo
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "UIScrollView+SORefresh.h"

#import "SORefreshHeaderContainer.h"
#import "SORefreshFooterContainer.h"

#import "SORefreshNormalHeader.h"
#import "SORefreshNormalFooter.h"

#import <objc/runtime.h>

@implementation UIScrollView (SORefresh)

static const char SORefreshHeaderKey = 'S';
- (void)setHeaderContainer:(SORefreshHeaderContainer *)headerContainer
{
    if (headerContainer != self.headerContainer) {
        [self.headerContainer removeFromSuperview];
        [self addSubview:headerContainer];
        headerContainer.translatesAutoresizingMaskIntoConstraints = NO;
        NSString *vFormat = [NSString stringWithFormat:@"V:|-(%.0f)-[headerContainer(%.0f)]", -headerContainer.contentHeight, headerContainer.contentHeight];
        NSMutableArray *constraints = [[NSMutableArray alloc]init];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerContainer(==self)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerContainer, self)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerContainer)]];
        [self addConstraints:constraints];
        [self willChangeValueForKey:@"headerContainer"];
        objc_setAssociatedObject(self, &SORefreshHeaderKey, headerContainer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"headerContainer"];
    }
}

- (SORefreshHeaderContainer *)headerContainer
{
    return objc_getAssociatedObject(self, &SORefreshHeaderKey);
}

static const char SORefreshFooterKey = 'O';
- (void)setFooterContainer:(SORefreshFooterContainer *)footerContainer
{
    if (footerContainer != self.footerContainer) {
        [self.footerContainer removeFromSuperview];
        [self addSubview:footerContainer];
        
        [self willChangeValueForKey:@"footerContainer"];
        objc_setAssociatedObject(self, &SORefreshFooterKey, footerContainer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footerContainer"];
    }
}

- (SORefreshFooterContainer *)footerContainer
{
    return objc_getAssociatedObject(self, &SORefreshFooterKey);
}

- (void)addSORefreshNormalHeaderWithRefreshBlock:(SORefreshingBlock)refreshBlock
{
    SORefreshNormalHeader *normalHeader = [SORefreshNormalHeader new];
    [self addHeaderView:normalHeader refreshBlock:refreshBlock];
}

- (void)addSORefreshNormalFooterWithRefreshBlock:(SORefreshingBlock)refreshBlock;
{
    SORefreshNormalFooter *normalFooter = [SORefreshNormalFooter new];
    [self addFooterView:normalFooter refreshBlock:refreshBlock];
}

- (void)addHeaderView:(UIView<SORefreshHeaderContent> *)headerView refreshBlock:(SORefreshingBlock)refreshBlock
{
    SORefreshHeaderContainer *headerContainer = [SORefreshHeaderContainer new];
    headerContainer.content = headerView;
    headerContainer.refreshingBlock = refreshBlock;
    self.headerContainer = headerContainer;
}

- (void)addFooterView:(UIView<SORefreshFooterContent> *)footerView refreshBlock:(SORefreshingBlock)refreshBlock
{
    SORefreshFooterContainer *footerContainer = [SORefreshFooterContainer new];
    footerContainer.content = footerView;
    footerContainer.refreshingBlock = refreshBlock;
    self.footerContainer = footerContainer;
}

@end

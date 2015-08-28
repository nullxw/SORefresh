//
//  UIScrollView.m
//  https://github.com/scfhao/SORefresh
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "UIScrollView+SORefresh.h"

#import "SORefreshScrollObserver.h"

#import "SORefreshNormalHeader.h"
#import "SORefreshNormalFooter.h"

#import <objc/runtime.h>

@interface UIScrollView (SORefreshScrollObserver)

@property (strong, nonatomic) SORefreshScrollObserver *scrollObserver;

@end

@implementation UIScrollView (SORefresh)

#pragma mark - headerContainer
static const char SORefreshHeaderKey = 'H';
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

#pragma mark footerContainer
static const char SORefreshFooterKey = 'F';
- (void)setFooterContainer:(SORefreshFooterContainer *)footerContainer
{
    if (footerContainer != self.footerContainer) {
        [self.footerContainer removeFromSuperview];
        [self addSubview:footerContainer];
        
        footerContainer.translatesAutoresizingMaskIntoConstraints = NO;
        NSString *vFormat = [NSString stringWithFormat:@"V:|-(%.f)-[footerContainer(%.0f)]", self.contentSize.height, footerContainer.contentHeight];
        NSMutableArray *constraints = [[NSMutableArray alloc]init];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[footerContainer(==self)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(footerContainer, self)]];
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:vFormat options:0 metrics:nil views:NSDictionaryOfVariableBindings(footerContainer)]];
        [self addConstraints:constraints];
        
        [self willChangeValueForKey:@"footerContainer"];
        objc_setAssociatedObject(self, &SORefreshFooterKey, footerContainer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footerContainer"];
    }
}

- (SORefreshFooterContainer *)footerContainer
{
    return objc_getAssociatedObject(self, &SORefreshFooterKey);
}

#pragma mark scrollObserver

static const char SORefreshScrollObserverKey = 'O';
- (void)setScrollObserver:(SORefreshScrollObserver *)scrollObserver
{
    if (scrollObserver != self.scrollObserver) {
        [self willChangeValueForKey:@"scrollObserver"];
        objc_setAssociatedObject(self, &SORefreshScrollObserverKey, scrollObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"scrollObserver"];
    }
}

- (SORefreshScrollObserver *)scrollObserver
{
    return objc_getAssociatedObject(self, &SORefreshScrollObserverKey);
}

#pragma mark - Interface

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

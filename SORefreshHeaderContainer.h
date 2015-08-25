//
//  SORefreshHeaderContainer.h
//  SORefreshDemo
//
//  Created by scfhao on 15/8/20.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SORefreshContainer.h"
#import "SORefreshContent.h"

@interface SORefreshHeaderContainer : SORefreshContainer

@property (strong, nonatomic) UIView<SORefreshHeaderContent> *content;

@end

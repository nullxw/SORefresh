//
//  SODemoTableViewController.m
//  SORefreshDemo
//
//  Created by scfhao on 15/8/26.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SODemoTableViewController.h"
#import "SORefresh.h"

@interface SODemoTableViewController ()

@property (assign, nonatomic) NSInteger dataCount;

@end

@implementation SODemoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak typeof(self) ws = self;
    [self.tableView addSORefreshNormalHeaderWithRefreshBlock:^{
        [ws prepareSomeData];
    }];
    [self.tableView addSORefreshNormalFooterWithRefreshBlock:^{
        [ws loadMoreData];
    }];
    self.tableView.scrollObserver.headerRefreshing = YES;
}

- (void)prepareSomeData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataCount = 20;
        self.tableView.scrollObserver.headerRefreshing = NO;
        [self.tableView reloadData];
    });
}

- (void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataCount += 10;
        if (self.dataCount > 40) {
            self.tableView.scrollObserver.hasMoreData = YES;
        }
        self.tableView.scrollObserver.footerRefreshing = NO;
        [self.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"SORefresh,.%zd", indexPath.row];
    return cell;
}

- (void)dealloc
{
    NSLog(@"DemoTableViewController dealloc");
}

@end

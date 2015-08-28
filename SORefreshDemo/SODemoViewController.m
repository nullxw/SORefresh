//
//  SODemoViewController.m
//  SORefreshDemo
//
//  Created by scfhao on 15/8/26.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "SODemoViewController.h"
#import "SORefresh.h"

@interface SODemoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) NSInteger dataCount;

@end

@implementation SODemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView addSORefreshNormalHeaderWithRefreshBlock:^{
        [self prepareSomeData];
    }];
    [self.tableView addSORefreshNormalFooterWithRefreshBlock:^{
        [self loadMoreData];
    }];
    [self.tableView.headerContainer beginRefresh];
}

- (void)prepareSomeData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataCount = 20;
        [self.tableView.headerContainer endRefresh];
        [self.tableView reloadData];
    });
}

- (void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataCount += 10;
        [self.tableView.footerContainer endRefresh];
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
    NSLog(@"DemoViewController dealloc");
}

@end

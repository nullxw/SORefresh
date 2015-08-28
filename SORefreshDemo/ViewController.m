//
//  ViewController.m
//  SORefreshDemo
//
//  Created by scfhao on 15/8/18.
//  Copyright (c) 2015年 scfhao. All rights reserved.
//

#import "ViewController.h"
#import "SORefresh.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger dataCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
        self.dataCount = 14;
        [self.tableView.headerContainer endRefresh];
        [self.tableView reloadData];
    });
}

- (void)loadMoreData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataCount += 10;
        if (self.dataCount > 100) {
            self.tableView.footerContainer.state = SORefreshStateNoMoreData;
        }
        [self.tableView.footerContainer endRefresh];
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dismissNav:(UIStoryboardSegue *)sender
{
    
}

@end

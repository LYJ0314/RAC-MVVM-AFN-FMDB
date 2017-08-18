//
//  ViewController.m
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageViewModel.h"
#import "HomePageCell.h"
#import "CFunctions.h"
#import <MJRefresh/MJRefresh.h>

@interface HomePageViewController ()<UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
// VM
@property (nonatomic, strong) HomePageViewModel *viewModel;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequest];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.viewModel.currentPage = 0;
        [self sendRequest];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.viewModel.currentPage ++;
        [self sendRequest];
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Do any additional setup after loading the view, typically from a nib.
}
// 发起请求
- (void)sendRequest
{
    @weakify(self);
    [self.viewModel.requestSignal subscribeNext:^(NSArray *articles) {
        if ([self.tableView.mj_header isRefreshing] || [self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        @strongify(self);
        // 请求完成后，刷新表格
        [self.tableView reloadData];
    }error:^(NSError *error) {
        // 如果请求失败，则根据error做出相应的提示
        NSString *msg = [[error userInfo] objectForKey:GlobalErrorMessageKey];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
            ;
        }];
    }];
}
#pragma mark - dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [self configCell:cell indexPath:indexPath];
    return cell;
}
- (void)configCell:(HomePageCell *)cell indexPath:(NSIndexPath *)indexPath
{
    // 将数据赋值给cell的VM
    // cell 接收到vm修改后，就会触发初始时设置的信号量
    cell.viewModel = self.viewModel.dataSource[indexPath.row];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataSource.count;
}
#pragma mark delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCellViewModel *vModel = self.viewModel.dataSource[indexPath.row];
   CGFloat f = [HomePageCell caculateCellHeight:vModel.subtitleText withFont:12 withFloat:40];
    return f + 30;
}

#pragma mark 懒加载
- (HomePageViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[HomePageViewModel alloc]init];
    }
    return _viewModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

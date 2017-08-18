//
//  HomePageViewModel.m
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "HomePageViewModel.h"
#import "HomePageCellViewModel.h"
#import "FMDatabaseQueue+Extension.h"
#import "SQL.h"
#import "CFunctions.h"
#import <MJExtension/MJExtension.h>

@interface HomePageViewModel()

@property (nonatomic, strong) NSMutableArray *articleViewModels; ////这个属性主要存储的是文章的VM，上拉加载的时候追加，下拉刷新的时候清空。防止直接修改dataSource
@property (nonatomic, assign)BOOL isRefresh; //是否是刷新（用于处理数据缓存与dataSource）

@end
@implementation HomePageViewModel

#pragma mark - SQLInterface
- (BOOL)saveData
{
    __block BOOL isSuccess = NO;
    // 批量操作，选择事务
    [[FMDatabaseQueue shareInstense] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (HomePageCellViewModel *cellViewModel in self.dataSource) {
            ArticleModel *articleModel = cellViewModel.articleModel;
            
            // 存储
            isSuccess = [db executeUpdate:saveArticleSQL, articleModel.articleID,articleModel.title,articleModel.subtitle];
            // 如果有失败，则停止，跳出循环
            if (!isSuccess) {
                break;
            }
        }
        // 如果遇到失败，则回滚，存储失败
        if (!isSuccess) {
            *rollback = YES;
            return ;
        }
    }];
    return isSuccess;
}
- (BOOL)deleteData
{
    __block BOOL isSuccess = NO;
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:deleteArticleSQL];
    }];
    return isSuccess;
}

- (void)loadData
{
    [[FMDatabaseQueue shareInstense] inDatabase:^(FMDatabase *db) {
        // 读取数据
        FMResultSet *set = [db executeQuery:selectArticleSQL];
        // 循环读取，直到读完
        while ([set next]) {
            ArticleModel *article = [[ArticleModel alloc]init];
            article.title = [set objectForColumnName:@"title"];
            article.articleID = [set objectForColumnName:@"id"];
            article.subtitle = [set objectForColumnName:@"subtitle"];
            HomePageCellViewModel *cellViewModel = [[HomePageCellViewModel alloc]initWithArticleModel:article];
            [self.articleViewModels addObject:cellViewModel];
        }
        // 关闭结果集
        [set close];
    }];
    // 读取完成
    self.dataSource = [self.articleViewModels copy];
}
#pragma mark 懒加载
- (RACSignal *)requestSignal
{
    if (!_requestSignal) {
        @weakify(self);
        _requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            // 配置网络请求参数
            NSDictionary *parameters = @{@"page" : @(self.currentPage)};
            // 发起请求
            NSURLSessionDataTask *task = [self.sessionManager GET:@"http://www.saitjr.com/api_for_test/static_article_list.php" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                // 可封装为请求正确，但是校验未通过处理
                if ([responseObject[@"code"] integerValue] == RequestErrorCode_NoData) {
                    [subscriber sendNext:nil];
                    [subscriber sendError:GlobalError(GlobalErrorType_Request, @"没数据")];
                    return;
                }
                // 将请求下来的字典转模型
                NSArray *articleArr = responseObject[@"data"];
                if (self.currentPage == 0) {
                    [self.articleViewModels removeAllObjects];
                }
                if (self.currentPage != 0) {
                    [self.articleViewModels addObjectsFromArray:[self.articleViewModels copy]];
                }else{
                    for (NSDictionary *articleDictionary in articleArr) {
                        ArticleModel *articleModel = [ArticleModel objectWithKeyValues:articleDictionary];
                        // 根据模型，初始化cell的vm
                        HomePageCellViewModel *cellViewModel = [[HomePageCellViewModel alloc] initWithArticleModel:articleModel];
                        // 将cell 的VM存入数组
                        [self.articleViewModels addObject:cellViewModel];
                    }
                }
                // 完成数据处理后，赋值给dataSource
                self.dataSource = [self.articleViewModels copy];
                // 如果是刷新操作，删除数据库中的数据
                // 这里也可以采用存入部分新数据的方式，全部删除可能在效率方面不是很好
                if (self.isRefresh) {
                    [self deleteData];
                }
                // 存入新数据
                [self saveData];
                [subscriber sendNext:self.dataSource];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                // 如果网络请求错误，加载数据库中的数据
                [self loadData];
                [subscriber sendNext:self.dataSource];
                [subscriber sendError:(GlobalError(GlobalErrorType_Request, @"网络错误"))];
            }];
            // 在信号量作废时，取消网络请求
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }
    return _requestSignal;
}

- (NSMutableArray *)articleViewModels
{
    if (!_articleViewModels) {
        _articleViewModels = [NSMutableArray array];
    }
    return _articleViewModels;
}
- (BOOL)isRefresh
{
    _isRefresh = self.currentPage == 0;
    return _isRefresh;
}

@end

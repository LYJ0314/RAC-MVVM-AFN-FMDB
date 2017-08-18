//
//  HomePageViewModel.h
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "RequestViewModel.h"
#import "ArticleModel.h"
#import "SQLInterface.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

// vc的vm
// 因为需要进行数据缓存，所以遵循SQLInterface
// 因为需要进行网络请求，所以继承自RequestViewModel

@interface HomePageViewModel : RequestViewModel <SQLInterface>

@property (nonatomic, strong) RACSignal *requestSignal; // 网络请求信号

@property (nonatomic, assign)NSInteger currentPage;     // 当前页码
@property (nonatomic, strong) NSArray *dataSource;      // tableview 数据源

@end

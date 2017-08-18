//
//  RequestViewModel.h
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <AFNetworking.h>
#import "BaseViewModel.h"

typedef NS_ENUM(NSInteger, RequestErrorCode) {
    RequestErrorCode_None,
    RequestErrorCode_ParameterError = 1, /// 参数错误
    RequestErrorCode_LoginRequired = 2,  /// 用户未登录
    RequestErrorCode_NoData = 3          /// 暂无数据
};

// 继承自BaseViewModel
// 需要网络请求的VM继承该类
// 该类有一个公共属性sessionManager, 一个该属性的懒加载方法和一个dealloc中取消网络请求的方法
@interface RequestViewModel : BaseViewModel

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

//
//  CFunctions.m
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "CFunctions.h"

NSString const * GlobalErrorMessageKey = @"msg";

NSError* GlobalError(GlobalErrorType errorType, NSString *msg) {
    return [NSError errorWithDomain:@"com.saitjr.demo" code:errorType userInfo:@{GlobalErrorMessageKey : msg}];
}

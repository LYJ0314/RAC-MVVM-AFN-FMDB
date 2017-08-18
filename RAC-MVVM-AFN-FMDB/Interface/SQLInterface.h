//
//  SQLInterface.h
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <Foundation/Foundation.h>

// 数据缓存统一接口，在需要存储数据的类中遵守协议
@protocol SQLInterface <NSObject>

@optional
- (BOOL)saveData;
- (void)loadData;
- (BOOL)deleteData;
- (BOOL)updateData;

@end

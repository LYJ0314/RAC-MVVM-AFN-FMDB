//
//  ArticleModel.h
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleModel : BaseModel

@property (nonatomic, copy) NSNumber *articleID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end

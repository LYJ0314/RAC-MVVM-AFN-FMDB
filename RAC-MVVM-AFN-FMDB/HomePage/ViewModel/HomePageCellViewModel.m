//
//  HomePageCellViewModel.m
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "HomePageCellViewModel.h"

@implementation HomePageCellViewModel

- (instancetype)initWithArticleModel:(ArticleModel *)articleModel
{
    self = [super init];
    if (self) {
        self.articleModel = articleModel;
        [self setupData];
    }
    return self;
}

// 处理Model中的数据
- (void)setupData
{
    _titleText = self.articleModel.title;
    _subtitleText = self.articleModel.subtitle;
    _idText = self.articleModel.articleID.stringValue;
}
@end

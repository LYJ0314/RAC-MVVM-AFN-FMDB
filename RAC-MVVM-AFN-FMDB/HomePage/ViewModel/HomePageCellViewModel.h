//
//  HomePageCellViewModel.h
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "BaseViewModel.h"
#import "ArticleModel.h"

@interface HomePageCellViewModel : BaseViewModel
@property (nonatomic, strong) ArticleModel *articleModel;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *subtitleText;
@property (nonatomic, copy) NSString *idText;

- (instancetype)initWithArticleModel:(ArticleModel *)articleModel;
@end

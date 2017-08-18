//
//  HomePageCell.h
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageCellViewModel.h"

@interface HomePageCell : UITableViewCell

// cell 的VM
@property (nonatomic, strong) HomePageCellViewModel *viewModel;

+ (CGFloat)caculateCellHeight:(NSString *)msg withFont:(CGFloat)font withFloat:(CGFloat)f;

@end

//
//  HomePageCell.m
//  RAC-MVVM-AFN-FMDB
//
//  Created by lyj on 17/8/17.
//  Copyright © 2017年 lyj. All rights reserved.
//

#import "HomePageCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface HomePageCell()
@property (strong, nonatomic) IBOutlet UILabel *textLabel1;
@property (strong, nonatomic) IBOutlet UILabel *detailTextLabel1;


@end

@implementation HomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupSignal];
}

// 设置信号量，将cell 的VM被重新赋值时，更新cell显示的数据
- (void)setupSignal
{
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(HomePageCellViewModel *viewModel) {
        @strongify(self);
        
        // VM 已经将要显示的文本处理好了，在cell中直接赋值就行
        self.textLabel1.text = viewModel.titleText;
        self.detailTextLabel1.text = viewModel.subtitleText;
    }];
}

+ (CGFloat)caculateCellHeight:(NSString *)msg withFont:(CGFloat)font withFloat:(CGFloat)f
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 414 - f, 15)];
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    label.text = msg;
    [label sizeToFit];
    return label.frame.size.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

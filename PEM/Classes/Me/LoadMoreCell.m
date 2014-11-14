//
//  LoadMoreCell.m
//  PEM
//
//  Created by tianj on 14-11-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "LoadMoreCell.h"

@implementation LoadMoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"正在加载...";
        [self.contentView addSubview:label];
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(60,0,40, 40);
        [self.contentView addSubview:_activityView];
        
        _loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadBtn setTitle:@"加载失败,点击重试" forState:UIControlStateNormal];
        _loadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_loadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loadBtn.frame = CGRectMake(0, 0, kWidth, 40);
        [_loadBtn setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_loadBtn];
        _loadBtn.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

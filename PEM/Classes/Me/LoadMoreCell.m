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
        [_activityView startAnimating];
        [self.contentView addSubview:_activityView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

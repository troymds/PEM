//
//  PriImageView.h
//  PEM
//
//  Created by tianj on 14-9-5.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ProImageView.h"

@interface PriImageView : ProImageView
{
    UIView *nomalView;
    UIView *selectedView;
    UILabel *nomalLabel;
    UILabel *selectedLabel;
}

@property (nonatomic,assign) BOOL isSelected;


- (void)setVipName:(NSString *)name;


@end

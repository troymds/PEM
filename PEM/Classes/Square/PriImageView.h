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
    UIImageView *nomalImageView;
    UIImageView *selectedImageView;
}

@property (nonatomic,assign) BOOL isSelected;


- (void)setIconNomalImg:(UIImage *)nomalImg selectedImg:(UIImage *)seletedImg withTitle:(NSString *)title;


@end

//
//  SubTagButton.h
//  PEM
//
//  Created by tianj on 14-9-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ProImageView.h"


@interface SubTagButton : ProImageView
{
    UILabel *numLabel;
    UILabel *textLabel;
    UIView *_bgView;
}

@property (nonatomic,assign) BOOL isDelete;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,strong) UIImageView *delBtn;
@property (nonatomic,assign) BOOL hasMesage;   //判断button 所在的标签是否有信息
@property (nonatomic,copy) NSString *messageNum;


@end

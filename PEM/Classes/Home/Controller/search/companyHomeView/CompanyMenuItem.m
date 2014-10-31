//
//  CompanyMenuItem.m
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanyMenuItem.h"
#define kTitleScale 0.8

@interface CompanyMenuItem()
{
    UIImageView *_devide;
}

@end
@implementation CompanyMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1 设置文字颜色
        [self setTitleColor:HexRGB(0x808080) forState:UIControlStateNormal];
        [self setTitleColor:HexRGB(0x069dd4) forState:UIControlStateSelected];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        //2 设置右边的分割线
        UIImage * img  = [UIImage imageNamed:@"separator_topbar_item"];
        UIImageView *devide = [[UIImageView alloc] initWithImage:img];
//        UIView * devide = [[UIView alloc] init];
        devide.bounds = CGRectMake(0, 2, 2, KCompanyMenuItemH * 0.7);
        devide.center = CGPointMake(KCompanyMenuItemW, KCompanyMenuItemH * 0.5);
        [self addSubview:devide];
        _devide = devide;
        //3 设定选中时的背景
        [self setBackgroundImage:[UIImage imageNamed:@"deleteBtn _selected.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
    if (self.tag == 2) {
         //最后一个按钮没有竖线
        _devide.hidden = YES;
    }
}

- (void)setFrame:(CGRect)frame{
    frame.size = CGSizeMake(KCompanyMenuItemW, KCompanyMenuItemH);
    [super setFrame:frame];
}

- (void)setHighlighted:(BOOL)highlighted{
    
}
//-  (CGRect)titleRectForContentRect:(CGRect)contentRect{
//    CGFloat h = contentRect.size.height;
//    CGFloat w = contentRect.size.width * kTitleScale;
//    return CGRectMake(0, 0, w, h);
//}
//
//- (CGRect)imageRectForContentRect:(CGRect)contentRect{
//    CGFloat h = contentRect.size.height;
//    CGFloat x = contentRect.size.width * kTitleScale;
//    CGFloat w = contentRect.size.width - x;
//    return CGRectMake(x, 0, w, h);
//}

@end

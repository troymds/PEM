//
//  CategoryView.m
//  PEM
//
//  Created by tianj on 14-11-6.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView ()
{
    UIImageView *img;
}
@end

@implementation CategoryView

//- (id)init
//{
//    if (self = [super init]) {
//        img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height)];
//        img.image = [UIImage imageNamed:@"Cell_Selected.png"];
//        img.userInteractionEnabled = YES;
//        img.hidden = YES;
//        [self addSubview:img];
//        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(18,15, 44, 44)];
//        _iconImg.userInteractionEnabled = YES;
//        [self addSubview:_iconImg];
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+44, 18, 100,20)];
//        _titleLabel.textColor = HexRGB(0x3a3a3a);
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_titleLabel];
//        
//        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+44, 51,100,15)];
//        _desLabel.backgroundColor = [UIColor clearColor];
//        _desLabel.textColor = HexRGB(0x808080);
//        [self addSubview:_desLabel];
//    }
//    return self;
//}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height)];
        img.image = [UIImage imageNamed:@"Cell_Selected.png"];
        img.userInteractionEnabled = YES;
        img.hidden = YES;
        [self addSubview:img];
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(18,15, 44, 44)];
        _iconImg.userInteractionEnabled = YES;
        [self addSubview:_iconImg];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+44, 18, 100,20)];
        _titleLabel.textColor = HexRGB(0x3a3a3a);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(30+44, 51,100,15)];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.font  = [UIFont systemFontOfSize:13];
        _desLabel.textColor = HexRGB(0x808080);
        [self addSubview:_desLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (!_isSelected) {
        img.hidden = YES;
    }else{
        img.hidden = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(categoryViewClicked:)]) {
        [self.delegate categoryViewClicked:self];
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.backgroundColor = [UIColor grayColor];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            img.hidden = NO;
         }];
    }];
}


@end

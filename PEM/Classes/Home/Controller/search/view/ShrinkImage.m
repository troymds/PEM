//
//  ShrinkImage.m
//  PEM
//
//  Created by tianj on 14/10/22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "ShrinkImage.h"

@implementation ShrinkImage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [self addGestureRecognizer:tap];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    if (self= [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDown)];
        [self addGestureRecognizer:tap];
    }
    return self;
}


- (void)tapDown
{
    CGPoint center = self.center;
    CGRect frame = self.frame;
    [UIView animateWithDuration:0.01 animations:^{
        self.frame = CGRectMake(0, 0, (self.frame.size.width/4)*3,(self.frame.size.height/4)*3);
        self.center = center;
        [UIView animateWithDuration:0.01 animations:^{
            self.frame = frame;
            if ([self.delegate respondsToSelector:@selector(shinkImageClick:)]) {
                [self.delegate shinkImageClick:self];
            }
        }];
    }];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint center = self.center;
    CGRect frame = self.frame;
    [UIView animateWithDuration:0.01 animations:^{
        self.frame = CGRectMake(0, 0, (self.frame.size.width/4)*3,(self.frame.size.height/4)*3);
        self.center = center;
        [UIView animateWithDuration:0.01 animations:^{
            self.frame = frame;
            if ([self.delegate respondsToSelector:@selector(shinkImageClick:)]) {
                [self.delegate shinkImageClick:self];
            }
        }];
    }];
}



@end

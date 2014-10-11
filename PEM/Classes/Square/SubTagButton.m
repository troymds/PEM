//
//  SubTagButton.m
//  PEM
//
//  Created by tianj on 14-9-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "SubTagButton.h"

@implementation SubTagButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frame.size.width, frame.size.height)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = HexRGB(0x808080);
        textLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:textLabel];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgView.layer.borderWidth = 1.0;
        _bgView.layer.borderColor = HexRGB(0xccd3d8).CGColor;
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled = YES;
        [self addSubview:_bgView];
        
        CGPoint center = CGPointMake(_bgView.frame.size.width,0);
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-10,-4,23,13)];
        numLabel.backgroundColor = HexRGB(0x32add9);
        numLabel.textColor = HexRGB(0xffffff);
        numLabel.layer.borderColor = HexRGB(0x092438).CGColor;
        numLabel.layer.borderWidth = 1.0;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:12];
        numLabel.hidden = YES;
        numLabel.center =center;
        [self addSubview:numLabel];
        
        _delBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,22,22)];
        _delBtn.image = [UIImage imageNamed:@"close_btn.png"];
        _delBtn.hidden = YES;
        _delBtn.center = center;
        [self addSubview:_delBtn];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    textLabel.text = title;
}

- (void)setMessageNum:(NSString *)messageNum{
    _messageNum = messageNum;
    numLabel.text = _messageNum;
}

- (void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
    [self shape];
    if (_isDelete) {
        _bgView.layer.borderColor = HexRGB(0x31add9).CGColor;
        textLabel.textColor = HexRGB(0x31add9);
        if (self.hasMesage){
            numLabel.hidden = YES;
        }
        _delBtn.hidden = NO;
     }else{
         _bgView.layer.borderColor = HexRGB(0xccd3d8).CGColor;
         textLabel.textColor = HexRGB(0x808080);
        _delBtn.hidden = YES;
        if (self.hasMesage){
            numLabel.hidden = NO;
        }else{
            numLabel.hidden= YES;
        }
    }
}

- (void)shape{
    if (_isDelete){
        self.transform = CGAffineTransformMakeRotation(-0.1);
        
        [UIView animateWithDuration:0.12
                              delay:0.0
                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.transform = CGAffineTransformMakeRotation(0.1);
                         } completion:nil];
    }
    else{
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         } completion:nil];
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

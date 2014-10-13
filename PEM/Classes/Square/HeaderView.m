//
//  HeaderView.m
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "HeaderView.h"
#import "AdaptationSize.h"
#import "SystemConfig.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _bgView.userInteractionEnabled = YES;
        [self addSubview:_bgView];
        
        _headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _headerImage.layer.masksToBounds = YES;
        _headerImage.layer.cornerRadius = _headerImage.frame.size.width/2;
        CGPoint p = self.center;
        p.y = _headerImage.frame.size.width/2+15;
        _headerImage.center = p;
        [_bgView addSubview:_headerImage];
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"登录|注册" forState:UIControlStateNormal];
        _registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _registerBtn.tag = 20000;
        _registerBtn.layer.borderWidth = 1.0f;
        [_registerBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        _registerBtn.frame = CGRectMake(self.frame.size.width/2-95/2, _headerImage.frame.origin.y+_headerImage.frame.size.height+10, 95, 27.5);
        [_registerBtn setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_registerBtn];
        
        CGRect rect = CGRectMake(0, _registerBtn.frame.origin.y, 0, 27.5);
        _nameLabel = [[UILabel alloc] initWithFrame:rect];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.hidden = YES;
        [_bgView addSubview:_nameLabel];
        
        _markImg = [[UIImageView alloc] init];
        [self addSubview:_markImg];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-40, frame.size.width, 40)];
        view.backgroundColor = [UIColor clearColor];
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        view1.backgroundColor = [UIColor blackColor];
        view1.alpha = 0.5;
        [view addSubview:view1];
        
        [_bgView addSubview:view];
        NSArray *array = [NSArray arrayWithObjects:@"供应",@"求购",@"收藏",@"消息", nil];
        CGFloat wid = frame.size.width/[array count];
        for (int i = 0; i < [array count]; i++) {
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(wid*i, 20, wid, 16)];
            label2.text = [array objectAtIndex:i];
            label2.textColor = HexRGB(0xffffff);
            label2.backgroundColor = [UIColor clearColor];
            label2.font = [UIFont systemFontOfSize:12];
            label2.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label2];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(wid*i, 0, wid, 40);
            button.backgroundColor = [UIColor clearColor];
            button.tag = 40000+i;
            [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
        }
        _supplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, wid, 16)];
        _supplayLabel.backgroundColor = [UIColor clearColor];
        _supplayLabel.text = @"0";
        _supplayLabel.font = [UIFont systemFontOfSize:13];
        _supplayLabel.textAlignment = NSTextAlignmentCenter;
        _supplayLabel.textColor = HexRGB(0xffffff);
        [view addSubview:_supplayLabel];
        _purchaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(wid ,4, wid, 16)];
        _purchaseLabel.backgroundColor = [UIColor clearColor];
        _purchaseLabel.text = @"0";
        _purchaseLabel.font = [UIFont systemFontOfSize:13];

        _purchaseLabel.textAlignment = NSTextAlignmentCenter;
        _purchaseLabel.textColor = HexRGB(0xffffff);
        [view addSubview:_purchaseLabel];
        _favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(wid*2,4, wid,16)];
        _favoriteLabel.backgroundColor = [UIColor clearColor];
        _favoriteLabel.font = [UIFont systemFontOfSize:13];

        _favoriteLabel.text = @"0";
        _favoriteLabel.textAlignment = NSTextAlignmentCenter;
        _favoriteLabel.textColor = HexRGB(0xffffff);
        [view addSubview:_favoriteLabel];
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(wid*3,4, wid,16)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.text = @"0";
        _messageLabel.font = [UIFont systemFontOfSize:13];

        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = HexRGB(0xffffff);
        [view addSubview:_messageLabel];
        
    }
    return self;
}


- (void)setName:(NSString *)name
{
    if (name.length!=0) {
        _nameLabel.text = name;
        CGSize size = [AdaptationSize getSizeFromString:name Font:[UIFont systemFontOfSize:16] withHight:27.5 withWidth:CGFLOAT_MAX];
        _nameLabel.frame =CGRectMake(kWidth/2-size.width/2,_registerBtn.frame.origin.y,size.width,27.5);
        _markImg.frame = CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+20,_nameLabel.frame.origin.y,19, 25);
        switch ([[SystemConfig sharedInstance].viptype intValue]) {
            case 1:
            {
                _markImg.image = [UIImage imageNamed:@"vip_1_member.png"];
            }
                break;
            case 2:
            {
                _markImg.image = [UIImage imageNamed:@"vip_2_member.png"];

            }
                break;
            case 3:
            {
                _markImg.image = [UIImage imageNamed:@"vip_3_member.png"];

            }
                break;
            case 4:
            {
                _markImg.image = [UIImage imageNamed:@"vip_4_member.png"];

            }
                break;

            default:
                break;
        }
    }
}


- (void)btnClicked:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:btn];
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

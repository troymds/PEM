//
//  VisitorView.m
//  PEM
//
//  Created by tianj on 14-9-5.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "VisitorView.h"

@implementation VisitorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSInteger space = 17;
        NSArray *array = [NSArray arrayWithObjects:@"查看企业供应信息",@"发布企业详细信息",@"免费升级普通会员", nil];
        for (int i = 0; i < [array count]; i++) {
            NSString *text = [array objectAtIndex:i];
            CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 31) lineBreakMode:NSLineBreakByCharWrapping];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 17+(31+space)*i,size.width+20, 31)];
            label.text = text;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = HexRGB(0x666666);
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.borderColor = HexRGB(0xd4d9db).CGColor;
            label.layer.borderWidth = 1.0f;
            [self addSubview:label];
        }
        

    }
    return self;
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

//
//  CustomButton.m
//  PEM
//
//  Created by tianj on 14-11-17.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ref,0.2);
    CGContextSetStrokeColorWithColor(ref,HexRGB(0xcccccc).CGColor);
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref,rect.origin.x,rect.size.height);
    CGContextAddLineToPoint(ref,rect.origin.x,rect.origin.y);
    CGContextStrokePath(ref);
    
    
    CGContextSetLineWidth(ref,1);
    CGContextSetStrokeColorWithColor(ref,HexRGB(0xcccccc).CGColor);
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref,rect.origin.x,rect.origin.y);
    CGContextAddLineToPoint(ref, rect.size.width, rect.origin.y);
    CGContextStrokePath(ref);
    
    CGContextSetLineWidth(ref,0.2);
    CGContextSetStrokeColorWithColor(ref,HexRGB(0xcccccc).CGColor);
    CGContextBeginPath(ref);
    CGContextMoveToPoint(ref, rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(ref, rect.size.width,rect.size.height);
    CGContextStrokePath(ref);
}


@end

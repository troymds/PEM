//
//  ShrinkImage.h
//  PEM
//
//  Created by tianj on 14/10/22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShrinkImage;
@protocol ShrinkImageDelegate <NSObject>

- (void)shinkImageClick:(ShrinkImage *)image;

@end

@interface ShrinkImage : UIImageView
{
    UITapGestureRecognizer *tap;
}

@property (nonatomic,weak) id <ShrinkImageDelegate> delegate;

@end

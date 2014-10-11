//
//  ProImageView.h
//  PEM
//
//  Created by tianj on 14-8-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProImageView;

@protocol ProImageViewDelegate <NSObject>

@optional
- (void)imageClicked:(ProImageView *)image;

@end

@interface ProImageView : UIImageView

@property (nonatomic,weak) id<ProImageViewDelegate> delegate;

@end

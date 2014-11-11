//
//  SecondCateView.h
//  PEM
//
//  Created by tianj on 14-11-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol secondCateViewDelegate <NSObject>

@optional

- (void)secondCateClicked:(NSInteger)count;

@end

@interface SecondCateView : UIView

@property (nonatomic,weak) id <secondCateViewDelegate> delegate;

@end

//
//  ProActionSheet.h
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProActionSheetDelegate <NSObject>

@optional
- (void)buttonClicked:(UIButton *)btn;

@end

@interface ProActionSheet : UIView
{
    UIView *_bgView;
}

@property (nonatomic,weak) id <ProActionSheetDelegate> delegate;

- (void)showView;


@end

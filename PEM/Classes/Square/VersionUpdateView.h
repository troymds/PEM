//
//  VersionUpdateView.h
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol versionViewDelegate <NSObject>

@optional
- (void)versionButtonClicked:(UIButton *)btn;

@end


@interface VersionUpdateView : UIView
{
    UIImageView *bgView;
    UILabel *titleLabel;
    UIButton *delBtn;
    UIButton *cancelBtn;

}

@property (nonatomic,weak) id<versionViewDelegate> delegate;


- (void)showView;

@end

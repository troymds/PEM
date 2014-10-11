//
//  DeleteView.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteViewDelegate <NSObject>

@optional
- (void)buttonClicked:(UIButton *)btn;

@end

@interface DeleteView : UIView
{
    UIImageView *bgView;
    UILabel *titleLabel;
    UIButton *delBtn;
    UIButton *cancelBtn;
}

@property (nonatomic,weak) id<DeleteViewDelegate> delegate;


- (id)initWithTitle:(NSString *)title;

- (void)showView;

@end

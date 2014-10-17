//
//  ProLabel.h
//  PEM
//
//  Created by tianj on 14-10-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProLabel;

@protocol ProLabelDelegate <NSObject>

@optional

- (void)proLabelClick:(ProLabel *)label;

@end

@interface ProLabel : UILabel

@property (nonatomic,weak) id <ProLabelDelegate> delegate;

@end

//
//  CompanyTopMenuView.h
//  PEM
//
//  Created by promo on 14-10-23.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompanyTopMenuView;
@class CompanyMenuItem;

@protocol CompanyTopMenuViewDelegate <NSObject>
@optional
- (void) menu:(CompanyTopMenuView *)menu from:(NSInteger)from to:(NSInteger) to;
- (void) menu:(CompanyTopMenuView *)menu  to:(CompanyMenuItem *)to;
@end
@interface CompanyTopMenuView : UIView
@property (weak, nonatomic) id <CompanyTopMenuViewDelegate> delegate;


@end

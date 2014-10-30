//
//  xiangqingViewController.h
//  PEM
//
//  Created by YY on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReloadDataDelegate.h"
#import "LoginView.h"
#import "MyActionSheetView.h"
@interface xiangqingViewController : UIViewController<UIWebViewDelegate,LoginViewDelegate,MyActionSheetViewDelegate>
{
    float webheight;
    UIWebView *_gyWebView;
    NSString *_wishlist_id;
    
    UIButton *collectBtn;
    UIButton *phonBtn;
    UIView *li;
    
    //标题
    UILabel *nameLable;
    
    
    UIView *_phoneViewName;//拨号蒙版
    UIView *nameView;

}
@property (nonatomic, weak) NSString *supplyIndex;
@property(nonatomic,weak)NSString *company_Id;
@property(nonatomic,strong)NSMutableArray *XQArray;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong)UIImageView *hearImage;
@property(nonatomic,strong)UIView *backWebView;
@property (nonatomic, weak) NSString *supplyWishlistid;
@property(nonatomic,strong)NSMutableArray *wishlistidArray;
@property (nonatomic,weak) id <ReloadDataDelegate> delegate;


@end

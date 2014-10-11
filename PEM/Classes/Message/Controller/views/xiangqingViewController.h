//
//  xiangqingViewController.h
//  PEM
//
//  Created by YY on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xiangqingViewController : UIViewController<UIWebViewDelegate>
{
    float webheight;
    UIWebView *_gyWebView;
    NSString *_wishlist_id;
}
@property (nonatomic, weak) NSString *supplyIndex;
@property(nonatomic,strong)NSMutableArray *XQArray;
@property(nonatomic,strong) UILabel *phoneLabel;
@property(nonatomic,strong)UIImageView *hearImage;
@property(nonatomic,strong)UIView *backWebView;
@property (nonatomic, weak) NSString *supplyWishlistid;
@property(nonatomic,strong)NSMutableArray *wishlistidArray;
@end

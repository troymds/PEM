//
//  MeController.h
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProActionSheet.h"
#import "SupplyView.h"
#import "PurchaseView.h"
#import "SupplyItem.h"
#import "PurchaseItem.h"
#import "LoginView.h"
#import "ProImageView.h"
#import "ChangeControllerDelegate.h"
#import "HotTagsController.h"
#import "SendValueDelegate.h"
#import "CategoryItem.h"
#import "MyActionSheetView.h"




@interface MeController : UIViewController<UITextFieldDelegate,ProActionSheetDelegate,PublishViewDelegate,LoginViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ProImageViewDelegate,UIAlertViewDelegate,SendValueDelegate,MyActionSheetViewDelegate>
{
    UIScrollView *_supplyScrollView;
    BOOL _isPurchase;                        //判断是哪个页面
    ProActionSheet *_actionSheet;
    SupplyView *_supplyView;
    PurchaseView *_purchaseView;
    LoginView *_loginView;
    UIView *sliderLine;
    UIScrollView *_purchaseScrollView;
    MyActionSheetView *_upTDView;
    
    CategoryItem *demandCateItem;        //发布求购分类
    NSString *demandDes;                   //发布求购描述
    NSMutableArray *tagsArray;           //标签数组
    
    
    CategoryItem *supplyCateItem;        //发布供应分类
    NSString *region;                    //发布供应区域
    NSString *supplyDes;                 //发布供应描述
    UIImage *headImage;                   //产品图片
    NSString *imageUrl;                  //图像url
    BOOL isShowTD;

}


@property (nonatomic,weak) id <ChangeControllerDelegate> delegate;

@end

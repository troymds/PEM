//
//  SupplyController.h
//  PEM
//
//  Created by tianj on 14-9-26.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupplyView.h"
#import "ProActionSheet.h"
#import "ProImageView.h"
#import "SupplyItem.h"
#import "CategoryItem.h"
#import "SendValueDelegate.h"
#import "ReloadDataDelegate.h"
#import "MyActionSheetView.h"

@interface SupplyController : UIViewController<PublishViewDelegate,ProActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ProImageViewDelegate,SendValueDelegate,UIAlertViewDelegate,ReloadDataDelegate,MyActionSheetViewDelegate>
{
    UIScrollView *_scrollView;
    SupplyView *_supplyView;
    
    CategoryItem *supplyCateItem;        //发布供应分类
    NSString *region;                    //发布供应区域
    NSString *supplyDes;                 //发布供应描述
    UIImage *headImage;                   //产品图片
    NSString *imageUrl;                  //图像url
    BOOL isShowTD;
    
    BOOL isOrigionImg;                   //判读是否是原始图片
    
    CGPoint _offset;
    
}

@property (nonatomic,copy) NSString *info_id;
@property (nonatomic,weak) id<ReloadDataDelegate> delegate;
@property (nonatomic,assign) BOOL isAdd;

@end

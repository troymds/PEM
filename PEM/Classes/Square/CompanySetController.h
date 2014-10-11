//
//  CompanySetController.h
//  PEM
//
//  Created by tianj on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProImageView.h"
#import "SetAreaView.h"
#import "ProvinceController.h"
#import "CityController.h"


@class SetCellView;

@interface CompanySetController : UIViewController<ProImageViewDelegate,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ProvinceDelegate,CityDelegate>
{
    UIScrollView *_scrollView;
    ProImageView *_iconSetView;
    SetCellView *_areaView;
    SetCellView *_emailView;
    SetCellView *_websiteView;
    SetCellView *_phoneView;
    SetCellView *_nameView;
    SetAreaView *_provinceView;
    SetAreaView *_cityView;
    UIView *_bgView;
    NSString *_imgStr;       //图片url
    
    NSString  *_provinceId;    //所选省份的id
    NSString *_cityId;  //所选城市的id
    NSString *provinceName;   //省份名称
    NSString *cityName;
    
    CGPoint _offset;              //scrollview的偏移量
    
    BOOL isModifyImg;            //判断是否修改了图片 没有修改则不用再次上传
    BOOL isExistImg;           //判断企业设置中头像是否存在 使用默认头像则表示不存在
}

@property (nonatomic,strong) ProImageView *iconImage;
@property (nonatomic,copy) NSString *pushType;


@end

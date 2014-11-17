//
//  HomeController.h
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KDCycleBannerView.h"
@interface HomeController : UIViewController<KDCycleBannerViewDataource,KDCycleBannerViewDelegate>
{
    NSTimer *_timer;
    NSArray *imageArray;
    int currentPage;
    Boolean catClickFlage;
    
    KDCycleBannerView * _bannerView; // 轮播

}


@property(nonatomic,strong)NSMutableArray *hotImageArray;
@property(nonatomic,strong)NSMutableArray *tadyNumArray;//今日新增
@property(nonatomic,strong)NSMutableArray *hotDemandArray;//热门求购
@property(nonatomic,strong)NSMutableArray *hotSupplyArray;//热门供应

@property(nonatomic ,strong)NSDictionary *activetArray;//专题活动




@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property(nonatomic,strong)NSMutableArray *adsImage;

//离线数据
@property(nonatomic,strong)NSMutableArray *hotImageArrayOff;
@property(nonatomic,strong)NSMutableArray *tadyNumArrayOff;//今日新增
@property(nonatomic,strong)NSMutableArray *hotDemandArrayOff;//热门求购
@property(nonatomic,strong)NSMutableArray *hotSupplyArrayOff;//热门供应
@property(nonatomic,strong)NSMutableArray *adsImageOff;

@end

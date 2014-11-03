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


@property (strong,nonatomic)UIScrollView *scrollView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (strong, nonatomic)UITextField *text;
@property(nonatomic,strong)NSMutableArray *adsImage;
@end

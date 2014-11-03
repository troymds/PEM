//
//  HomeController.m
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "HomeController.h"
#import "UIBarButtonItem+MJ.h"
#import "AFNetworking.h"
#import "SearchController.h"
#import "xiangqingViewController.h"
#import "qiugouXQ.h"
#import "StatusTool.h"
#import "Status.h"
#import "HotCategoryModel.h"
#import "TodayNumModel.h"
#import "HotSupplyModel.h"
#import "HotDemandModel.h"
#import "adsModel.h"
#import "findViewController.h"
#import "UIImageView+WebCache.h"
#import "labelColor.h"
#import "supplyTool.h"
#import "CompanyXQViewController.h"
#import "MessageController.h"
#import "bannerWebView.h"
#import "SDWebImageManager.h"
#import "ZBarSDK.h"
#import "DimensionalCodeViewController.h"
#import "RemindView.h"
@interface HomeController ()<UIScrollViewDelegate,SDWebImageManagerDelegate,ZBarReaderDelegate>
{
    UIScrollView *_backScrollView;
    UIImageView *_smallImgView;
    BOOL stop;
    
    NSMutableArray *_hotImageArray;//热门分类  七个图片）
    NSMutableArray *_tadyNumArray;//今日新增
    NSMutableArray *_hotDemandArray;//热门求购
    NSMutableArray *_hotSupplyArray;//热门供应
    
    
    int currentTag;
    
    NSString *curStr;
    ZBarReaderViewController *_reader;
}
@property (nonatomic, strong)NSString * zbarUl;
@end

@implementation HomeController
@synthesize scrollView, slideImages;
@synthesize text;
@synthesize pageControl;
@synthesize adsImage;
@synthesize hotImageArray = _hotImageArray;
@synthesize tadyNumArray=_tadyNumArray;
@synthesize hotDemandArray=_hotDemandArray;
@synthesize hotSupplyArray=_hotSupplyArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    catClickFlage = true;
    self.view.backgroundColor =HexRGB(0xe9f0f5);
    
    UIButton * _searchImage =[UIButton buttonWithType:UIButtonTypeCustom];
    _searchImage.frame =CGRectMake(0, 0, 180, 30);
    [self.view addSubview:_searchImage];
    self.navigationItem.titleView =_searchImage;
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateNormal];
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateHighlighted];


    [_searchImage addTarget:self action:@selector(searchBarBtn) forControlEvents:UIControlEventTouchUpInside];
    
        
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(zbarSdk:)];
      self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_logo.png" highlightedSearch:@"nav_logo.png" target:(self) action:@selector(lo)];
    self.view.userInteractionEnabled = YES;
    
    
    
    // 初始化 数组 并添加四张图片
    slideImages = [[NSMutableArray alloc] init];
    adsImage = [[NSMutableArray alloc] init];
    
    self.hotImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.tadyNumArray =[[NSMutableArray alloc]initWithCapacity:0];
    self.hotDemandArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    self.hotSupplyArray =[[NSMutableArray alloc]initWithCapacity:0];
    [self addBackScrollView];//    背景
    [self loadNewData];
    
    currentTag = 0;
    
    
    
    
    
}
-(void)lo{
    
}
-(void)zbarSdk:(UIButton *)sdk{
    _reader = [ZBarReaderViewController new];
    _reader.readerDelegate = self;
    _reader.showsHelpOnFail = NO;
    
    ZBarImageScanner * scanner = _reader.scanner;
    
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    [self presentViewController:_reader animated:YES completion:^{
        
    }];
    
}

#pragma mark - zbar reader delegate
- (void) imagePickerController: (UIImagePickerController*) readerv
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    //    [self performSelectorOnMainThread:@selector(dismissPicker) withObject:nil waitUntilDone:YES];
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    self.zbarUl = symbol.data;
    
    [readerv dismissViewControllerAnimated:YES completion:^{
        DimensionalCodeViewController *DimensionalCodeViewCon = [[DimensionalCodeViewController alloc]init];
        DimensionalCodeViewCon.url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.zbarUl]];
        self.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:DimensionalCodeViewCon animated:YES];
    }];
}

#pragma mark 加载微博数据
- (void)loadNewData
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    // 获取数据
    [StatusTool statusesWithSuccess:^(NSArray *statues) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        Status *statusModel = [statues objectAtIndex:0];
        
        for (NSDictionary *dict in statusModel.hotCategoryArray)
        {
            HotCategoryModel *hotModel = [[HotCategoryModel alloc] initWithDictionaryForHotCate:dict];
            
            [_hotImageArray addObject:hotModel];

        }
        TodayNumModel *todayModel = [[TodayNumModel alloc] initWithTodayNumDictionary:statusModel.todayNumDictionary];
        [_tadyNumArray addObject:todayModel];
        if ([statusModel.hotSupplyArray isKindOfClass:[NSNull class]]){
            
        }else{
            for (NSDictionary *supplyDic in statusModel.hotSupplyArray) {
                
                HotSupplyModel *supplyArr =[[HotSupplyModel alloc]initWithDictionaryForHotSupply:supplyDic];
                [_hotSupplyArray addObject:supplyArr];
            }
            for (NSDictionary *demandDic in statusModel.hotDemandArray) {
                HotDemandModel *demand =[[HotDemandModel alloc]initWithDictionaryForHotDeman:demandDic];
                [_hotDemandArray addObject:demand];
            }
            for (NSDictionary *dict in statusModel.adsArray)
            {
                adsModel *ads =[[adsModel alloc]initWithDictionaryForAds:dict];
                [adsImage addObject:ads];
            }
            [self addADSimageBtn:adsImage];
            [self initBannerView];
            
            [self addCategorybutton:_hotImageArray];
            [self addtitleTodyBtn:_tadyNumArray];
            [self addHot:_hotDemandArray hotSupply:_hotSupplyArray ];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];


    }];

    
}
#pragma mark - 轮播

-(void)addADSimageBtn:(NSMutableArray *)tody
{
    
    
    // 创建图片 imageview
    for (int i = 0;i<[tody count];i++)
    {
        adsModel *ads =[tody objectAtIndex:i];
        [slideImages addObject:ads.srcImage];
        
    }
}
-(void)initBannerView{
    _bannerView =[[KDCycleBannerView alloc] initWithFrame:CGRectMake(0, 0,kWidth,118)];
    
    _bannerView.datasource = self;
    _bannerView.delegate = self;
    _bannerView.continuous = YES;
    _bannerView.autoPlayTimeInterval = 3;
    [_backScrollView addSubview:_bannerView];
}
- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView{
    
    
    return slideImages;
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index{
    return UIViewContentModeScaleAspectFill;
}
- (UIImage *)placeHolderImageOfBannerView:(KDCycleBannerView *)bannerView atIndex:(NSUInteger)index{
    return placeHoderImage;
}
// 滚动到第几个图片
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index{
    
}
// 选中第几个图片
- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index{
    adsModel *model = adsImage[index];
    if ([model.idType isEqualToString:@"1"]) {
        xiangqingViewController *xiq =[[xiangqingViewController alloc]init];
        xiq.supplyIndex = model.content;
        [self.navigationController pushViewController:xiq animated:YES];
        
    }else if([model.idType isEqualToString:@"2"]){
        qiugouXQ *detailVC = [[qiugouXQ alloc] init];
        detailVC.demandIndex = model.content;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if([model.idType isEqualToString:@"3"]){
        CompanyXQViewController *comXQ   =[[CompanyXQViewController alloc]init];
        
        comXQ.companyID=model.content;
        [self.navigationController pushViewController:comXQ animated:YES];
    }
    else{
        
        bannerWebView *bannerView =[[bannerWebView alloc]init];
        //bannerView.currentTag = img.view.tag-230-1;
        bannerView.bannerWebid =model.content;
        [self.navigationController pushViewController:bannerView animated:YES];
        
    }
    
}

#pragma mark - create bigBackScrollView

-(void)addBackScrollView
{
    _backScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.view.frame.size.height-44)];
    _backScrollView.contentSize = CGSizeMake(kWidth,960);
    _backScrollView.userInteractionEnabled=YES;
    _backScrollView.bounces = NO;
    _backScrollView.backgroundColor =HexRGB(0xffffff);
    [self.view addSubview:_backScrollView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 118)];
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = HexRGB(0xffffff);
    
    [_backScrollView addSubview:scrollView];
    
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.showsHorizontalScrollIndicator = NO;
    
    for (int l=0; l<7; l++) {
        UIView *lin =[[UIView alloc]init];
        lin.backgroundColor =HexRGB(0xe6e3e4);
        [_backScrollView addSubview:lin];
        if (l==0) {
            lin.frame = CGRectMake(10, 144+l%3, 300, 1);
        }
        if (l==1) {
            lin.frame = CGRectMake(10, 310+l%3, 300, 1);
        }
        if (l==2) {
            lin.frame = CGRectMake(10, 336+l%3, 300, 1);
        }
        if (l==3) {
            lin.frame = CGRectMake(10, 530+l%3, 300, 1);
        }
        if (l==4) {
            lin.frame = CGRectMake(10, 600+l%3, 300, 1);
        }
        if (l==5) {
            lin.frame = CGRectMake(10, 628+l%3, 300, 1);
            
        }
        if (l==6) {
            lin.frame = CGRectMake(10, 823+l%3, 300, 1);
        }
    }
}



//三个标题
-(void)addtitleTodyBtn:(NSMutableArray *)tody
{
    
    for (int t=0; t<3; t++) {
        UIImageView *hotTitle =[[UIImageView alloc]initWithFrame:CGRectMake(18, 122+t%3*(15+180), 70, 17)];
        hotTitle.image =[UIImage imageNamed:[NSString stringWithFormat:@"title%d",t+1]];
        [_backScrollView addSubview:hotTitle];
        if (t==2) {
            hotTitle.frame = CGRectMake(10, 260+t%3*(20+154), 80, 17);
        }
        
    }
    TodayNumModel *todayNum =[tody objectAtIndex:0];
    
    int init_x = 100;
    int init_y = 116;
    int viewWidth_f = 210;
    
    NSMutableArray* setArray_f = [[NSMutableArray alloc] initWithCapacity:5];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x666666),@"Color",[UIFont systemFontOfSize:PxFont(14)],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x069ddd),@"Color",[UIFont systemFontOfSize:PxFont(18)],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x666666),@"Color",[UIFont systemFontOfSize:PxFont(14)],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x069ddd),@"Color",[UIFont systemFontOfSize:PxFont(18)],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x666666),@"Color",[UIFont systemFontOfSize:PxFont(14)],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x069ddd),@"Color",[UIFont systemFontOfSize:PxFont(18)],@"Font",nil]];
    [setArray_f addObject:[NSDictionary dictionaryWithObjectsAndKeys:HexRGB(0x666666),@"Color",[UIFont systemFontOfSize:PxFont(14)],@"Font",nil]];
    
    
    labelColor* showLable = [[labelColor alloc] initWithFrame:CGRectMake(init_x,init_y,viewWidth_f,30)];
    showLable.alignmentType = Muti_Alignment_Left_Type;
    [showLable setShowText:[NSString stringWithFormat:@"求购|%@|条   供应商|%@|家   询价|%@|次",todayNum.demandNum,todayNum.supplyNum,todayNum.callNum] Setting:setArray_f];
    [_backScrollView addSubview:showLable];
    
    
}




#pragma mark 添七个按钮
-(void)addCategorybutton:(NSMutableArray *)btnImgArray
{
    for (int c=0; c<7; c++)
    {
        
        HotCategoryModel *hotCategoryModel = [btnImgArray objectAtIndex:c];

        
        UIButton *categoryButtTitle =[UIButton buttonWithType:UIButtonTypeCustom];
        
        categoryButtTitle.frame =CGRectMake(14+c%4*(50+25), 200+c/4*(40+40), 65, 30);
        [_backScrollView addSubview:categoryButtTitle];
        [categoryButtTitle setTitle:hotCategoryModel.name forState:UIControlStateNormal];
        [categoryButtTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        categoryButtTitle.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
        [categoryButtTitle setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
        

        
        UIImageView *findImage =[[UIImageView alloc]init];
        findImage.frame =CGRectMake(20+c%4*(50+25), 152+c/4*(40+40), 50,50);
        
        
        [_backScrollView addSubview:findImage];
        
        UIButton *CategoryButt =[UIButton buttonWithType:UIButtonTypeCustom];
        CategoryButt.frame =CGRectMake(20+c%4*(50+25), 152+c/4*(40+40), 50,70);
        [CategoryButt setTitle:hotCategoryModel.name forState:UIControlStateNormal  ];
        [CategoryButt setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_backScrollView addSubview:CategoryButt];
        
        CategoryButt.tag=[hotCategoryModel.cateid intValue]+100;
        
        findImage.tag = CategoryButt.tag+10000;
        categoryButtTitle.tag =findImage.tag ;

        findImage.userInteractionEnabled = NO;
        [findImage setImageWithURL:[NSURL URLWithString:hotCategoryModel.image]  placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
        
        [CategoryButt addTarget:self action:@selector(categoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];


        
       
    }
    
    UIButton *moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame =CGRectMake(245, 232, 50, 50);
    [_backScrollView addSubview:moreBtn];
   
    [moreBtn setImage:[UIImage imageNamed:@"more_btn.png"] forState:UIControlStateNormal];
    
    UIButton *moreTitle =[UIButton buttonWithType:UIButtonTypeCustom];
    moreTitle.frame =CGRectMake(246, 280, 50, 30);
    [_backScrollView addSubview:moreTitle];
    [moreTitle setTitle:@"更多" forState:UIControlStateNormal];
    [moreTitle setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    moreTitle.titleLabel.font =[UIFont systemFontOfSize:PxFont(20)];
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [moreTitle addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.tag = 88;

    moreTitle.tag = moreBtn.tag;

    
}
-(void)moreBtnClick:(UIButton *)more{
    
    if (!catClickFlage) {
        return ;
    }
    catClickFlage = false;
    for (UIView *view in [_backScrollView subviews])
    {
        if (view.tag == 88)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            
            view.transform = CGAffineTransformScale([self transformForOrientation], 0.8, 0.8);;
            
            [UIView commitAnimations];
            
        }
    }
    [self performSelector:@selector(changeUITwo) withObject:nil afterDelay:0.3];

   }

-(void)changeUITwo{
    for (UIView *view in [_backScrollView subviews])
    {
        if (view.tag == 88)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            
            view.transform = CGAffineTransformScale([self transformForOrientation], 1.0, 1.0);
            
            [UIView commitAnimations];
        }
    }
    
    
    [self performSelector:@selector(goNextVCTwo) withObject:nil afterDelay:0.3];

}
-(void)goNextVCTwo{
    MessageController *message =[[MessageController alloc]init];
    
   
    [self.navigationController pushViewController:message animated:YES];
    catClickFlage = true;
    
}
#pragma mark 添加三条广告
-(void)addHot:(NSMutableArray *)hotDemand hotSupply:(NSMutableArray *)supply
{
    for (int s=0; s<3; s++) {
        //广告图片 热门求购
        HotSupplyModel *supplyArr =[supply objectAtIndex:s];
        
        //    供应
        
        UIImageView *sadImage =[[UIImageView alloc]init];
        [_backScrollView addSubview:sadImage];
        
        UIButton *suBigBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_backScrollView addSubview:suBigBtn];
        [suBigBtn addTarget:self action:@selector(supplyBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        suBigBtn.tag =300+s;
        
        sadImage.userInteractionEnabled = YES;
        sadImage.frame =CGRectMake(225, 393+s%3*(10+61), 85, 61);
        suBigBtn.frame =CGRectMake(0, 394+s%3*(10+61), kWidth, 61);
        
        if (s ==0)
        {
            sadImage.frame =CGRectMake(10, 339+s%3*(5), 300, 118);
            suBigBtn.frame=CGRectMake(0, 0, 300, 118);
            [sadImage addSubview:suBigBtn];
            
            [sadImage setImageWithURL:[NSURL URLWithString:supplyArr.image] placeholderImage:[UIImage imageNamed:@"load_big.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
        }
        [sadImage setImageWithURL:[NSURL URLWithString:supplyArr.image] placeholderImage:[UIImage imageNamed:@"load_big.png"] options:(SDWebImageLowPriority||SDWebImageRetryFailed)];
        
        
        //中标题
        UILabel *TitleLabel=[[UILabel alloc]init ];
        TitleLabel.backgroundColor =[UIColor clearColor];
        TitleLabel.text =supplyArr.title;
        TitleLabel.frame =CGRectMake(20, 458+s%3*(10+61), 250, 40);
        [_backScrollView addSubview:TitleLabel];
        if (s==2)
        {
            TitleLabel.frame =CGRectMake(0, 0, 0, 0);
        }
        TitleLabel.backgroundColor =[UIColor clearColor];
        TitleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        TitleLabel.textColor=HexRGB(0x3a3a3a);
        //小标题
        UILabel *SubTitle =[[UILabel alloc]initWithFrame:CGRectMake(20, 492+s%3*(10+61), 250, 30)];
        SubTitle.backgroundColor =[UIColor clearColor];
        if (s==2) {
            SubTitle.frame =CGRectMake(0, 0, 0, 0);
        }
        [_backScrollView addSubview:SubTitle];
        SubTitle.text = supplyArr.sub_title;
        SubTitle.font =[UIFont systemFontOfSize:PxFont(18)];
        SubTitle.textColor=HexRGB(0x666666);
        
        
        
    }
    
    for (int d=0; d<3; d++) {
        //广告图片 热门求购
        HotDemandModel *demandArr =[hotDemand objectAtIndex:d];
        
        UIImageView *adImage =[[UIImageView alloc]init];
        [_backScrollView addSubview:adImage];
        adImage.userInteractionEnabled = YES;
        UIButton *deBigBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        deBigBtn.frame =CGRectMake(0, 690+d%3*(10+61), kWidth, 61);
        [_backScrollView addSubview:deBigBtn];
        [deBigBtn addTarget:self action:@selector(demandBtn:) forControlEvents:UIControlEventTouchUpInside];
        deBigBtn.tag = 200+d;
        adImage.frame =CGRectMake(225, 687+d%3*(10+61), 85, 61);
        if (d ==0) {
            adImage.frame =CGRectMake(10, 631+d%3*(10+61), 300, 118);
            deBigBtn.frame =CGRectMake(0, 0, 300, 118);
            [adImage addSubview:deBigBtn];
        }
        [adImage setImageWithURL:[NSURL URLWithString:demandArr.image] placeholderImage:[UIImage imageNamed:@"load_big.png"]];
        
        
        
        //中标题
        UILabel *dTitleLabel=[[UILabel alloc]init ];
        dTitleLabel.backgroundColor =[UIColor clearColor];
        dTitleLabel.text =demandArr.title;
        dTitleLabel.frame =CGRectMake(20, 760+d%3*(10+61), 250, 40);
        dTitleLabel.font =[UIFont systemFontOfSize:PxFont(22)];
        dTitleLabel.textColor=HexRGB(0x3a3a3a);
        
        [_backScrollView addSubview:dTitleLabel];
        if (d==2) {
            dTitleLabel.frame =CGRectMake(0, 0, 0, 0);
        }
        dTitleLabel.backgroundColor =[UIColor clearColor];
        //小标题
        UILabel *SubTitle =[[UILabel alloc]initWithFrame:CGRectMake(20, 790+d%3*(10+61), 250, 30)];
        SubTitle.backgroundColor =[UIColor clearColor];
        if (d==2) {
            SubTitle.frame =CGRectMake(0, 0, 0, 0);
        }
        [_backScrollView addSubview:SubTitle];
        SubTitle.text = demandArr.sub_title;
        SubTitle.font =[UIFont systemFontOfSize:PxFont(18)];
        SubTitle.textColor=HexRGB(0x666666);
        
        
    }
    
    
}


//供应
-(void)supplyBtn:(UIButton *)supply
{
    
    xiangqingViewController *xiangq =[[xiangqingViewController alloc]init];
    HotSupplyModel *model =[_hotSupplyArray objectAtIndex:supply.tag-300];
    xiangq.supplyIndex= model.supplyhotID ;
    [self.navigationController pushViewController:xiangq animated:YES];
}
//求购
-(void)demandBtn:(UIButton *)deman{
    
    qiugouXQ *qiug =[[qiugouXQ alloc]init];
    HotDemandModel *model =[_hotDemandArray objectAtIndex:deman.tag-200];
    qiug.demandIndex =model.demandHotid;
    [self.navigationController pushViewController:qiug animated:YES];
    
}

//八宫格
-(void)categoryBtnClick:(UIButton *)cate
{
    if (!catClickFlage) {
        return ;
    }
    catClickFlage = false;
    currentTag =(int) cate.tag+10000;
    
    curStr = cate.titleLabel.text;
    
    for (UIView *view in [_backScrollView subviews])
    {
        if (view.tag == currentTag)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            
            view.transform = CGAffineTransformScale([self transformForOrientation], 0.8, 0.8);;

            [UIView commitAnimations];
        }
    }
    [self performSelector:@selector(changeUI) withObject:nil afterDelay:0.3];

}
- (CGAffineTransform)transformForOrientation
{
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (UIInterfaceOrientationLandscapeLeft == orientation)
    {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (UIInterfaceOrientationLandscapeRight == orientation)
    {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (UIInterfaceOrientationPortraitUpsideDown == orientation)
    {
		return CGAffineTransformMakeRotation(-M_PI);
	} else
    {
		return CGAffineTransformIdentity;
	}
}


- (void)changeUI
{
    for (UIView *view in [_backScrollView subviews])
    {
        if (view.tag == currentTag)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationDelegate:self];
            
            view.transform = CGAffineTransformScale([self transformForOrientation], 1.0, 1.0);

            [UIView commitAnimations];
        }
    }
    
    
    [self performSelector:@selector(goNextVC2) withObject:nil afterDelay:0.3];
    
}

- (void)goNextVC2
{
    findViewController *find =[[findViewController alloc]init];
    find.titleLabel = curStr;
    
    NSString *strId =[NSString stringWithFormat:@"%d",currentTag-100-10000];
    find.cateIndex = strId;
    [self.navigationController pushViewController:find animated:YES];
    catClickFlage = true;

}

-(void)searchBarBtn{
    
    SearchController *gongy =[[SearchController alloc]init];
    [self.navigationController pushViewController:gongy animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

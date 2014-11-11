//
//  MessageController.m
//  PEM
//
//  Created by YY on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MessageController.h"
#import "UIBarButtonItem+MJ.h"
#import "HomeController.h"
#import "findViewController.h"
#import "SearchController.h"
#import "gategoryListTool.h"
#import "gategoryModel.h"
#import "MainController.h"
#import "UIImageView+WebCache.h"
#import "RemindView.h"
#import "ZBarSDK.h"
//#import "CompanyDetailViewController.h"
#import "DimensionalCodeViewController.h"
#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"message.data"]

@interface MessageController ()<ZBarReaderDelegate>
{
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArray;
    ZBarReaderViewController *_reader;
}

@property (nonatomic, retain) NSMutableArray *menuArray;
@property (nonatomic,copy)NSString *menuUrlString;
@property (nonatomic, strong)NSString * zbarUl;
@property (nonatomic, strong)NSMutableArray *offLineDataArray;
@end

@implementation MessageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor =HexRGB(0xe9f0f5);
    catClickFlage = true;
    _categoryArray = [[NSMutableArray alloc]init];
    _offLineDataArray = [NSMutableArray array];
    
    UIButton * _searchImage =[UIButton buttonWithType:UIButtonTypeCustom];
    _searchImage.frame =CGRectMake(0, 0, 180, 30);
    [self.view addSubview:_searchImage];
    self.navigationItem.titleView =_searchImage;
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateNormal];
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateHighlighted];

    [_searchImage addTarget:self action:@selector(searchBarBtn) forControlEvents:UIControlEventTouchUpInside];
    
    currentTag =0;
    
    
   
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(zbarSdk:)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_logo.png" highlightedSearch:@"nav_logo.png" target:(self) action:@selector(logoImage)];
    self.view.userInteractionEnabled = YES;


    self.view.backgroundColor =[UIColor whiteColor];
    [self loadNewData];
   
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

-(void)logoImage{
    [UIApplication sharedApplication].statusBarHidden =NO;
    self.view.window.rootViewController =[[MainController alloc]init];

}
#pragma mark 加载微博数据
- (void)loadNewData
{
    

    [gategoryListTool statusesWithSuccess:^(NSArray *statues) {
        [_categoryArray addObjectsFromArray:statues];
        
        [NSKeyedArchiver archiveRootObject:_categoryArray toFile:kFilePath];
        
        [self addScrollView ];
        [self addCateGoryButton];
        [self addlineView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
         _offLineDataArray= [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
       

        [self addScrollViewOffLine];
        [self failView];

        [self addCateGoryButtonOffLine];
        [self addlineViewOffLine];

        
    }];

}



- (void)addFirstCateView
{
    
}

-(void)addScrollViewOffLine
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.view.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _offLineDataArray.count/3*(66+30)+10);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor =[UIColor whiteColor];
    
    [self.view addSubview:_scrollView];
}

-(void)addScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, self.view.frame.size.height)];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _categoryArray.count/3*(66+30)+10);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.backgroundColor =[UIColor whiteColor];

    [self.view addSubview:_scrollView];
    
}


-(void)addCateGoryButton
{
    // 显示指示器
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    for (int but=0; but<_categoryArray.count; but++) {
        gategoryModel *cagegoryModel =[_categoryArray objectAtIndex:but];

        
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:cagegoryModel.nameGategory forState:UIControlStateNormal];
        [_scrollView addSubview:titleBtn];
        titleBtn .titleLabel.font = [UIFont systemFontOfSize:PxFont(24)];
        titleBtn.frame =CGRectMake(25+but%3*(70+40), 67+but/3*(60+35), 50, 30);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:14];
               UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(but%3*(70+37), 0+but/3*(60+35), kWidth/3, 96);
        [_scrollView addSubview:button];
        button.titleLabel.text = titleBtn.titleLabel.text;

        

        UIImageView *findImage =[[UIImageView alloc]init];
        findImage.frame =CGRectMake(25+but%3*(70+40), 10+but/3*(60+35), 50, 50);
        [_scrollView addSubview:findImage];
        
        button.tag=[cagegoryModel.idType intValue]+1000;
        findImage.tag = button.tag+100000;
        titleBtn.tag =findImage.tag;
        
        findImage.userInteractionEnabled = NO;
        
        [findImage setImageWithURL:[NSURL URLWithString:cagegoryModel.imageGategpry]  placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
        
        [button addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        


    }
    
    
   
}


- (void)addCateGoryButtonOffLine
{
    for (int but=0; but<_offLineDataArray.count; but++) {
        gategoryModel *cagegoryModel =[_offLineDataArray objectAtIndex:but];
        
        
        
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:cagegoryModel.nameGategory forState:UIControlStateNormal];
        [_scrollView addSubview:titleBtn];
        titleBtn .titleLabel.font = [UIFont systemFontOfSize:PxFont(24)];
        titleBtn.frame =CGRectMake(25+but%3*(70+40), 67+but/3*(60+35), 50, 30);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(but%3*(70+37), 0+but/3*(60+35), kWidth/3, 96);
        [_scrollView addSubview:button];
        button.titleLabel.text = titleBtn.titleLabel.text;
        
        
        
        UIImageView *findImage =[[UIImageView alloc]init];
        findImage.frame =CGRectMake(25+but%3*(70+40), 10+but/3*(60+35), 50, 50);
        [_scrollView addSubview:findImage];
        
        button.tag=[cagegoryModel.idType intValue]+1000;
        findImage.tag = button.tag+100000;
        titleBtn.tag =findImage.tag;
        
        findImage.userInteractionEnabled = NO;
        
        UIImage *cacheImg = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:cagegoryModel.imageGategpry];
        if (cacheImg) {
            findImage.image = cacheImg;
        }else
        {
            [findImage setImageWithURL:[NSURL URLWithString:cagegoryModel.imageGategpry]  placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
        }
        [button addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)addlineViewOffLine
{
    for (int l=0; l<_offLineDataArray.count/4+1; l++) {
        UIView *linex =[[UIView alloc]init];
        linex.backgroundColor =HexRGB(0xe6e3e4);
        linex.frame =CGRectMake(0,95+l%9*(50+45) , kWidth, 1);
        [_scrollView addSubview:linex];
    }
    for (int i = 0; i<2; i++) {
        UIView *liney =[[UIView alloc]init];
        liney.backgroundColor =HexRGB(0xe6e3e4);
        
        liney.frame =CGRectMake(kWidth/3+i%3*(75+32),8 , 1, _offLineDataArray.count/3*(63+30));
        [_scrollView addSubview:liney];
    }
}

-(void)failView{
    for (int but=0; but<23; but++) {
        UIImageView *findImage =[[UIImageView alloc]init];
        findImage.frame =CGRectMake(25+but%3*(70+40), 10+but/3*(60+35), 50, 50);
        [_scrollView addSubview:findImage];
        
       
        
           findImage.image=  [UIImage imageNamed:@"find_fail.png"];
        
        
        
        
    }
    
    for (int l=0; l<23/4+1; l++) {
        UIView *linex =[[UIView alloc]init];
        linex.backgroundColor =HexRGB(0xe6e3e4);
        linex.frame =CGRectMake(0,95+l%9*(50+45) , kWidth, 1);
        [_scrollView addSubview:linex];
    }
    for (int i = 0; i<2; i++) {
        UIView *liney =[[UIView alloc]init];
        liney.backgroundColor =HexRGB(0xe6e3e4);
        
        liney.frame =CGRectMake(kWidth/3+i%3*(75+32),8 , 1, 23/3*(63+30));
        [_scrollView addSubview:liney];
    }


}
-(void)addlineView
{
    
    for (int l=0; l<_categoryArray.count/4+1; l++) {
        UIView *linex =[[UIView alloc]init];
        linex.backgroundColor =HexRGB(0xe6e3e4);
        linex.frame =CGRectMake(0,95+l%9*(50+45) , kWidth, 1);
        [_scrollView addSubview:linex];
    }
    for (int i = 0; i<2; i++) {
        UIView *liney =[[UIView alloc]init];
        liney.backgroundColor =HexRGB(0xe6e3e4);

        liney.frame =CGRectMake(kWidth/3+i%3*(75+32),8 , 1, _categoryArray.count/3*(63+30));
        [_scrollView addSubview:liney];
    }

}
- (void)itemsClick:(UIButton *)sender

{
    if (!catClickFlage) {
        return ;
    }
    catClickFlage = false;
        currentTag =(int) sender.tag+100000;
       currStr=sender.titleLabel.text;
    
    for (UIView *view in [_scrollView subviews])
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

-(void)changeUI{
    
    for (UIView *view in [_scrollView subviews])
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
    find.titleLabel = currStr;
    
    NSString *strId =[NSString stringWithFormat:@"%d",currentTag-1000-100000];
    find.cateIndex = strId;
    [self.navigationController pushViewController:find animated:YES];
    catClickFlage = true;
    
}
-(void)searchBarBtn{
    SearchController *search =[[SearchController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}
-(void)logoBtn
{
    HomeController *home=[[HomeController alloc]init];
    [self.navigationController pushViewController:home animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

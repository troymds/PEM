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
@interface MessageController ()
{
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArray;
}

@property (nonatomic, retain) NSMutableArray *menuArray;
@property (nonatomic,copy)NSString *menuUrlString;

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
    _categoryArray = [[NSMutableArray alloc]init];
    
    UIButton * _searchImage =[UIButton buttonWithType:UIButtonTypeCustom];
    _searchImage.frame =CGRectMake(0, 0, 180, 30);
    [self.view addSubview:_searchImage];
    self.navigationItem.titleView =_searchImage;
    [_searchImage setImage:[UIImage imageNamed:@"nav_searchhome.png"] forState:UIControlStateNormal];
    [_searchImage addTarget:self action:@selector(searchBarBtn) forControlEvents:UIControlEventTouchUpInside];
    //    _searchImage.userInteractionEnabled = YES;
    //    _searchImage.image =[UIImage imageNamed:@"nav_searchhome.png"];
    
    
    
    
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_code.png" highlightedSearch:@"vav_code_pre.png" target:(self) action:@selector(lo)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithSearch:@"nav_logo.png" highlightedSearch:@"nav_logo.png" target:(self) action:@selector(logoImage)];
    self.view.userInteractionEnabled = YES;


    self.view.backgroundColor =[UIColor whiteColor];
    [self loadNewData];
    
    [self addScrollView];
    [self addCateGoryButton];
    [self addlineView];
}


-(void)lo{
    
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
        
        [self addScrollView ];
        [self addCateGoryButton];
        [self addlineView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


    } failure:^(NSError *error) {
        
    }];

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
    hud.labelText = @"正在加载中...";
    hud.dimBackground = YES;
    
    for (int but=0; but<_categoryArray.count; but++) {
        gategoryModel *cagegoryModel =[_categoryArray objectAtIndex:but];

        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(but%3*(70+37), 0+but/3*(60+35), kWidth/3, 96);
        button.tag =but+100;
        [_scrollView addSubview:button];
        [button setBackgroundImage:[UIImage imageNamed:@"dibuhengtiao.png"] forState:UIControlStateHighlighted];
        UIButton *titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [titleBtn setTitle:cagegoryModel.nameGategory forState:UIControlStateNormal];
        [_scrollView addSubview:titleBtn];
        titleBtn .titleLabel.font = [UIFont systemFontOfSize:PxFont(24)];
        titleBtn.frame =CGRectMake(25+but%3*(70+40), 67+but/3*(60+35), 50, 30);
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.font =[UIFont systemFontOfSize:14];
        button.tag = [cagegoryModel.idType intValue]+1000;
        [titleBtn addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.text = titleBtn.titleLabel.text;

        titleBtn.tag =button.tag;

        UIImageView *findImage =[[UIImageView alloc]init];
        findImage.frame =CGRectMake(25+but%3*(70+40), 10+but/3*(60+35), 50, 50);
        [_scrollView addSubview:findImage];
        findImage.tag = [cagegoryModel.idType intValue]+1000;
        titleBtn.tag =findImage.tag;
        findImage.userInteractionEnabled = NO;
        
        [findImage setImageWithURL:[NSURL URLWithString:cagegoryModel.imageGategpry]  placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
        

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
   
        findViewController *menu = [[findViewController alloc] init];
        menu.titleLabel =sender.titleLabel.text;
        NSString *strId =[NSString stringWithFormat:@"%ld",sender.tag-1000];
        menu.cateIndex =strId;


        [self.navigationController pushViewController:menu animated:YES];
   


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

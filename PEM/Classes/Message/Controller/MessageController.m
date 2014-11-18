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
//#import "SelectImgCell.h"
//#import "ProImageView.h"
//#import "ExtendCell.h"
//#import "CompanyDetailViewController.h"
#import "DimensionalCodeViewController.h"
#define kFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"message.data"]

@interface MessageController ()<ZBarReaderDelegate>
{
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArray;
    ZBarReaderViewController *_reader;
//    UITableView *_tableView;
//    NSMutableArray *_firstArray;
//    NSMutableArray *_secondArray;
//    NSMutableArray *_dataArray;
//    CGFloat height;
//    NSIndexPath *selectIndexPath;
//    ProImageView *selectImg;
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
    
//    _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-44) style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [self.view addSubview:_tableView];
//    
//    _firstArray = [[NSMutableArray alloc] initWithCapacity:0];
//    _secondArray = [[NSMutableArray alloc] initWithCapacity:0];
//    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    if ([self.delegate respondsToSelector:@selector(changeControllerFrom:to:)]) {
        [self.delegate changeControllerFrom:1 to:0];
    }
}
#pragma mark 加载微博数据
- (void)loadNewData
{
    

    [gategoryListTool statusesWithSuccess:^(NSArray *statues) {
        [_categoryArray addObjectsFromArray:statues];
        
        [NSKeyedArchiver archiveRootObject:_categoryArray toFile:kFilePath];
        //将一二级分类数据分开
//        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
//        for (gategoryModel *item in statues) {
//            if ([item.parent_id isEqualToString:@"0"]) {
//                [_firstArray addObject:item];
//            }else{
//                [arr addObject:item];
//            }
//        }
//        for (int i = 0; i < [_firstArray count]; i++) {
//            NSMutableArray *muatbleArray = [[NSMutableArray alloc] initWithCapacity:0];
//            gategoryModel *firstItem = [_firstArray objectAtIndex:i];
//            for (gategoryModel *secondItem in arr) {
//                if ([secondItem.parent_id isEqualToString:firstItem.idType]) {
//                    [muatbleArray addObject:secondItem];
//                }
//            }
//            [_dataArray addObject:muatbleArray];
//        }
//        [_tableView reloadData];
        
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


//#pragma mark ---tableView_delegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return _firstArray.count%3==0? _firstArray.count/3:_firstArray.count/3+1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == selectIndexPath.row&&selectIndexPath!=nil) {
//        static NSString *cellName = @"cellName";
//        SelectImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
//        if (cell == nil) {
//            cell = [[SelectImgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
//        }
//        gategoryModel *item = [_firstArray objectAtIndex:indexPath.row*3];
//        [cell.img1 setImageWithURL:[NSURL URLWithString:item.imageGategpry] placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
//        cell.img1.tag = 1000+indexPath.row*3;
//        cell.img1.delegate = self;
//        if (indexPath.row*3+1<_firstArray.count) {
//            gategoryModel *item = [_firstArray objectAtIndex:indexPath.row*3+1];
//            cell.img2.hidden = NO;
//            [cell.img2 setImageWithURL:[NSURL URLWithString:item.imageGategpry] placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
//            cell.img2.tag = 1000+indexPath.row*3+1;
//            cell.img2.delegate = self;
//        }else{
//            cell.img2.hidden = YES;
//        }
//        if (indexPath.row*3+2<_firstArray.count) {
//            gategoryModel *item = [_firstArray objectAtIndex:indexPath.row*3+2];
//            cell.img3.hidden = NO;
//            [cell.img3 setImageWithURL:[NSURL URLWithString:item.imageGategpry] placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
//            cell.img3.tag = 1000+indexPath.row*3+2;
//            cell.img3.delegate = self;
//            
//        }else{
//            cell.img3.hidden = YES;
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;;
//        return cell;
//    }else{
//         static NSString *identify = @"identiry";
//         SelectImgCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
//         if (cell == nil) {
//             cell = [[SelectImgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
//         }
//        gategoryModel *item = [_firstArray objectAtIndex:indexPath.row*3];
//        [cell.img1 setImageWithURL:[NSURL URLWithString:item.imageGategpry] placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
//        cell.img1.tag = 1000+indexPath.row*3;
//        cell.img1.delegate = self;
//        if (indexPath.row*3+1<_firstArray.count) {
//            gategoryModel *item = [_firstArray objectAtIndex:indexPath.row*3+1];
//            cell.img2.hidden = NO;
//            [cell.img2 setImageWithURL:[NSURL URLWithString:item.imageGategpry] placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
//            cell.img2.tag = 1000+indexPath.row*3+1;
//            cell.img2.delegate = self;
//        }else{
//            cell.img2.hidden = YES;
//        }
//        if (indexPath.row*3+2<_firstArray.count) {
//            gategoryModel *item = [_firstArray objectAtIndex:indexPath.row*3+2];
//            cell.img3.hidden = NO;
//            [cell.img3 setImageWithURL:[NSURL URLWithString:item.imageGategpry] placeholderImage:[UIImage imageNamed:@"find_fail.png"]];
//            cell.img3.tag = 1000+indexPath.row*3+2;
//            cell.img3.delegate = self;
//            
//        }else{
//            cell.img3.hidden = YES;
//        }
//             cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
//    return nil;
//}
//
//- (void)imageClicked:(ProImageView *)image
//{
//    NSLog(@"%d",image.tag);
//    image.hasSelected = !image.hasSelected;
//    if (selectImg == nil) {
//        selectImg = image;
//    }
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(image.tag-1000)/3 inSection:0];
//    if (!selectIndexPath) {
//        selectIndexPath = indexPath;
//        height = [self getHeight];
//        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//    }else{
//        BOOL selectTheSameRow = indexPath.row == selectIndexPath.row?YES:NO;
//        if (!selectTheSameRow) {
//            //收起上次点击展开的cell
//            NSIndexPath *tempIndexPath = [selectIndexPath copy];
//            selectIndexPath = nil;
//            height = 0;
//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:tempIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//            //展开新选择的cell
//            selectIndexPath = indexPath;
//            height = [self getHeight];
//            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//        }else{
//            //若点击相同的cell
//            //若点击相同的图片 收起cell
//            if (selectImg.tag == image.tag) {
//                selectIndexPath = nil;
//                height = 0;
//                selectImg = nil;
//                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//            }else{
//                selectImg = image;
//                height = [self getHeight];
//                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:selectIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }
//    }
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row == selectIndexPath.row&&selectIndexPath!=nil) {
//        return kWidth/3+height;
//    }
//    return kWidth/3;
//}
//
//- (CGFloat)getHeight
//{
//    int tag = selectImg.tag;
//    NSLog(@"---%d",tag);
//    int count = [[_dataArray objectAtIndex:tag-1000] count];
//    NSLog(@"%d",count);
//    if (count == 0) {
//        return 0;
//    }
//    count = count%3==0?count/3:count/3+1;
//    return 50+count*20+(count-1)*28;
//}




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

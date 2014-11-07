//
//  CategoryController.m
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CategoryController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "SystemConfig.h"
#import "NSString+MD5.h"
#import "AFJSONRequestOperation.h"
#import "DateManeger.h"
#import "HttpTool.h"
#import "CategoryItem.h"
#import "RemindView.h"
#import "CategoryCell.h"
#import "UIImageView+WebCache.h"
#import "CategoryView.h"

@interface CategoryController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CategoryViewDelegate>
{
    NSMutableArray *_dataArray;
    UIScrollView *_scrollView;
    NSMutableArray *_categoryArr;
    NSMutableArray *_firstArray;
    NSMutableArray *_secondArray;
    UITableView *_firstTableView;
    UITableView *_secondTableView;
}


@end

@implementation CategoryController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HexRGB(0xffffff);
    self.title = @"选择分类";
    _dataArray = [[NSMutableArray alloc] init];
    _firstArray = [[NSMutableArray alloc] init];
    _secondArray = [[NSMutableArray alloc] init];
    
    
    _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(195, 0, kWidth-195, kHeight-64) style:UITableViewStylePlain];
    _secondTableView.delegate = self;
    _secondTableView.dataSource =self;
    _secondTableView.tag = 1001;
    _secondTableView.showsHorizontalScrollIndicator = NO;
    _secondTableView.showsVerticalScrollIndicator = NO;
    _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _secondTableView.separatorColor = [UIColor clearColor];
    _secondTableView.backgroundColor = HexRGB(0xf2f2f2);
    [self.view addSubview:_secondTableView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,195,kHeight-64)];
    _scrollView.backgroundColor = HexRGB(0xffffff);
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
        
    [self getData];
}


- (void)getData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [HttpTool postWithPath:@"getCategoryList" params:nil success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([dic objectForKey:@"response"]) {
            if (!isNull(dic, @"response")) {
                NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"response"]];
                NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *subDic in array) {
                    NSString *parent_id = [NSString stringWithFormat:@"%d",[[subDic objectForKey:@"parent_id"] intValue]];
                    CategoryItem *item = [[CategoryItem alloc] initWithDic:subDic];
                    if ([parent_id isEqualToString:@"0"]) {
                        [_firstArray addObject:item];
                    }else{
                        [arr addObject:item];
                    }
                }
                for (int i = 0; i < [_firstArray count]; i++) {
                    NSMutableArray *muatbleArray = [[NSMutableArray alloc] initWithCapacity:0];
                    CategoryItem *firstItem = [_firstArray objectAtIndex:i];
                    for (CategoryItem *secondItem in arr) {
                        if ([secondItem.parent_id isEqualToString:firstItem.uid]) {
                            [muatbleArray addObject:secondItem];
                        }
                    }
                    [_dataArray addObject:muatbleArray];
                }
                [self addLeftView];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}


- (void)addLeftView
{
    [_scrollView setContentSize:CGSizeMake(195,75*[_firstArray count])];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(194.5, 0,0.5,_scrollView.contentSize.height)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [_scrollView addSubview:line];
    for (int i = 0 ; i < [_firstArray count]; i++) {
        CategoryItem *item = [_firstArray objectAtIndex:i];
        CategoryView *view = [[CategoryView alloc] initWithFrame:CGRectMake(0, 75*i, 195, 75)];
        view.titleLabel.text = item.name;
        view.tag = 4000+i;
        if (i==0) {
            view.isSelected = YES;
        }
        view.delegate = self;
        [view.iconImg setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"loading1.png"]];
        [_scrollView addSubview:view];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,75*i,195,0.5)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [_scrollView addSubview:line];
        NSMutableArray *array = [_dataArray objectAtIndex:i];
        int count = array.count;
        if (count>0) {
            if (count==1) {
                CategoryItem *item = [array objectAtIndex:0];
                view.desLabel.text = item.name;
            }else{
                CategoryItem *item1 = [array objectAtIndex:0];
                CategoryItem *item2 = [array objectAtIndex:1];
                NSString *str =[NSString stringWithFormat:@"%@  %@",item1.name,item2.name];
                view.desLabel.text = str;
            }
        }
    }
    if ([_dataArray count]!=0) {
        _secondArray = [_dataArray objectAtIndex:0];
    }
    [_secondTableView reloadData];
}

- (void)categoryViewClicked:(CategoryView *)view
{
    for (UIView *subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[CategoryView class]]) {
            CategoryView *categoryView = (CategoryView *)subView;
            if (categoryView.tag!=view.tag) {
                categoryView.isSelected = NO;
            }
        }
    }
    _secondArray = [_dataArray objectAtIndex:view.tag-4000];
    [_secondTableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentSize.height-scrollView.frame.size.height>0) {
        scrollView.scrollEnabled = YES;
    }else{
        scrollView.scrollEnabled = NO;
    }
    if (scrollView.contentOffset.y<0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentSize.height-scrollView.frame.size.height>0) {
        if (scrollView.contentOffset.y>scrollView.contentSize.height-scrollView.frame.size.height) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height);
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_secondArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"identify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    CategoryItem *item = [_secondArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    cell.textLabel.textColor = HexRGB(0x808080);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,44,kWidth-196,1)];
    line.backgroundColor = HexRGB(0xfffffff);
    [cell.contentView addSubview:line];
    cell.backgroundColor = HexRGB(0xf2f2f2);
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryItem *item = [_secondArray objectAtIndex:indexPath.row];
    if (_isSupply){
        if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
            [self.delegate sendValueFromViewController:self value:item isDemand:NO];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
            [self.delegate sendValueFromViewController:self value:item isDemand:YES];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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

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

@interface CategoryController ()

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
    
    _firstTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,195,kHeight-64) style:UITableViewStylePlain];
    _firstTableView.delegate = self;
    _firstTableView.dataSource =self;
    _firstTableView.tag = 1000;
    _firstTableView.showsHorizontalScrollIndicator = NO;
    _firstTableView.showsVerticalScrollIndicator = NO;
    _firstTableView.backgroundColor = [UIColor clearColor];
    _firstTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _firstTableView.separatorColor = [UIColor clearColor];

    [self.view addSubview:_firstTableView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(195, 0, 1, kHeight-64)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [self.view addSubview:line];
    
    _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(196, 0, kWidth-196, kHeight-64) style:UITableViewStylePlain];
    _secondTableView.delegate = self;
    _secondTableView.dataSource =self;
    _secondTableView.tag = 1001;
    _secondTableView.showsHorizontalScrollIndicator = NO;
    _secondTableView.showsVerticalScrollIndicator = NO;
    _secondTableView.backgroundColor = [UIColor clearColor];
    _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _secondTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_secondTableView];
    [self getData];
}


- (void)getData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [HttpTool postWithPath:@"getCategoryList" params:nil success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([dic objectForKey:@"response"]) {
            NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"response"]];
            for (NSDictionary *subDic in array) {
                CategoryItem *item = [[CategoryItem alloc] initWithDic:subDic];
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
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
    if (tableView.tag == 1000) {
        return [_firstArray count];
    }
    return [_secondArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (tableView.tag == 2000) {
        static NSString *cellName = @"CellName";
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,74,195,1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [cell.contentView addSubview:line];
        
    }else{
        static NSString *cellName = @"identify";
        cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,44,kWidth-196,1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [cell.contentView addSubview:line];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        return 75;
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1000) {
        
    }else{
        CategoryItem *item = [_dataArray objectAtIndex:indexPath.row];
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

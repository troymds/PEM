//
//  MyFavoriteController.m
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MyFavoriteController.h"
#import "SystemConfig.h"
#import "HttpTool.h"
#import "MyFavoriteItem.h"
#import "FavoriteCell.h"
#import "UIImageView+WebCache.h"
#import "xiangqingViewController.h"
#import "RemindView.h"
#import "LoadMoreCell.h"

@interface MyFavoriteController ()<UIScrollViewDelegate>
{
    BOOL needLoad;//是否需要加载
    BOOL isLoading;//是否正在加载
    BOOL isRefresh;//是否正在刷新

}
@end

@implementation MyFavoriteController

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
    self.title = @"我的收藏";
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
//    isLoad = NO;
    isRefresh = NO;
    [self loadData];
    [self addRefreshViews];
}

#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    MJHeadView = [MJRefreshHeaderView header];
    MJHeadView.scrollView = _tableView;
    MJHeadView.delegate = self;
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        isRefresh = YES;
    }
    [self loadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSIndexPath * indexpath=[NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:0]-1 inSection:0];
    if ([[_tableView cellForRowAtIndexPath:indexpath] isKindOfClass:[LoadMoreCell class]]&&scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height+40) {
        if (!isLoading) {
            isLoading = YES;
            [self loadData];
        }
    }
}

- (void)loadData{
    NSString *company_id = [SystemConfig sharedInstance].company_id;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"lastid",@"10",@"pagesize",company_id,@"company_id",nil];
    if (isLoading) {
        if (_dataArray.count!=0) {
            NSString *lastid = [NSString stringWithFormat:@"%lu",(unsigned long)[_dataArray count]];
            [params setObject:lastid forKey:@"lastid"];
        }
    }
    if (!(isLoading||isRefresh)) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
        hud.labelText = @"加载中...";
    }
    [HttpTool postWithPath:@"getWishlist" params:params success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([result objectForKey:@"response"]) {
            if (isRefresh) {
                if (_dataArray.count!=0) {
                    [_dataArray removeAllObjects];
                }
            }
            if (![[result objectForKey:@"response"] isKindOfClass:[NSNull class]]){
                
                NSArray *arr = [result objectForKey:@"response"];
                int count = 0 ;
                for (NSDictionary *dic in arr) {
                    MyFavoriteItem *item = [[MyFavoriteItem alloc] initWithDictionary:dic];
                    [_dataArray addObject:item];
                    count++;
                }
                if (count < 10) {
                    needLoad = NO;
                }else{
                    needLoad = YES;
                }
                [_tableView reloadData];
            }else{
                if (needLoad) {
                    needLoad = NO;
                    [_tableView reloadData];
                }
                if (_dataArray.count ==0){
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
                    view.backgroundColor = HexRGB(0xffffff);
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
                    label.backgroundColor = [UIColor clearColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = @"没有收藏!";
                    label.center = view.center;
                    [view addSubview:label];
                    [self.view addSubview:view];
                }else{
                    [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
                    
                }
            }
            if (isLoading) {
                isLoading = NO;
            }
            if (isRefresh) {
                isRefresh = NO;
                [MJHeadView endRefreshing];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        if (isRefresh) {
            isRefresh = NO;
            [MJHeadView endRefreshing];
        }
        if (isLoading) {
            isLoading = NO;
        }
        NSInteger count = [_tableView numberOfRowsInSection:0];
        if (count!=_dataArray.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataArray.count inSection:0];
            LoadMoreCell *cell = (LoadMoreCell *)[_tableView cellForRowAtIndexPath:indexPath];
            cell.loadBtn.hidden = NO;
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return needLoad?[_dataArray count]+1:[_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<_dataArray.count) {
        static NSString *identifier = @"Identifier";
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[FavoriteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        MyFavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",item.img]] placeholderImage:[UIImage imageNamed:@"loading1.png"]];
        cell.nameLabel.text = item.title;
        if ([item.price isEqualToString:@"0"]) {
            cell.priceLabel.text = @"价格:电议";
        }else{
            cell.priceLabel.text = [NSString stringWithFormat:@"价格:%@元",item.price];
        }
        cell.dateLabel.text = item.collectTimes;
        cell.timesLabel.text = [NSString stringWithFormat:@"收藏%@次",item.collect_num];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,94, kWidth-20, 1)];
        lineView.backgroundColor = HexRGB(0xd5d5d5);
        [cell.contentView addSubview:lineView];
        return cell;
    }else{
        static NSString *cellName = @"cellName";
        LoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[LoadMoreCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
        }
        [cell.activityView startAnimating];
        [cell.loadBtn addTarget:self action:@selector(loadBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)loadBtnDown:(UIButton *)btn
{
    btn.hidden = YES;
    isLoading = YES;
    [self loadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<_dataArray.count) {
        return 95;
    }
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _dataArray.count) {
        MyFavoriteItem *item = [_dataArray objectAtIndex:indexPath.row];
        xiangqingViewController *detailVC = [[xiangqingViewController alloc] init];
        detailVC.delegate = self;
        detailVC.supplyIndex = item.info_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}


- (void)reloadData{
    isRefresh = YES;
    [self loadData];
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

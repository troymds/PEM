//
//  MySupplyController.m
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MySupplyController.h"
#import "SupplyCell.h"
#import "HttpTool.h"
#import "MySupplyItem.h"
#import "UIImageView+WebCache.h"
#import "xiangqingViewController.h"
#import "SystemConfig.h"
#import "RemindView.h"
#import "SupplyController.h"


@interface MySupplyController ()

@end

@implementation MySupplyController

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
    self.title = @"我的供应";
    self.view.backgroundColor = HexRGB(0xffffff);

    if (IsIos7) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    // Do any additional setup after loading the view.
    longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewLongGesture:)];
    [_tableView addGestureRecognizer:longGesture];
    isLoad = NO;
    isRefresh = NO;
    
    [self addRemindView];
    
    [self loadData];
    [self addRefreshViews];
}

- (void)addRemindView
{
    remindView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    remindView.backgroundColor = HexRGB(0xffffff);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,180, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"没有供应信息!";
    label.center = remindView.center;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth/2-40,label.frame.origin.y+label.frame.size.height+20,80,35);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"立即发布" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"finish.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(publishBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [remindView addSubview:button];
    [remindView addSubview:label];
    [self.view addSubview:remindView];
    
    remindView.hidden = YES;
}


#pragma mark 集成刷新控件
- (void)addRefreshViews
{
    // 2.上拉加载更多
    MJFootView = [MJRefreshFooterView footer];
    MJFootView.scrollView = _tableView;
    MJFootView.delegate = self;
    
    MJHeadView = [MJRefreshHeaderView header];
    MJHeadView.scrollView = _tableView;
    MJHeadView.delegate = self;
}

#pragma mark 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        isLoad = YES;
    }else{
        isRefresh = YES;
    }
    [self loadData];
}




//长按手势响应
- (void)tableViewLongGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longGesture locationInView:_tableView];
        delIndex = [_tableView indexPathForRowAtPoint:point];
        MySupplyItem *item = [_dataArray objectAtIndex:delIndex.row];
        
        DeleteView *deleView = [[DeleteView alloc] initWithTitle:item.name];
        deleView.delegate =self;
        [deleView showView];
    }
}


- (void)loadData{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",@"time",@"sort",@"3",@"verify", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    condition = [condition stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"lastid",@"10",@"pagesize",condition,@"condition", nil];
    if (isLoad) {
        if (_dataArray.count!=0){
            NSString *lastid = [NSString stringWithFormat:@"%lu",(unsigned long)[_dataArray count]];
            [params setObject:lastid forKey:@"lastid"];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hud.labelText = @"加载中...";
    [HttpTool postWithPath:@"getSupplyInfoList" params:params success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([result objectForKey:@"response"]) {
            //返回的数据是否为空
            if (![[result objectForKey:@"response"] isKindOfClass:[NSNull class]]){
                if (isRefresh) {
                    if (_dataArray.count!=0) {
                        [_dataArray removeAllObjects];
                    }
                }
                NSArray *arr = [result objectForKey:@"response"];
                for (NSDictionary *dict in arr) {
                    MySupplyItem *item = [[MySupplyItem alloc] initWithDictonary:dict];
                    [_dataArray addObject:item];
                }
                [_tableView reloadData];
            }else{
                //返回数据为空且数组中没有数据 该界面无数据
                if (_dataArray.count == 0) {
                    remindView.hidden = NO;
                }else{
                    [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
                }
            }
            if (isLoad) {
                isLoad = NO;
                [MJFootView endRefreshing];
            }
            if (isRefresh) {
                isRefresh = NO;
                [MJHeadView endRefreshing];
            }
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}


- (void)publishBtnDown
{
    SupplyController *sc = [[SupplyController alloc] init];
    sc.isAdd = YES;
    sc.title = @"发布";
    [self.navigationController pushViewController:sc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idetifier = @"Identifier";
    SupplyCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (!cell) {
        cell = [[SupplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idetifier];
    }
    MySupplyItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = item.name;
    if ([item.price isEqualToString:@"0"]) {
        cell.priceLabel.text = @"价格电议";
    }else{
        cell.priceLabel.text = [NSString stringWithFormat:@"%@元/每%@",item.price,item.unit];
    }
    cell.standardLabel.text = [NSString stringWithFormat:@"%@%@起供应",item.min_supply_num,item.unit];
    NSString *date = [item.date substringWithRange:NSMakeRange(0,10)];
    cell.timeLabel.text = date;
    
    if ([item.verify_result isEqualToString:@"0"]) {
        cell.resultLabel.text = @"待审核";
        cell.resultLabel.textColor = HexRGB(0xff7300);
    }else if([item.verify_result isEqualToString:@"2"]){
        cell.resultLabel.text = @"审核未通过";
        cell.resultLabel.textColor = HexRGB(0x808080);
 
    }
    
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:item.image] placeholderImage:[UIImage imageNamed:@"loading1.png"]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,87, kWidth-20, 1)];
    lineView.backgroundColor = HexRGB(0xd5d5d5);
    [cell.contentView addSubview:lineView];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MySupplyItem *item = [_dataArray objectAtIndex:indexPath.row];
    xiangqingViewController *detailVC = [[xiangqingViewController alloc] init];
    detailVC.supplyIndex = item.uid;
    [self.navigationController pushViewController:detailVC animated:YES];
        
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySupplyItem *item = [_dataArray objectAtIndex:indexPath.row];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",item.uid,@"infoid", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在删除...";
    [HttpTool postWithPath:@"deleteInfo" params:params success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([result objectForKey:@"response"]) {
            if ([[[result objectForKey:@"response"] objectForKey:@"code"] intValue] == 100) {
                [_dataArray removeObjectAtIndex:delIndex.row];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                if ([_dataArray count] == 0) {
                    remindView.hidden = NO;
                }
                
            }else{
                [RemindView showViewWithTitle:@"删除失败" location:MIDDLE];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}


- (void)buttonClicked:(UIButton *)btn{
    MySupplyItem *item = [_dataArray objectAtIndex:delIndex.row];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",item.uid,@"infoid", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在删除...";
    [HttpTool postWithPath:@"deleteInfo" params:params success:^(id JSON){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([result objectForKey:@"response"]) {
            if ([[[result objectForKey:@"response"] objectForKey:@"code"] intValue] == 100) {
                [_dataArray removeObjectAtIndex:delIndex.row];
                [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
                if ([_dataArray count] == 0) {
                    remindView.hidden = NO;
                }
            }else{
                [RemindView showViewWithTitle:@"删除失败" location:MIDDLE];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];
}

- (void)reloadData
{
    isRefresh = YES;
    remindView.hidden = YES;
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

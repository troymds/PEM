//
//  MyPurchaseController.m
//  PEM
//
//  Created by tianj on 14-8-27.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "MyPurchaseController.h"
#import "PurchaseCell.h"
#import "HttpTool.h"
#import "MyPurchaseItem.h"
#import "HttpTool.h"
#import "SystemConfig.h"
#import "qiugouXQ.h"
#import "RemindView.h"
#import "DemandController.h"


@interface MyPurchaseController ()

@end

@implementation MyPurchaseController

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
    self.title = @"我的求购";
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
    
    isLoad = NO;
    isRefresh = NO;
    
    longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewLongGesture:)];
    [_tableView addGestureRecognizer:longGesture];
    
    [self addRemindView];
    
    [self loadData];
    [self addRefreshViews];
}

- (void)addRemindView
{
    remindView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    remindView.backgroundColor = HexRGB(0xe9f0f5);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,180, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"没有发布求购信息!";
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
    //    _statusFrames = [NSMutableArray array];
    
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


- (void)loadData{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",@"time",@"sort",@"3",@"verify", nil];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *condition = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    condition = [condition stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"lastid",@"10",@"pagesize",condition,@"condition",@"time",@"sort", nil];
    if (isLoad) {
        if (_dataArray.count!=0) {
            NSString *lastid = [NSString stringWithFormat:@"%lu",(unsigned long)[_dataArray count]];
            [params setObject:lastid forKey:@"lastid"];
        }
    }
    [HttpTool postWithPath:@"getDemandInfoList" params:params success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if (![[result objectForKey:@"response"] isKindOfClass:[NSNull class]]){
            if (isRefresh) {
                if (_dataArray.count!=0) {
                    [_dataArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in [result objectForKey:@"response"]) {
                MyPurchaseItem *item = [[MyPurchaseItem alloc] initWithDictionary:dic];
                [_dataArray addObject:item];
            }
            [_tableView reloadData];
        }else{
            if (_dataArray.count ==0) {
                remindView.hidden = NO;
            }else{
                [RemindView showViewWithTitle:@"数据已全部加载完毕" location:BELLOW];
            }
        }
        if (isRefresh) {
                isRefresh = NO;
                [MJHeadView endRefreshing];
        }
        if (isLoad) {
            isLoad = NO;
            [MJFootView endRefreshing];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)publishBtnDown
{
    DemandController *dc = [[DemandController alloc] init];
    dc.isAdd = YES;
    dc.title = @"发布";
    [self.navigationController pushViewController:dc animated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CellName";
    PurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[PurchaseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    MyPurchaseItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = item.name;
    cell.visitLabel.text = [NSString stringWithFormat:@"查看%@次",item.read_num];
    cell.timeLabel.text = item.date;
    
    if ([item.verify_result isEqualToString:@"0"]) {
        cell.resultLabel.text = @"待审核";
        cell.resultLabel.textColor = HexRGB(0xff7300);
    }else if([item.verify_result isEqualToString:@"2"]){
        cell.resultLabel.text = @"未审核";
        cell.resultLabel.textColor = HexRGB(0x808080);
        
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,59, kWidth-20, 1)];
    lineView.backgroundColor = HexRGB(0xd5d5d5);
    [cell.contentView addSubview:lineView];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPurchaseItem *item = [_dataArray objectAtIndex:indexPath.row];
    qiugouXQ *detailVC = [[qiugouXQ alloc] init];
    detailVC.demandIndex = item.uid;
    [self.navigationController pushViewController:detailVC animated:YES];
}


//长按手势响应
- (void)tableViewLongGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longGesture locationInView:_tableView];
        delIndex = [_tableView indexPathForRowAtPoint:point];
        MyPurchaseItem *item = [_dataArray objectAtIndex:delIndex.row];
        DeleteView *deleView = [[DeleteView alloc] initWithTitle:item.name];
        deleView.delegate =self;
        [deleView showView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPurchaseItem *item = [_dataArray objectAtIndex:indexPath.row];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",item.uid,@"infoid", nil];
    [HttpTool postWithPath:@"deleteInfo" params:params success:^(id JSON){
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([[[result objectForKey:@"response"] objectForKey:@"msg"] isEqualToString:@"ok"]) {
            [_dataArray removeObjectAtIndex:delIndex.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            NSLog(@"删除失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)buttonClicked:(UIButton *)btn{
    MyPurchaseItem *item = [_dataArray objectAtIndex:delIndex.row];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",item.uid,@"infoid", nil];
    [HttpTool postWithPath:@"deleteInfo" params:params success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([[[result objectForKey:@"response"] objectForKey:@"msg"] isEqualToString:@"ok"]) {
            [_dataArray removeObjectAtIndex:delIndex.row];
            [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:delIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            NSLog(@"删除失败");
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
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

//
//  DialRecordController.m
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "DialRecordController.h"
#import "DialRecordCell.h"
#import "SystemConfig.h"
#import "HttpTool.h"
#import "CallRecordItem.h"
#import "qiugouXQ.h"
#import "xiangqingViewController.h"

@interface DialRecordController ()

@end

@implementation DialRecordController

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
    self.title = @"拨号记录";
    self.view.backgroundColor = HexRGB(0xffffff);
    // Do any additional setup after loading the view.
    
    [self loadData];
}


- (void)loadData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id", nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [HttpTool postWithPath:@"getCallRecord" params:params success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if (![[result objectForKey:@"response"] isKindOfClass:[NSNull class]]) {
            NSArray *arr = [result objectForKey:@"response"];
            for (NSDictionary *dic in arr) {
                if ([[dic objectForKey:@"type"] intValue] !=0) {
                    CallRecordItem *item = [[CallRecordItem alloc] initWithDictionary:dic];
                    [_dataArray addObject:item];
                }
            }
            [_tableView reloadData];
        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
            view.backgroundColor = HexRGB(0xe9f0f5);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"没有拨号记录!";
            label.center = view.center;
            [view addSubview:label];
            [self.view addSubview:view];
        }
    } failure:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CellName";
    DialRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[DialRecordCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.dialBtn.tag = indexPath.row+1000;
    [cell.dialBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    CallRecordItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.name;
    cell.nameLabel.text = item.contacts;
    cell.timeLabel.text = item.call_time;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10,74, kWidth-20, 1)];
    lineView.backgroundColor = HexRGB(0xd5d5d5);
    [cell.contentView addSubview:lineView];

    return cell;
}


//- (NSString *)getTime:(NSString *)time{
//    NSString *timeStr = time;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSDate *inputDate = [[NSDate alloc] init];
//    inputDate = [formatter dateFromString:time];
//    
//    NSDate *nowDate = [NSDate date];
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
//    comps = [calendar components:unitFlags fromDate:inputDate];
//    int inputYear,inputMonth,inputDay;
//    int nowYear,nowMonth,nowDay;
//    inputYear = [comps year];
//    inputMonth = [comps month];
//    inputDay = [comps day];
//    
//    comps = [calendar components:unitFlags fromDate:nowDate];
//    nowYear = [comps year];
//    nowMonth = [comps month];
//    nowDay = [comps day];
//    if (nowYear>inputYear){
//        timeStr = [NSString stringWithFormat:@"%d-%02d-%02d",inputYear,inputMonth,inputDay];
//    }else{
//        if (nowMonth>inputMonth){
//            timeStr = [NSString stringWithFormat:@"%d-%02d-%02d",inputYear,inputMonth,inputDay];
//        }else{
//            if (nowDay>inputDay) {
//                timeStr = [NSString stringWithFormat:@"%d-%02d-%02d",inputYear,inputMonth,inputDay];
//            }else{
//                timeStr = [NSString stringWithFormat:@"%d-%d-%d",[comps hour],[comps minute],[comps second]];
//            }
//        }
//    }
//    
//    return timeStr;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CallRecordItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([item.type isEqualToString:@"1"]) {
        qiugouXQ *detailVC = [[qiugouXQ alloc] init];
        detailVC.demandIndex = item.info_id;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if([item.type isEqualToString:@"2"]){
        xiangqingViewController *xqVC = [[xiangqingViewController alloc] init];
        xqVC.supplyIndex = item.info_id;
        [self.navigationController pushViewController:xqVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}


//拨号
- (void)btnDown:(UIButton *)btn{
    CallRecordItem *item = [_dataArray objectAtIndex:btn.tag-1000];
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",item.phone_num]];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
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

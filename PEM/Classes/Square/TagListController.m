//
//  TagListController.m
//  PEM
//
//  Created by tianj on 14-9-16.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "TagListController.h"
#import "SystemConfig.h"
#import "HttpTool.h"
#import "TagInfoItem.h"
#import "qiugouXQ.h"

@interface TagListController ()

@end

@implementation TagListController

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
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)loadData{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[SystemConfig sharedInstance].company_id,@"company_id",_tag_id,@"tag_id",nil];
    [HttpTool postWithPath:@"getTagInfoList" params:param success:^(id JSON) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [result objectForKey:@"response"];
        if (dic) {
            if ([[dic objectForKey:@"code"] intValue] == 100) {
                if ([[dic objectForKey:@"data"] isKindOfClass:[NSNull class]]){
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
                    view.backgroundColor = HexRGB(0xe9f0f5);
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
                    label.text = @"没有数据!";
                    label.center = view.center;
                    [view addSubview:label];
                    [self.view addSubview:view];
                }else{
                    NSArray *dataArr = [dic objectForKey:@"data"];
                    for (NSDictionary *subDic in dataArr) {
                        TagInfoItem *item = [[TagInfoItem alloc] initWithDictionary:subDic];
                        [_dataArray addObject:item];
                    }
                    [_tableView reloadData];
                }
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    TagInfoItem *item = [_dataArray objectAtIndex:indexPath.row];
    UILabel *nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(20, 52/2-10, 200, 20)];
    nameLabel.textColor = HexRGB(0x3a3a3a);
    [cell.contentView addSubview:nameLabel];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-50-120, 52/2-10, 120, 20)];
    dateLabel.textColor = HexRGB(0x808080);
    dateLabel.font = [UIFont systemFontOfSize:PxFont(16)];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:dateLabel];
    
    dateLabel.text = item.create_time;
    nameLabel.text = item.title;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,51, kWidth,1)];
    lineView.backgroundColor = HexRGB(0xd5d5d5);
    [cell.contentView addSubview:lineView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TagInfoItem *item = [_dataArray objectAtIndex:indexPath.row];
    qiugouXQ *detailVC = [[qiugouXQ alloc] init];
    detailVC.demandIndex = item.uid;
    [self.navigationController pushViewController:detailVC animated:YES];
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

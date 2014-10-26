//
//  CityController.m
//  PEM
//
//  Created by tianj on 14-9-24.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CityController.h"
#import "HttpTool.h"
#import "AreaItem.h"
#import "RemindView.h"

@interface CityController ()

@end

@implementation CityController

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
    self.title =@"选择城市";
    self.view.backgroundColor = HexRGB(0xffffff);

    // Do any additional setup after loading the view.
    [self loadData];
}


- (void)loadData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:_uid,@"province", nil];
    [HttpTool postWithPath:@"getCityList" params:param success:^(id JSON) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        if ([result objectForKey:@"response"]) {
            NSDictionary *dic = [result objectForKey:@"response"];
            if ([[dic objectForKey:@"code"] intValue] == 100) {
                NSArray *data = [dic objectForKey:@"data"];
                for (NSDictionary *subDic in data){
                    AreaItem *item = [[AreaItem alloc] initWithDictionary:subDic];
                    [_dataArray addObject:item];
                }
                [_tableView reloadData];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [RemindView showViewWithTitle:@"网络错误" location:MIDDLE];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray  count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    AreaItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kWidth, 1)];
    lineView.backgroundColor = HexRGB(0xd5d5d5);
    [cell.contentView addSubview:lineView];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AreaItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectCity:withId:)]) {
        [self.delegate selectCity:item.name withId:item.uid];
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

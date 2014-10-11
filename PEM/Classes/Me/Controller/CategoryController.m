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
#import "TKRoundedView.h"

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
    self.title = @"选择行业";
    _dataArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10,kWidth,kHeight-69-10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    [self getData];
}

- (void)getData{
    [HttpTool postWithPath:@"getCategoryList" params:nil success:^(id JSON) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"response"]];
        for (NSDictionary *subDic in array) {
            CategoryItem *item = [[CategoryItem alloc] initWithDic:subDic];
            [_dataArray addObject:item];
        }
        [_tableView reloadData];
        } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    CGRect frame = CGRectMake(20, 0,kWidth-20*2, cell.frame.size.height);
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    if (indexPath.row == 0){
        TKRoundedView *topView = [[TKRoundedView alloc] initWithFrame:frame];
        topView.roundedCorners = TKRoundedCornerTopLeft | TKRoundedCornerTopRight;
        topView.drawnBordersSides = TKDrawnBorderSidesAll;
        topView.borderColor = HexRGB(0xd5d5d5);
        topView.borderWidth = 1.0f;
        topView.cornerRadius = 6.0;
        [cell.contentView addSubview:topView];
    }else if(indexPath.row < [_dataArray count]-1){
        TKRoundedView *topView = [[TKRoundedView alloc] initWithFrame:frame];
        topView.roundedCorners = TKRoundedCornerNone;
        topView.drawnBordersSides = TKDrawnBorderSidesRight|TKDrawnBorderSidesLeft|TKDrawnBorderSidesBottom;
        topView.borderColor = HexRGB(0xd5d5d5);
        topView.borderWidth = 1.0f;
        topView.cornerRadius = 6.0;
        [cell.contentView addSubview:topView];
    }else if(indexPath.row == [_dataArray count]-1){
        TKRoundedView *bottomView = [[TKRoundedView alloc] initWithFrame:frame];
        bottomView.roundedCorners = TKRoundedCornerBottomLeft | TKRoundedCornerBottomRight;
        bottomView.drawnBordersSides = TKDrawnBorderSidesRight|TKDrawnBorderSidesLeft|TKDrawnBorderSidesBottom;
        bottomView.borderColor = HexRGB(0xd5d5d5);
        bottomView.borderWidth = 1.0f;
        bottomView.cornerRadius = 6.0;
        [cell.contentView addSubview:bottomView];
    }
    
    CategoryItem *item = [_dataArray objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40,0, 200,frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = item.name;
    [cell.contentView addSubview:label];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryItem *item = [_dataArray objectAtIndex:indexPath.row];
    if (_isSupply){
        if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
            [self.delegate sendValueFromViewController:self value:item isDemand:NO];
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:SUPPLY_DATA object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:item,@"categoryItem", nil]];
    }else{
        if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
            [self.delegate sendValueFromViewController:self value:item isDemand:YES];
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:PURCHASE_DATA object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:item,@"categoryItem", nil]];
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

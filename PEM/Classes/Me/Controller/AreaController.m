//
//  AreaController.m
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "AreaController.h"
#import "HttpTool.h"
#import "FileManager.h"
#import "AreaItem.h"

@interface AreaController ()

@end

@implementation AreaController

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
    self.title = @"选择区域";
    self.view.backgroundColor = HexRGB(0xffffff);
    _dataArray = [[NSMutableArray alloc] init];
    _provinceArray = [[NSMutableArray alloc] init];
    _cityArray = [[NSMutableArray alloc] initWithCapacity:0];
    //左边省份
    _provinceTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150,kHeight-64) style:UITableViewStylePlain];
    _provinceTabelView.delegate = self;
    _provinceTabelView.tag = 2000;
    _provinceTabelView.dataSource = self;
    _provinceTabelView.showsVerticalScrollIndicator = NO;
    _provinceTabelView.showsHorizontalScrollIndicator = NO;
    _provinceTabelView.backgroundColor = [UIColor clearColor];
    _provinceTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _provinceTabelView.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:_provinceTabelView];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(150,0, 1, kHeight-64)];
    line.backgroundColor = HexRGB(0xd5d5d5);
    [self.view addSubview:line];
    //右边城市
    _cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(151,0,kWidth-151,kHeight-64) style:UITableViewStylePlain];
    _cityTableView.delegate = self;
    _cityTableView.tag = 2001;
    _cityTableView.backgroundColor = HexRGB(0xf2f2f2);
    _cityTableView.dataSource = self;
    _cityTableView.showsVerticalScrollIndicator = NO;
    _cityTableView.showsHorizontalScrollIndicator = NO;
    _cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cityTableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_cityTableView];
    [self getProvinceData];
}

- (void)getProvinceData{
    if ([FileManager fileExistName:@"provinces" withType:CacheType]){
        NSArray *array = [FileManager readArrayFromFileName:@"provinces" withType:CacheType];
        for (NSDictionary *dic in array) {
            AreaItem *item = [[AreaItem alloc] initWithDictionary:dic];
            [_provinceArray addObject:item];
        }
        [_provinceTabelView reloadData];
        AreaItem *item = [_provinceArray objectAtIndex:0];
        provinceName = item.name;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_provinceTabelView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self getCityData:item.uid];

    }else{
        [HttpTool postWithPath:@"getProvinceList" params:nil success:^(id JSON) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            if (dic) {
                if ([[dic objectForKey:@"code"] intValue] == 100) {
                    
                    NSArray *data = [dic objectForKey:@"data"];
                    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
                    for (NSDictionary *subDic in data){
                        AreaItem *item = [[AreaItem alloc] initWithDictionary:subDic];
                        [_provinceArray addObject:item];
                        [mutableArray addObject:subDic];
                    }
                    //加入缓存
                    NSArray *arr = [NSArray arrayWithArray:[mutableArray copy]];
                    [FileManager writeArray:arr toFile:@"provinces" withType:CacheType];
                    [_provinceTabelView reloadData];
                    
                    AreaItem *item = [_provinceArray objectAtIndex:0];
                    provinceName = item.name;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_provinceTabelView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
                    NSString *uid = item.uid;
                    [self getCityData:uid];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

- (void)getCityData:(NSString *)uid
{
    if ([_cityArray count]!=0) {
        [_cityArray removeAllObjects];
    }
    NSString *path = [NSString stringWithFormat:@"citys_%@",uid];
    if ([FileManager fileExistName:path withType:CacheType]){
        NSArray *array = [FileManager readArrayFromFileName:path withType:CacheType];
        for (NSDictionary *dic in array) {
            AreaItem *item = [[AreaItem alloc] initWithDictionary:dic];
            [_cityArray addObject:item];
        }
        [_cityTableView reloadData];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"province", nil];
        [HttpTool postWithPath:@"getCityList" params:param success:^(id JSON) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:JSON options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic = [result objectForKey:@"response"];
            if (dic) {
                if ([[dic objectForKey:@"code"] intValue] == 100) {
                    NSArray *data = [dic objectForKey:@"data"];
                    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:0];
                    if (_cityArray.count!=0) {
                        [_cityArray removeAllObjects];
                    }

                    for (NSDictionary *subDic in data){
                        AreaItem *item = [[AreaItem alloc] initWithDictionary:subDic];
                        [_cityArray addObject:item];
                        [mutableArray addObject:subDic];
                    }
                    //加入缓存
                    NSArray *arr = [NSArray arrayWithArray:[mutableArray copy]];
                    [FileManager writeArray:arr toFile:path withType:CacheType];
                    [_cityTableView reloadData];
                }
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"%@",error);
        }];
    }
 }

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.contentSize.height-scrollView.frame.size.height>0) {
        if (scrollView.contentOffset.y>scrollView.contentSize.height-scrollView.frame.size.height) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height);
        }
    }else{
        if (scrollView.contentOffset.y>0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
    }
}


#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 2000) {
        return [_provinceArray count];
    }
    return [_cityArray count];
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
        AreaItem *item = [_provinceArray objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = HexRGB(0x3a3a3a);
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,2, cell.frame.size.height)];
        leftView.backgroundColor = HexRGB(0x069dd4);
        bgView.backgroundColor = HexRGB(0xe5e5e5);
        [bgView addSubview:leftView];
        cell.selectedBackgroundView = bgView;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,44,150,1)];
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
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,39,kWidth-151,1)];
        line.backgroundColor = HexRGB(0xd5d5d5);
        [cell.contentView addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AreaItem *item = [_cityArray objectAtIndex:indexPath.row];
        cell.textLabel.text = item.name;
        cell.textLabel.textColor = HexRGB(0x808080);
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.backgroundColor = HexRGB(0xf2f2f2);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2000) {
        return 40;
    }
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 2000) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = YES;
        AreaItem *item = [_provinceArray objectAtIndex:indexPath.row];
        provinceName = item.name;
        [self getCityData:item.uid];
    }else{
        AreaItem *item = [_cityArray objectAtIndex:indexPath.row];
        NSString *cityName = item.name;
        NSString *area = [NSString stringWithFormat:@"%@ %@",provinceName,cityName];
        if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
            [self.delegate sendValueFromViewController:self value:area isDemand:NO];
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

//
//  AreaController.m
//  PEM
//
//  Created by tianj on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "AreaController.h"

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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"provineces" ofType:@"plist"];
    NSArray *data = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    for (NSDictionary *dic in data){
        NSString *strProvince = [dic objectForKey:@"name"];
        [_provinceArray addObject:strProvince];
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kWidth,kHeight-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    if ([CLLocationManager locationServicesEnabled]) {
        _currentLocation = [[CLLocationManager alloc] init];
        _currentLocation.delegate = self;
        [_currentLocation startUpdatingLocation];
    }else{
        //不允许定位操作  显示出所有省份
        [_dataArray addObjectsFromArray:_provinceArray];
        [_tableView reloadData];
    }
}


#pragma mark LocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"locError:%@",error);
    //定位失败   显示所有省份
    [_dataArray addObjectsFromArray:_provinceArray];
    [_tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placeMark = [placemarks objectAtIndex:0];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [array addObject:placeMark.administrativeArea];
        for (NSString *province in _provinceArray) {
            if (![[array objectAtIndex:0] isEqualToString:province]) {
                [arr addObject:province];
            }
        }
        [_dataArray addObject:array];
        [_dataArray addObject:arr];
        titleArray = [NSArray arrayWithObjects:@"当前地区",@"其他地区", nil];
        [_tableView reloadData];
    }];
    [_currentLocation stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:oldLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placeMark = [placemarks objectAtIndex:0];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [array addObject:placeMark.administrativeArea];
        for (NSString *province in _provinceArray) {
            if (![[array objectAtIndex:0] isEqualToString:province]) {
                [arr addObject:province];
            }
        }
        [_dataArray addObject:array];
        [_dataArray addObject:arr];
        titleArray = [NSArray arrayWithObjects:@"当前地区",@"其他地区", nil];
        [_tableView reloadData];
    }];
    [_currentLocation stopUpdatingLocation];
}

#pragma mark tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (titleArray.count==0) {
        return 0;
    }
    return [[_dataArray objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    if (titleArray.count == 1) {
        cell.detailTextLabel.text= [_dataArray objectAtIndex:indexPath.row];
    }else{
        cell.detailTextLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,cell.frame.size.height-1, kWidth, 1)];
    lineView.backgroundColor = HexRGB(0xd5d5d5);
    [cell.contentView addSubview:lineView];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [titleArray objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str;
    if (titleArray.count == 1) {
        str = [_dataArray objectAtIndex:indexPath.row];

    }else{
        str = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    if ([self.delegate respondsToSelector:@selector(sendValueFromViewController:value:isDemand:)]) {
        [self.delegate sendValueFromViewController:self value:str isDemand:NO];
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

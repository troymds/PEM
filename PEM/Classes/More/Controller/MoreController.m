//
//  MoreController.m
//  新浪微博
//
//  Created by apple on 13-10-27.
//  Copyright (c) 2013年 itcast. All rights reserved.
//






#pragma mark 这个类只用在MoreController
@interface LogutBtn : UIButton
@end

@implementation LogutBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}
@end

#import "MoreController.h"
#import "UIImage+MJ.h"
#import "GroupCell.h"

@interface MoreController ()
{
    NSArray *_data;
}
@end

@implementation MoreController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1.搭建UI界面
    [self buildUI];
    
    // 2.读取plist文件的内容
    [self loadPlist];
    
    // 3.设置tableView属性
    [self buildTableView];
}

#pragma mark 设置tableView属性
- (void)buildTableView
{
    // 32bit颜色 ARGB
    // 24bit颜色 RGB
    // 255/255
    
    //#ffffff
    // #ffffff
    
    // 1.设置背景
    // backgroundView的优先级 > backgroundColor
    self.tableView.backgroundView = nil;
//    // 0~1
    self.tableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    // 2.设置tableView每组头部的高度
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    
    // 3.要在tableView底部添加一个按钮
    LogutBtn *logout = [LogutBtn buttonWithType:UIButtonTypeCustom];
    // 设置背景图片
    [logout setImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [logout setImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    // tableFooterView的宽度是不需要设置。默认就是整个tableView的宽度
    logout.bounds = CGRectMake(0, 0, 0, 44);
    
    // 4.设置按钮文字
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    
//    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.tableFooterView = logout;
    
    // 增加底部额外的滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _data.count - 1) {
        return 10;
    }
    return 0;
}

#pragma mark 读取plist文件的内容
- (void)loadPlist
{
    // 1.获得路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"];
    
    // 2.读取数据
    _data = [NSArray arrayWithContentsOfURL:url];
}

#pragma mark 搭建UI界面
- (void)buildUI
{
    // 1.设置标题
    self.title = @"更多";
    // 2.设置右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSArray *array = _data[section];
//    
//    return array.count;
    
    return [_data[section] count];
}

#pragma mark 每当有一个新的cell进入屏幕视野范围内就会调用
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // forIndexPath:indexPath 跟 storyboard配套使用的
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // 设置cell所在的tableView
        cell.myTableView = tableView;
    }
    
    // 1.取出这行对应的字典数据
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    
    // 2.设置文字
    cell.textLabel.text = dict[@"name"];
    
    // 3.设置cell的背景
    cell.indexPath = indexPath;
    
    // 4.设置cell的类型（设置右边显示什么东西）
    if (indexPath.section == 2) {
        cell.cellType = kCellTypeLabel;
        cell.rightLabel.text = indexPath.row?@"有图模式":@"经典主题";
//    } else if (indexPath.section == 4) {
//        cell.cellType = kCellTypeNone;
//    } else if (indexPath.section == 0) {
//        cell.cellType = kCellTypeSwitch;
    } else {
        cell.cellType = kCellTypeArrow;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

//
//  GroupCell.h
//  新浪微博
//
//  Created by apple on 13-10-29.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kCellTypeNone, // 没有样式
    kCellTypeArrow, // 箭头
    kCellTypeLabel, // 文字
    kCellTypeSwitch // 开关
} CellType;

@interface GroupCell : UITableViewCell
@property (nonatomic, readonly) UISwitch *rightSwitch; // 右边的switch控件
@property (nonatomic, readonly) UILabel *rightLabel; // 右边的文字标签

@property (nonatomic, assign) CellType cellType;  // cell的类型
@property (nonatomic, weak) UITableView *myTableView; // 所在的表格
@property (nonatomic, strong) NSIndexPath *indexPath; // 所在的行号
@end

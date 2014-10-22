//
//  HotTagsController.h
//  PEM
//
//  Created by tianj on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendValueDelegate.h"

@interface HotTagsController : UIViewController<UITextFieldDelegate>
{
    NSMutableArray *_dataArray;       //所有标签
    UILabel *addTagLabel;
    UITextField *addField;
    UIButton *addBtn;
    NSInteger space;        //标签按钮之间的空格
    CGFloat x;               //添加标签时按钮的x坐标
    NSInteger currentRow;    //最后一个标签当前显示的行数  0开始
    NSInteger current_count;  //当前添加的标签数
    NSInteger max_count;     //添加的最大标签数
    
    UIView *bottomView;
    BOOL isEditing;        //判断是否在编辑状态 即键盘在不在界面上
}

@property (nonatomic,strong) NSMutableArray *tagArray;    //选中标签
@property (nonatomic,weak) id <SendValueDelegate> delegate;

@end

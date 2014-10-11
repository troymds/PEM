//
//  SubscribController.h
//  PEM
//
//  Created by tianj on 14-8-29.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTagButton.h"


@interface SubscribController : UIViewController<UITextFieldDelegate,ProImageViewDelegate>
{
    NSMutableArray *_dataArray;
    UITextField *addField;
    UIButton *addBtn;
    NSInteger space;        //标签按钮之间的空格
    CGFloat x;               //button的x坐标
    NSInteger currentRow;    //button显示在第几行
    UILabel *remindLabel;
    NSMutableArray *_allTagArray;    //页面所有标签的数组
    long _maxNum;        //最多可订阅标签数
    
    NSInteger _currentCount;     
    
    BOOL _isDelete;           //当前管理是否处于删除状态
    
    UIView *bottomView;        //用于再添加button时移动下面的输入框和按钮
    
    UIScrollView *_scrollView;
    
    UITapGestureRecognizer *tap;
    
    CGPoint contentOffset;
    
    BOOL isKeyboardShow;      //判断键盘是否在页面上出现
    
    NSInteger bottomSpace;     //_scrollView底下空白高度
}
@end

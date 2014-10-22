//
//  BuyTagController.h
//  PEM
//
//  Created by tianj on 14-10-14.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubTagButton.h"


@interface BuyTagController : UIViewController<UITextFieldDelegate,ProImageViewDelegate>
{
    UIScrollView *_scrollView;
    UITextField *addField;
    UIButton *addBtn;
    UIView *bottomView;        //用于再添加button时移动下面的输入框和按钮
    BOOL _isDelete;           //当前管理是否处于删除状态
    
    NSInteger _currentCount;
    
    NSInteger space;        //标签按钮之间的空格
    CGFloat x;               //button的x坐标
    NSInteger currentRow;    //button显示在第几行
    NSInteger bottomSpace;     //_scrollView底下空白高度
    NSMutableArray *_allTagArray;    //页面所有标签的数组

    UITapGestureRecognizer *tap;

    CGPoint contentOffset;

    BOOL isKeyboardShow;
}
@end

//
//  AdviceController.h
//  PEM
//
//  Created by tianj on 14-9-12.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviceController : UIViewController<UITextViewDelegate>
{
    UITextView *_textView;
    UIButton *_button;
    BOOL isEdit;   //判断是否进行了编辑
}

@end

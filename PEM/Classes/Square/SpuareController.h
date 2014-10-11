//
//  SpuareController.h
//  PEM
//
//  Created by jch on 14-8-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "Square.h"
#import "SettingController.h"



@interface SpuareController : UIViewController<HeaderViewDelegate,UIScrollViewDelegate,SquareDelegate>
{
    UIScrollView *_scrollView;
    HeaderView *_headView;
    Square *_squareView;
}


@end

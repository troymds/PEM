//
//  MessageController.h
//  PEM
//
//  Created by YY on 14-8-21.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeControllerDelegate.h"



@interface MessageController : UIViewController
{

    int currentTag;
    NSString *currStr;
    Boolean catClickFlage;

}

@property(nonatomic,assign)id <ChangeControllerDelegate> delegate;

@end

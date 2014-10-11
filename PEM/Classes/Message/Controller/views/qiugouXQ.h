//
//  qiugouXQ.h
//  PEM
//
//  Created by YY on 14-8-28.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qiugouXQ : UIViewController{
    UIWebView* demandWebView ;
}
@property(nonatomic ,weak)NSString *demandIndex;
@property(nonatomic ,strong)NSMutableArray *demandArray;

@end

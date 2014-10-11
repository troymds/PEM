//
//  comditionController.h
//  PEM
//
//  Created by YY on 14-9-10.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface comditionController : UIViewController
{
    UIScrollView *_backScrollView;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UILabel *_readLabel;
    UILabel *_contentLabel;
    UIImageView *_companyImage;
    
}
@property(nonatomic,retain)UIScrollView *backScrollView;
@property(nonatomic,copy)UILabel *titleLabel;
@property(nonatomic,copy)UILabel *dateLabel;
@property(nonatomic,copy)UILabel *readLabel;
@property(nonatomic,retain)UIImageView *companyImage;
@property(nonatomic,copy)UILabel *contentLabel;
@property(nonatomic,copy)NSString *companyIndex;

@end

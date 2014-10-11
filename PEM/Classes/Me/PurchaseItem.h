//
//  PurchaseItem.h
//  PEM
//
//  Created by tianj on 14-8-25.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryItem.h"
@interface PurchaseItem : NSObject


@property (nonatomic,retain) CategoryItem *categoryItem;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *purchaseNum;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *linkMan;
@property (nonatomic,copy) NSString *phoneNum;
@property (nonatomic,copy) NSMutableArray *tagArray;
@property (nonatomic,copy) NSString *unit;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end

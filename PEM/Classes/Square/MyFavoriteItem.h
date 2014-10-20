//
//  MyFavoriteItem.h
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFavoriteItem : NSObject

@property (nonatomic,copy) NSString *collectTimes;
@property (nonatomic,copy) NSString *collect_num;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *info_id;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *img;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

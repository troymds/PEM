//
//  demandCOM.h
//  PEM
//
//  Created by YY on 14-9-20.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface demandCOM : NSObject
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *read_num;
@property (nonatomic,copy) NSString *buy_num;

@property (nonatomic,copy) NSString *name;



- (id)initWithDictonary:(NSDictionary *)dic;

@end

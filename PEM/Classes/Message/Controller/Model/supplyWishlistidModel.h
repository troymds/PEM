//
//  supplyWishlistidModel.h
//  PEM
//
//  Created by YY on 14-9-30.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface supplyWishlistidModel : NSObject
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *wishlistId;



- (id)initWithDictonary:(NSDictionary *)dic;

@end

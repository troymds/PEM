//
//  activeModel.h
//  PEM
//
//  Created by YY on 14-11-17.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activeModel : NSObject<NSCoding>
@property(nonatomic,copy)NSString *leftActiveImgage;
@property(nonatomic,copy)NSString *rightActiveImgage;
@property(nonatomic,copy)NSString *bottomActiveImgage;

@property(nonatomic,copy)NSString *leftActiveType;
@property(nonatomic,copy)NSString *rightActiveType;
@property(nonatomic,copy)NSString *bottomActiveType;

@property(nonatomic,copy)NSString *leftActiveContent;
@property(nonatomic,copy)NSString *rightActiveContent;
@property(nonatomic,copy)NSString *bottomActiveContent;




@end

//
//  adsModel.h
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface adsModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *idType;
@property (nonatomic, copy) NSString *srcImage;
@property (nonatomic, copy) NSString *content;


-(instancetype)initWithDictionaryForAds:(NSDictionary *)dict;
@end

//
//  VipInfoItem.h
//  PEM
//
//  Created by tianj on 14-10-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VipInfoItem : NSObject

@property (nonatomic,copy) NSString *display_3d_num;
@property (nonatomic,copy) NSString *keywords_num;
@property (nonatomic,copy) NSString *supply_num;
@property (nonatomic,copy) NSString *tag_num;
@property (nonatomic,copy) NSString *try_date;
@property (nonatomic,copy) NSString *vip_date;
@property (nonatomic,copy) NSString *vip_name;
@property (nonatomic,copy) NSString *vip_type;
@property (nonatomic,copy) NSString *wap_url;

- (id)initWithDictionary:(NSDictionary *)dic;


@end

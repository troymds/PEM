//
//  VipInfoItem.m
//  PEM
//
//  Created by tianj on 14-10-13.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "VipInfoItem.h"

@implementation VipInfoItem



- (id)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        _display_3d_num = [dic objectForKey:@"display_3d_num"];
        _keywords_num = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"keywords_num"] intValue]];
        _supply_num = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"supply_num"] intValue]];
        _tag_num = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"tag_num"] intValue]];
        _try_date = [NSString stringWithFormat:@"%d",[[dic objectForKey:@""] intValue]];
        _vip_date = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"vip_date"] intValue]];
        _vip_name = [dic objectForKey:@"vip_name"];
        _vip_type = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"vip_type"] intValue]];
        _wap_url = [dic objectForKey:@"wap_url"];
    }
    return self;
}

@end

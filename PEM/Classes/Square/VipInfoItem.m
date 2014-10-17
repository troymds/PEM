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
        if (isNull(dic, @"display_3d_num")) {
            _display_3d_num = @"-1";
        }else{
            _display_3d_num = [dic objectForKey:@"display_3d_num"];
        }
        if (isNull(dic, @"keywords_num")) {
            _keywords_num = @"-1";
        }else{
            _keywords_num = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"keywords_num"] intValue]];
        }
        if (isNull(dic,@"supply_num")) {
            _supply_num = @"-1";
        }else{
            _supply_num = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"supply_num"] intValue]];
        }
        if (isNull(dic, @"tag_num")) {
            _tag_num = @"-1";
        }else{
            _tag_num = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"tag_num"] intValue]];
        }
        if (isNull(dic, @"try_date")) {
            
        }else{
            _try_date = [NSString stringWithFormat:@"%d",[[dic objectForKey:@""] intValue]];
        }
        if (isNull(dic, @"vip_date")) {
            _vip_date = @"0";
        }else{
            _vip_date = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"vip_date"] intValue]];
        }
        if (isNull(dic, @"vip_name")) {
            _vip_name = @"";
        }else{
            _vip_name = [dic objectForKey:@"vip_name"];
        }
        if (isNull(dic, @"vip_type")) {
            _vip_type = @"-3";
        }else{
            _vip_type = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"vip_type"] intValue]];
        }
        if (isNull(dic, @"wap_url")) {
            _wap_url = @"";
        }else{
            _wap_url = [dic objectForKey:@"wap_url"];
        }
        
    }
    return self;
}

@end

//
//  XQgetInfoDetailModel.m
//  PEM
//
//  Created by YY on 14-9-15.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "XQgetInfoDetailModel.h"
#import "HttpTool.h"
@implementation XQgetInfoDetailModel
@synthesize idType,description,company_id,company_name,info_id,buy_num,imageGetInfo,titleGetInfo,create_time,contacts,phone_num,region,url_3d,price,min_sell_num,inwishlist,read_num,category_id,verify_result,verify_reason,verify_time,vip_type;
@synthesize wishlistid;
- (instancetype)initWithDictionaryForGategory:(NSDictionary *)dict{
    if ([super self])
    {
        self.vip_type = dict[@"vip_type"];

        self.idType = dict[@"type"];
        self.buy_num =dict[@"buy_num"];
        self.company_id = dict[@"company_id"];
        self.info_id = dict[@"info_id"];
        
        self.imageGetInfo = dict[@"image"];
        
        self.titleGetInfo = dict[@"title"];
        self.create_time = dict[@"create_time"];

        self.contacts = dict[@"contacts"];
        
        self.phone_num = dict[@"phone_num"];
        self.region = dict[@"region"];
        
        self.url_3d = dict[@"url_3d"];
        self.price = dict[@"price"];
        self.min_sell_num = dict[@"min_sell_num"];
        self.inwishlist = dict[@"inwishlist"];

        self.xqinwishlist = [NSString stringWithFormat:@"%d",[dict[@"inwishlist"] intValue]] ;
        self.read_num = dict[@"read_num"];
        self.category_id = dict[@"category_id"];
        
        self.description = dict[@"ios_wap_url"];
        
        self.company_name = dict[@"company_name"];
        
        self.verify_time = dict[@"verify_time"];
        self.verify_result = dict[@"verify_result"];
        self.verify_reason = dict[@"verify_reason"];
        self.wishlistid = dict[@"wishlist_id"];

    }
    
    return self;
}

@end

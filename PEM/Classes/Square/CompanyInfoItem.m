
//
//  CompanyInfoItem.m
//  PEM
//
//  Created by tianj on 14-9-11.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "CompanyInfoItem.h"

@implementation CompanyInfoItem


- (id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]){
        if ([[dic objectForKey:@"address"] isKindOfClass:[NSNull class]]){
            _address = @"";
        }else{
            _address = [dic objectForKey:@"address"];
        }
        if ([[dic objectForKey:@"city_id"] isKindOfClass:[NSNull class]]) {
            _city_id = @"-1";
        }else{
            int city_id = [[dic objectForKey:@"city_id"] intValue];
            _city_id = [NSString stringWithFormat:@"%d",city_id];
        }
        if ([[dic objectForKey:@"city_name"] isKindOfClass:[NSNull class]]) {
            _city_name = @"";
        }else{
            _city_name = [dic objectForKey:@"city_name"];
        }
        if ([[dic objectForKey:@"company_id"] isKindOfClass:[NSNull class]]) {
            _company_id = @"-1";
        }else{
            int company_id = [[dic objectForKey:@"company_id"] intValue];
            _company_id = [NSString stringWithFormat:@"%d",company_id];
        }
        
        if ([[dic objectForKey:@"company_name"] isKindOfClass:[NSNull class]]) {
            _company_name = @"";
        }else{
            _company_name = [dic objectForKey:@"company_name"];
        }
        
        if ([[dic objectForKey:@"company_tel"] isKindOfClass:[NSNull class]]) {
            _company_tel = @"";
        }else{
            _company_tel = [dic objectForKey:@"company_tel"];
        }
        
        if ([[dic objectForKey:@"email"] isKindOfClass:[NSNull class]]) {
            _email = @"";
        }else{
            _email = [dic objectForKey:@"email"];
        }
        
        if ([[dic objectForKey:@"image"] isKindOfClass:[NSNull class]]) {
            _image = @"";
        }else{
            _image = [dic objectForKey:@"image"];
        }
        if ([[dic objectForKey:@"is_lock"] isKindOfClass:[NSNull class]]) {
            _is_lock = @"-2";
        }else{
            int is_lock = [[dic objectForKey:@"is_lock"] intValue];
            _is_lock = [NSString stringWithFormat:@"%d",is_lock];
        }
        if ([[dic objectForKey:@"province_id"] isKindOfClass:[NSNull class]]) {
            _province_id = @"-1";
        }else{
            int province_id = [[dic objectForKey:@"province_id"] intValue];
            _province_id = [NSString stringWithFormat:@"%d",province_id];
        }
        if ([[dic objectForKey:@"province_name"] isKindOfClass:[NSNull class]]) {
            _province_name = @"";
        }else{
            _province_name = [dic objectForKey:@"province_name"];
        }
        
        if ([[dic objectForKey:@"website"] isKindOfClass:[NSNull class]]) {
            _website = @"";
        }else{
            _website = [dic objectForKey:@"website"];
        }                
    }
    return self;
}







@end

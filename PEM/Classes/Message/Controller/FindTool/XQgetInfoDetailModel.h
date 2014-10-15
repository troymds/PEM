//
//  XQgetInfoDetailModel.h
//  PEM
//
//  Created by YY on 14-9-15.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XQgetInfoDetailModel : NSObject
#pragma mark----supply Demand
@property (nonatomic, copy) NSString *vip_type;   //

@property (nonatomic, copy) NSString *idType;   //信息 id
@property (nonatomic, copy) NSString *info_id;   //供应还是求购
@property (nonatomic, copy) NSString *imageGetInfo;//图片地址
@property (nonatomic, copy) NSString *titleGetInfo ;//标题
@property (nonatomic, copy) NSString *create_time;//创建时间
@property (nonatomic, copy) NSString *company_id ;//发布公司 id
@property (nonatomic, copy) NSString *contacts;//联系人姓名
@property (nonatomic, copy) NSString *phone_num ;//联系人手机号
@property (nonatomic, copy) NSString *region;//所在地
@property (nonatomic, copy) NSString *url_3d ;//3d 加载地址
@property (nonatomic, copy) NSString *price;//价格
@property (nonatomic, copy) NSString *min_sell_num ;//起售标准
@property (nonatomic, copy) NSString *inwishlist ;//是否加入收藏
@property (nonatomic, copy) NSString *xqinwishlist ;//是否加入收藏

@property (nonatomic, copy) NSString *read_num ;//查看次数
@property (nonatomic, copy) NSString *buy_num ;//查看次数

@property (nonatomic, copy) NSString *category_id ;//分类 id

@property (nonatomic, copy) NSString *description;//内容
@property (nonatomic, copy) NSString *company_name;//公司名字
@property (nonatomic, copy) NSString *verify_time ;//审核时间

@property (nonatomic, copy) NSString *verify_result;//审核结果
@property (nonatomic, copy) NSString *verify_reason;//审核原因

@property(nonatomic,copy)NSString *wishlistid;
- (instancetype)initWithDictionaryForGategory:(NSDictionary *)dict;

@end

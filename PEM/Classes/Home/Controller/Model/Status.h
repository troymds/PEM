

#import <Foundation/Foundation.h>
@interface Status : NSObject

//广告部分 ==> 今日数据 ==> 热门分类 ==> 热门供应 ==> 热门求购 ==> 最新版本 ==> 消息数量


@property (nonatomic, retain)NSArray        *adsArray;
@property (nonatomic, retain)NSArray        *hotCategoryArray;
@property (nonatomic, retain)NSArray        *hotDemandArray;
@property (nonatomic, retain)NSArray        *hotSupplyArray;
@property (nonatomic, retain)NSDictionary   *todayNumDictionary;
- (id)initWithDict:(NSDictionary *)dict;
@end
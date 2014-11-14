

#import "Status.h"

@implementation Status
@synthesize adsArray,hotCategoryArray,hotDemandArray,hotSupplyArray,todayNumDictionary,activeArray ;


- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {

        adsArray = dict[@"ads"];

        hotCategoryArray = dict[@"hot_category"];
        hotDemandArray = dict[@"hot_demand"];
        hotSupplyArray = dict[@"hot_supply"];
        todayNumDictionary = dict[@"today_num"];
        todayNumDictionary = dict[@"today_num"];
        activeArray = dict[@"active"];
        
    }
    return self;
}

@end
                      
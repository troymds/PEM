//
//  yyDemandModel.m
//  PEM
//
//  Created by YY on 14-9-4.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "yyDemandModel.h"

@implementation yyDemandModel
@synthesize demandid,name,read_num,Introduction,demandDate,buy_num;

- (instancetype)initWithDictionaryFordemand:(NSDictionary *)dict
{
    if ([super self])
    {
        self.demandid = dict[@"id"];
        self.demandDate = dict[@"date"];
        self.read_num=dict[@"read_num"];
        self.buy_num=dict[@"buy_num"];
        self.Introduction=dict[@"introduction"];
        
        self.name=dict[@"name"];
        
    }
    
    return self;
}
- (NSString *)createdAt
{
    // Sat Nov 02 15:08:27 +0800 2013
    //    MyLog(@"%@", _createdAt);
    // 1.将新浪时间字符串转为NSDate对象
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd zzzz yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [fmt dateFromString:demandDate];
    
    // 2.获得当前时间
//    NSDate *now = [NSDate date];
    
    // 3.获得当前时间和微博发送时间的间隔（差多少秒）
//    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    // 4.根据时间间隔算出合理的字符串
//    if (delta < 60) { // 1分钟内
//        return @"刚刚";
//    } else if (delta < 60 * 60) { // 1小时内
//        return [NSString stringWithFormat:@"%.f分钟前", delta/60];
//    } else if (delta < 60 * 60 * 24) { // 1天内
//        return [NSString stringWithFormat:@"%.f小时前", delta/60/60];
//    } else {
        fmt.dateFormat = @"MM-dd ";
        return [fmt stringFromDate:date ];
//    }
}
- (void)setSource:(NSString *)source
{
    //    MyLog(@"setSource");
    // <a href="http://app.weibo.com/t/feed/2qiXeb" rel="nofollow">好保姆</a>
    //    MyLog(@"%@", _source);
    
    float begin = [source rangeOfString:@">"].location + 1;
    float end = [source rangeOfString:@"</"].location;
    
    Introduction = [NSString stringWithFormat:@"来自%@", [source substringWithRange:NSMakeRange(begin, end - begin)]];
}

@end

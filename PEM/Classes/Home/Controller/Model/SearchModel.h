//
//  SearchResultModel.h
//  PEM
//
//  Created by house365 on 14-9-22.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

{
    NSString *_resultId;           // 搜索结果的id
    NSString *_name;               // 搜索结果的名称
}

@property (nonatomic, copy) NSString *resultId;
@property (nonatomic, copy) NSString *name;

- (id)initDictionary:(NSDictionary *)dict;

@end

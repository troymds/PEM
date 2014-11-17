//
//  activeModel.m
//  PEM
//
//  Created by YY on 14-11-17.
//  Copyright (c) 2014年 ___普尔摩___. All rights reserved.
//

#import "activeModel.h"

@implementation activeModel
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.leftActiveContent forKey:@"content"];
    [coder encodeObject:self.leftActiveImgage forKey:@"image"];
    [coder encodeObject:self.leftActiveType forKey:@"type"];
    
    [coder encodeObject:self.rightActiveContent forKey:@"content"];
    [coder encodeObject:self.rightActiveImgage forKey:@"image"];
    [coder encodeObject:self.rightActiveType forKey:@"type"];
    
    [coder encodeObject:self.leftActiveContent forKey:@"content"];
    [coder encodeObject:self.leftActiveImgage forKey:@"image"];
    [coder encodeObject:self.leftActiveType forKey:@"type"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.leftActiveContent =  [coder decodeObjectForKey:@"content"];
        self.leftActiveImgage =  [coder decodeObjectForKey:@"image"];
        self.leftActiveType =  [coder decodeObjectForKey:@"type"];
        
        self.rightActiveContent =  [coder decodeObjectForKey:@"content"];
        self.rightActiveImgage =  [coder decodeObjectForKey:@"image"];
        self.rightActiveType =  [coder decodeObjectForKey:@"type"];
        
        self.bottomActiveContent =  [coder decodeObjectForKey:@"content"];
        self.bottomActiveImgage =  [coder decodeObjectForKey:@"image"];
        self.bottomActiveType =  [coder decodeObjectForKey:@"type"];
            }
    return self;
}


@end

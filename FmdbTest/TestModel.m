//
//  FMDBViewController.m
//  FmdbTest
//
//  Created by hlq on 16/3/5.
//  Copyright © 2016年 ustb All rights reserved.
//

#import "TestModel.h"

@interface TestModel ()<NSCoding>

@end

@implementation TestModel
- (NSString *)keyString
{
    return @"FMDBKeyString";
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.str forKey:@"str"];

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.str = [aDecoder decodeObjectForKey:@"str"];
    }
    return self;
}
@end

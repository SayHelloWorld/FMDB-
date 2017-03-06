//
//  FMDBViewController.m
//  FmdbTest
//
//  Created by hlq on 16/3/5.
//  Copyright © 2016年 ustb All rights reserved.
//

#import "NSObject+CustomFMDB.h"

@implementation NSObject (CustomFMDB)

- (void)didInserIntoDB{}
- (void)didUpDataDB{}
- (void)didDeleteDB{}
- (void)didSeleteResult{}


//键值
- (NSString *)keyString {
    return @"id";
}
@end

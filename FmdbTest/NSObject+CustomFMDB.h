//
//  FMDBViewController.m
//  FmdbTest
//
//  Created by hlq on 16/3/5.
//  Copyright © 2016年 ustb All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@interface NSObject (CustomFMDB)
- (void)didInserIntoDB;
- (void)didUpDataDB;
- (void)didDeleteDB;
- (void)didSeleteResult;

//键值
- (NSString *)keyString;
@end

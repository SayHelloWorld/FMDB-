//
//  FMDBViewController.m
//  FmdbTest
//
//  Created by hlq on 16/3/5.
//  Copyright © 2016年 ustb All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBHelper : NSObject
+ (instancetype)shareFMDBHelper;
//插入数据库
- (BOOL)insertDB:(NSObject *)model withKey:(NSString *)key;
//更新
- (BOOL)updataDB:(NSObject *)model withKey:(NSString *)key;
//删除
- (BOOL)deleteDB:(Class)tableName WithKey:(NSString *)key;
//查询
- (NSArray *)selectTable:(Class)tableName where:(NSString *)keyStr;
@end

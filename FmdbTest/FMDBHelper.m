//
//  FMDBViewController.m
//  FmdbTest
//
//  Created by hlq on 16/3/5.
//  Copyright © 2016年 ustb All rights reserved.
//

#import "FMDBHelper.h"
#import "NSObject+CustomFMDB.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
static NSString * DBPatch;

@interface FMDBHelper ()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property (nonatomic, strong) FMDatabase *db;


@end

@implementation FMDBHelper

+ (void)initialize
{
    if (self == [FMDBHelper class]) {
        DBPatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"FMDB.sqlite"];
    }
    
    
}

+ (instancetype)shareFMDBHelper
{
    return [[self alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static FMDBHelper *instance;
    static dispatch_once_t onceT;
    dispatch_once(&onceT, ^{
        instance = [super allocWithZone:zone];
        
    });
    return instance;
}




//插入数据库
- (BOOL)insertDB:(NSObject *)model  withKey:(NSString *)key
{
    
    __block BOOL succeed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
       
        NSString * sql = @"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,mainkey TEXT, customData BLOB)";
        sql = [NSString stringWithFormat:sql,NSStringFromClass([model class])];
        
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error when creating db table");
        } else {
            debugLog(@"succ to creating db table");
            
            NSString *str=[NSString stringWithFormat:@"INSERT INTO %@ (mainkey,customData) VALUES (?,?)",NSStringFromClass([model class])];
           //FMDB的坑，只能values是可变参数
            succeed = [db executeUpdate:str,key,[NSKeyedArchiver archivedDataWithRootObject:model]];
            if (succeed) {
                [model didInserIntoDB];
            }
            
        }

    }];
    
    return succeed;

}
//更新
- (BOOL)updataDB:(NSObject *)model  withKey:(NSString *)key
{
    
    __block BOOL succeed = NO;
    
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        

        NSString *str=[NSString stringWithFormat:@"UPDATE %@ SET customData = ? WHERE mainkey = ?",NSStringFromClass([model class])];
        //只能values可变
        succeed = [db executeUpdate:str,[NSKeyedArchiver archivedDataWithRootObject:model],[model keyString]];


        if (succeed) {
            [model didUpDataDB];
        }
        
        }
        
    ];
    return succeed;
}
//删除
- (BOOL)deleteDB:(Class)tableName WithKey:(NSString *)key
{
    __block BOOL succeed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        
        NSString *str = [NSString stringWithFormat:@"SELECT * FROM %@ where mainkey = ?",NSStringFromClass(tableName)];
        
        FMResultSet * rs = [db executeQuery:str,key];
        
        while ([rs next]) {
            NSData * data = [rs dataForColumn:@"customData"];
            
            id model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [model didDeleteDB];
            
        }
        str = [NSString stringWithFormat:@"delete from %@ where mainkey = ?",NSStringFromClass(tableName)];
        succeed = [db executeUpdate:str,key];

        }
        
    ];
    
    return succeed;
}
//查询
- (NSArray *)selectTable:(Class)tableName where:(NSString *)keyValue
{
    NSMutableArray *dataArrayM = [[NSMutableArray alloc] init];
    [self.databaseQueue inDatabase:^(FMDatabase *db) {
        NSString *str = [NSString stringWithFormat:@"SELECT * FROM %@ where mainkey = ?",NSStringFromClass(tableName)];
        
        FMResultSet * rs = [db executeQuery:str,keyValue];
        
        while ([rs next]) {
            NSData * data = [rs dataForColumn:@"customData"];
            id model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [model didSeleteResult];
            [dataArrayM addObject:model];

        }

        }
        
    ];

    return [dataArrayM copy];
    
}


- (FMDatabase *)db
{
    if (_db == nil) {
        _db = [FMDatabase databaseWithPath:DBPatch];
        [_db open];
    }
    return _db;
}


- (FMDatabaseQueue *)databaseQueue
{
    if (_databaseQueue == nil) {
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:DBPatch];
    }
    return _databaseQueue;
}

@end

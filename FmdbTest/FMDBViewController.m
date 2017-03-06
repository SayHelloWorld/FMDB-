//
//  FMDBViewController.m
//  FmdbTest
//
//  Created by hlq on 16/3/5.
//  Copyright © 2016年 ustb All rights reserved.
//
#import "FMDBViewController.h"
#import "TestModel.h"
#import "FMDBHelper.h"
static CGFloat SCREENWITH;
static CGFloat SCREENHEIGHT;
@interface FMDBViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FMDBViewController

+ (void) initialize
{
    if (self == [FMDBViewController class]) {
        SCREENWITH = [UIScreen mainScreen].bounds.size.width;
        SCREENHEIGHT = [UIScreen mainScreen].bounds.size.height;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, SCREENWITH, SCREENHEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSLog(@"%@",[FMDBHelper shareFMDBHelper]);
    NSLog(@"%@",[FMDBHelper shareFMDBHelper]);
    NSLog(@"%@",[FMDBHelper shareFMDBHelper]);
    NSLog(@"%@",[FMDBHelper shareFMDBHelper]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIn = @"cellIn";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIn];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIn];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"插入";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"删除";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"更新";
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"查询";
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    dispatch_queue_t queue = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    if (indexPath.row == 0) {
        
        
        for (int i = 0; i<100; i++) {
            
            dispatch_async(queue, ^{
                TestModel *model = [[TestModel alloc] init];
                model.str = [NSString stringWithFormat:@"test%d",rand()%100];
                [[FMDBHelper shareFMDBHelper] insertDB:model withKey:[NSString stringWithFormat:@"key%d",i]];
            });
            
            
        }
    } else if (indexPath.row == 1) {
        for (int i = 0; i<100; i++) {
            
            dispatch_async(queue, ^{
                [[FMDBHelper shareFMDBHelper] deleteDB:[TestModel class] WithKey:[NSString stringWithFormat:@"key%d",rand()%100]];
            });
            
            
        }
    } else if (indexPath.row == 2) {
        for (int i = 0; i<100; i++) {
            
            dispatch_async(queue, ^{
                TestModel *model = [[TestModel alloc] init];
                model.str = [NSString stringWithFormat:@"TEST%d",rand()%100];
                [[FMDBHelper shareFMDBHelper] updataDB:model withKey:[NSString stringWithFormat:@"key%d",i]];
            });
            
            
        }
    } else if (indexPath.row == 3) {
        
       for (int i = 0; i<100; i++) {
        dispatch_async(queue, ^{

            

            FMDBHelper *FM = [FMDBHelper shareFMDBHelper];
            NSArray *array = [FM selectTable:[TestModel class]  where:[NSString stringWithFormat:@"key%d",i]];
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLog(@"%@",((TestModel *)obj).str);
            }];
            
            });
                
           
       }
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  MyCollectViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MyCollectViewController.h"
#import "FMDB.h"
#import "HomeNews.h"
@interface MyCollectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) FMDatabase * database;

@property (nonatomic,strong) NSArray * newsArray;
@end

@implementation MyCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;    
    
    UITableView* tableview=[[UITableView alloc]init];
    tableview.frame=self.view.bounds;
    tableview.delegate=self;
    tableview.dataSource=self;
    self.tableView=tableview;
    [self.view addSubview:tableview];
    //[tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCollectTableViewCell"];
    
    //创建数据库对象（指定路径）/Documents/fmdb.sqlite
    NSString* documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString* fmdbPath=[documentPath stringByAppendingPathComponent:@"fmdb.sqlite"];
    //sqlite3_open 创建了一个空的数据库
    self.database=[FMDatabase databaseWithPath:fmdbPath];
    //打开数据库 !!!手动执行打开操作
    [self.database open];
    
    //执行查询动作 返回给fmresultset
    FMResultSet* resultSet=[self.database executeQuery:@"select * from news"];
    NSMutableArray* newsMutableArray=[NSMutableArray new];
    //循环读取fmresultset中的数据
    while ([resultSet next]) {
        //分别获取不同类型(选择不同的方法)
        HomeNews* homeNews=[HomeNews new];
        homeNews.title=[resultSet stringForColumn:@"title"];
        homeNews.ctime=[resultSet stringForColumn:@"ctime"];
        homeNews.descript=[resultSet stringForColumn:@"detail"];
        [newsMutableArray addObject:homeNews];
    }
    self.newsArray=[newsMutableArray copy];
    [self.database close];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark===tableviewdelegate

#pragma mark===tableview delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MyCollectTableViewCell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyCollectTableViewCell"];
    }
    HomeNews* homeNews=self.newsArray[indexPath.row];
    cell.textLabel.text=homeNews.title;
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.detailTextLabel.text=homeNews.ctime;
    cell.detailTextLabel.font=[UIFont systemFontOfSize:10];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return thisScreenHeight/7;
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

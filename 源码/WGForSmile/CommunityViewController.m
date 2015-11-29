//
//  CommunityViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "CommunityViewController.h"
#import "CommunitySendViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "Community.h"
#import "CommunityManager.h"
#import "UIImageView+WebCache.h"
#import "CommunityTableViewCell.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray * communityArray;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark---toolbar
    UIBarButtonItem* item=[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(send:)];
    //木棍
    UIBarButtonItem *item0=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item0.width=40;
    //弹簧
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems=@[item0,item1,item,item1,item0];
#pragma mark---tableview
    UITableView* tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    self.tableView=tableview;
    [self.view addSubview:tableview];
    [tableview registerClass:[CommunityTableViewCell class] forCellReuseIdentifier:@"CommunityTableViewCell"];
    
    UIBarButtonItem* refresh=[[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem=refresh;
    


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden=NO;
    //self.tabBarController.tabBar.hidden=YES;
    }
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)send:(id)sender
{
    //点击发布 已经登录跳页面 没有登录跳登录
    BmobUser* bUser=[BmobUser getCurrentUser];
    if (!bUser) {
        LoginViewController* loginViewController=[LoginViewController new];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.leftsilderVC.navigationController pushViewController:loginViewController animated:YES];
        return;
    }
    else
    {
    CommunitySendViewController* send=[CommunitySendViewController new];
    [self.navigationController pushViewController:send animated:YES];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark===tableviewdelegate

#pragma mark===tableview delegate datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.communityArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommunityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"CommunityTableViewCell" forIndexPath:indexPath];
    
    Community* community=self.communityArray[indexPath.row];
    cell.label.text=community.title;
    //NSLog(@"%@",community.imageUrl);
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:community.imageUrl] placeholderImage:[UIImage imageNamed:@"elephant"]];
    cell.content.text=community.content;
    cell.whoSend.text=community.whoSend;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return thisScreenHeight/3.5;
}


#pragma mark==点刷新后，请求数据 保存本地 然后显示加载(没写保存本地呢)

-(void)refresh:(id)sender
{
    BmobQuery* query=[BmobQuery queryWithClassName:@"Community"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            self.communityArray=[CommunityManager analysisBmobObjects:array];
        [self.tableView reloadData];
    }];
    
}

@end

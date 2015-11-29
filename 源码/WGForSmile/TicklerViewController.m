//
//  TicklerViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TicklerViewController.h"
#import "EditViewController.h"
#import "TicklerManager.h"
#import "Tickler.h"
@interface TicklerViewController ()<UITableViewDataSource,UITableViewDelegate,EditViewControllerDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * ticklerArray;
@end

@implementation TicklerViewController

-(NSMutableArray *)ticklerArray
{
    if (!_ticklerArray) {
        _ticklerArray=[NSMutableArray arrayWithArray:[TicklerManager contacts]];
    }
    return _ticklerArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(edit:)];
    [self setUpTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpTableView
{
    UITableView* tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [self.view addSubview:self.tableView];
}

#pragma mark====tabledelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ticklerArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    Tickler* tickler=self.ticklerArray[indexPath.row];
    cell.textLabel.text=tickler.tickler;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
#pragma mark===tableview支持编辑
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//当编辑动作被触发以后执行什么操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self.ticklerArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [TicklerManager refreshTickler:self.ticklerArray];
    }
}




//前往编辑页 编辑
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditViewController* editViewController=[EditViewController new];
    Tickler* tickler=self.ticklerArray[indexPath.row];
    editViewController.textViewString=tickler.tickler;
    editViewController.textIndex=indexPath.row;
    editViewController.delegate=self;
    editViewController.behaviour=@"编辑";
    //[self.ticklerArray removeObjectAtIndex:indexPath.row];
    [self.navigationController pushViewController:editViewController animated:YES];
}

#pragma mark---前往编辑页 添加
-(void)edit:(UIBarButtonItem*)sender
{
    EditViewController* editViewController=[EditViewController new];
    editViewController.behaviour=@"添加";
    editViewController.delegate=self;
    [self.navigationController pushViewController:editViewController animated:YES];
}

#pragma mark--- 重写代理方法
-(void)addText:(NSString *)didEditText andin:(NSInteger)index
{
    Tickler* tickler=[Tickler new];
    tickler.tickler=didEditText;
    [self.ticklerArray replaceObjectAtIndex:index withObject:tickler];
    [self.tableView reloadData];
    [TicklerManager refreshTickler:self.ticklerArray];
    
}
-(void)addText:(NSString *)didAddText
{
    Tickler* ticker=[Tickler new];
    ticker.tickler=didAddText;
    [self.ticklerArray insertObject:ticker atIndex:0];
    [self.tableView reloadData];
    [TicklerManager refreshTickler:self.ticklerArray];
}

@end

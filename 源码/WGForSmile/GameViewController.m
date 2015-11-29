//
//  GameViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "GameViewController.h"
#import "GameSubViewController.h"
#import "MyGameViewController.h"
@interface GameViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView* tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableview.delegate=self;
    tableview.dataSource=self;
    
    [self.view addSubview:tableview];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GamesTableViewCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark===tableview delegate datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"GamesTableViewCell" forIndexPath:indexPath];
    NSArray* array=@[@"消除",@"强迫矫正棍"];
    cell.textLabel.text=array[indexPath.row];
    return cell;
}

#pragma mark===cell点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row!=0) {
        GameSubViewController* gameSubViewController=[GameSubViewController new];
        NSArray* urlNames=@[@"http://201582221.xiaoxiangzi.com/game/games/qpjzg/?kx#rd"];
        gameSubViewController.urlName=urlNames[indexPath.row-1];
        [self.navigationController pushViewController:gameSubViewController animated:YES];
    }
    else
    {
        MyGameViewController* mygame=[MyGameViewController new];
        [self.navigationController pushViewController:mygame animated:YES];
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

@end

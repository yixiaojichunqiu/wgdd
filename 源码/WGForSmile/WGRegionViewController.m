//
//  WGRegionViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "WGRegionViewController.h"
#import "AroundDataTool.h"
#import "Region.h"
#import "AroundTableViewCell.h"
#import "Masonry.h"
#import "WGCityGroupViewController.h"
@interface WGRegionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * mainTableView;
@property (nonatomic,strong) UITableView * subTableView;
//存储用户选中那个城市的所有区域(子区域)
@property (nonatomic,strong) NSArray * regionsArray;
@end

@implementation WGRegionViewController

//-(NSArray *)regionsArray
//{
//    if (!_regionsArray) {
//        _regionsArray=[AroundDataTool regionsByCity:@"北京"];
//    }
//    return _regionsArray;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    //接收改变城市的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityDidChange:) name:@"CityDidChange" object:nil];
    
    
    UIView* changeView=[UIView new];
    //changeView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:changeView];
    [changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@44);
    }];
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"切换城市" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeView addSubview:button];
    [button addTarget:self action:@selector(clickChangeCity:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(changeView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UITableView* mainTableView=[UITableView new];
    mainTableView.delegate=self;
    mainTableView.dataSource=self;
    //mainTableView.backgroundColor=[UIColor blueColor];
    self.mainTableView=mainTableView;
    [self.view addSubview:mainTableView];
    
    UITableView* subTableView=[UITableView new];
    subTableView.delegate=self;
    subTableView.dataSource=self;
    //subTableView.backgroundColor=[UIColor yellowColor];
    self.subTableView=subTableView;
    [self.view addSubview:subTableView];
    [mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(changeView.mas_bottom).with.offset(0);
        make.right.equalTo(subTableView.mas_left).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.width.equalTo(subTableView);
    }];
    [subTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(changeView.mas_bottom).with.offset(0);
        //make.left.equalTo(mainTableView.right).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        //make.width.equalTo(mainTableView);
    }];
    
    
    
    
    
    
    
    
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

#pragma mark===tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.mainTableView) {
        return self.regionsArray.count;
    }
    else
    {
        NSInteger selectedRow=[self.mainTableView indexPathForSelectedRow].row;
        Region* region=self.regionsArray[selectedRow];
        return region.subregions.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTableView) {
        AroundTableViewCell* cell=[AroundTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withHighlightedImageName:@"bg_dropdown_left_selected"];
        Region* region=self.regionsArray[indexPath.row];
        cell.textLabel.text=region.name;
        if (region.subregions.count>0) {
            cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
        }
        return cell;
    }
    else
    {
        AroundTableViewCell* cell=[AroundTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withHighlightedImageName:@"bg_dropdown_right_selected"];
        NSInteger selectedRow=[self.mainTableView indexPathForSelectedRow].row;
        Region* region=self.regionsArray[selectedRow];
        cell.textLabel.text=region.subregions[indexPath.row];
        cell.accessoryView=nil;
        return cell;
        
    }
}

#pragma mark===点击对应cell后发通知，返回上个界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.mainTableView) {
        [self.subTableView reloadData];
        //没有子分类，立即发送通知
        Region* region=self.regionsArray[indexPath.row];
        if (region.subregions.count==0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RegionDidChange" object:self userInfo:@{@"SelectedRegion":region}];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        NSInteger selectedLeftRow=[self.mainTableView indexPathForSelectedRow].row;
        NSInteger selectedRightRow=[self.subTableView indexPathForSelectedRow].row;
        Region* region=self.regionsArray[selectedLeftRow];
        NSString* subRegionName=region.subregions[selectedRightRow];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RegionDidChange" object:self userInfo:@{@"SelectedRegion":region,@"SelectedSubRegion":subRegionName}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

#pragma mark===点击切换城市后

-(void)clickChangeCity:(id)sender
{
    WGCityGroupViewController* cityGroupViewController=[WGCityGroupViewController new];
//    cityGroupViewController.modalPresentationStyle=UIModalPresentationPopover;
//    [self presentViewController:cityGroupViewController animated:YES completion:nil];
    [self.navigationController pushViewController:cityGroupViewController animated:YES];
    
}


#pragma mark---监听到城市切换后

-(void)cityDidChange:(NSNotification*)notification
{
    //获取通知对象包含的城市名字
    NSString* cityName=notification.userInfo[@"SelectedCityName"];
    //显示这个城市所有区域的数据
    self.regionsArray=[AroundDataTool regionsByCity:cityName];
    //刷新tableview
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}







@end

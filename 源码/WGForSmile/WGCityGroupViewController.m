//
//  WGCityGroupViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/16.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "WGCityGroupViewController.h"
#import "Masonry.h"
#import "CityGroup.h"
#import "AroundDataTool.h"
@interface WGCityGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * cityGroupTableView;
@property (nonatomic,strong) NSArray * cityGroupsArray;
@end

@implementation WGCityGroupViewController
-(NSArray *)cityGroupsArray
{
    if (!_cityGroupsArray) {
        _cityGroupsArray=[AroundDataTool cityGroups];
    }
    return _cityGroupsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* changeView=[UIView new];
    //changeView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:changeView];
    [changeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(64);
        make.right.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@44);
    }];
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"城市列表" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [changeView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(changeView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UITableView* cityGroupTableView=[UITableView new];
    cityGroupTableView.delegate=self;
    cityGroupTableView.dataSource=self;
    cityGroupTableView.backgroundColor=[UIColor yellowColor];
    self.cityGroupTableView=cityGroupTableView;
    [self.view addSubview:cityGroupTableView];
    [cityGroupTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.equalTo(changeView.mas_bottom).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
    }];}

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

#pragma mark===tableviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroupsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CityGroup* cityGroup=self.cityGroupsArray[section];
    return cityGroup.cities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier=@"cell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CityGroup* cityGroup=self.cityGroupsArray[indexPath.section];
    cell.textLabel.text=cityGroup.cities[indexPath.row];
    return cell;
    
}

//设置section的头部title
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CityGroup* cityGroup=self.cityGroupsArray[section];
    return cityGroup.title;
}

//设置tableview右边的index
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.cityGroupsArray valueForKey:@"title"];
}


//点击后

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //方式1 代理 方式2block 方式3通知
    //发送通知给区域视图控制器 城市名字
    //获取用户选中的城市组所对应的城市对象
    CityGroup* cityGroup=self.cityGroupsArray[indexPath.section];
    NSString* cityName=cityGroup.cities[indexPath.row];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CityDidChange" object:nil userInfo:@{@"SelectedCityName":cityName}];
    
    [self.navigationController popViewControllerAnimated:YES];
}






@end

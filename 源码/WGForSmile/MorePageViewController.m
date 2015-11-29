//
//  MorePageViewController.m
//  WGForSmile
//
//  Created by tarena on 15/10/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "MorePageViewController.h"
#import "AppDelegate.h"
#import "MorePageCollectionViewFlowLayout.h"
#import "CommunityViewController.h"
#import "GameViewController.h"
@interface MorePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView * collectionView;
@end

@implementation MorePageViewController
-(id)init
{
    self.title=@"更多";
    self.tabBarItem.selectedImage=[UIImage imageNamed:@"tab_more_selected"];
    //    self.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_infomation_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image=[UIImage imageNamed:@"tab_more_normal"];
    //    self.tabBarController.tabBar.backgroundImage=nil;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* backImageView=[UIImageView new];
    backImageView.frame=self.view.bounds;
    backImageView.image=[UIImage imageNamed:@"backgroundimage"];
    [self.view addSubview:backImageView];
    UIButton *menubtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menubtn.frame=CGRectMake(0, 0, 20, 18);
    [menubtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menubtn addTarget:self action:@selector(openorcloseleftlist) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:menubtn];
    
    //添加collectionview
    MorePageCollectionViewFlowLayout *layout=[[MorePageCollectionViewFlowLayout alloc]init];
    UICollectionView *collectionview=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionview.dataSource=self;
    collectionview.delegate=self;
    collectionview.showsVerticalScrollIndicator=NO;
    collectionview.showsHorizontalScrollIndicator=NO;
    collectionview.scrollEnabled=NO;
    collectionview.backgroundColor=NULL;
    //注册collectionview的cell
    [collectionview registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"morepagecell"];
    self.collectionView=collectionview;
    [self.view addSubview:collectionview];
    
    //self.tabBarController.tabBar.hidden=NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.tabBarController.tabBar.hidden=NO;
}

-(void)openorcloseleftlist
{
    AppDelegate *tempappdelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //两个开关的方法
    if (tempappdelegate.leftsilderVC.closed) {
        [tempappdelegate.leftsilderVC openLeftView];
    }
    else
    {
        [tempappdelegate.leftsilderVC closeLeftView];
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

#pragma mark===collectionview delegate

//代理方法 返回每个section里有几个
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}
//返回collecionviewcell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"morepagecell" forIndexPath:indexPath];
    
    NSArray *labeltexts=@[@"社区",@"小游戏"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(thisScreenHeight/55, thisScreenHeight/20, thisScreenHeight/11.5, thisScreenHeight/11.5)];
    label.text=labeltexts[indexPath.row];
    label.font=[UIFont systemFontOfSize:13];
    label.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    cell.contentView.tag=32;
    cell.backgroundView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"community"]];
    UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [cell addGestureRecognizer:panGR];
    cell.tag=(indexPath.row+100);
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        CommunityViewController* community=[CommunityViewController new];
        //[self setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:community animated:YES];
    }
    if (indexPath.row==1) {
        GameViewController* game=[GameViewController new];
        [self.navigationController pushViewController:game animated:YES];
    }
    
    
}


#pragma mark===pan
-(void)pan:(UIPanGestureRecognizer*)gr
{
    //获取手势当前的坐标，即当前手指所在位置在某个视图中的坐标
    //    CGPoint location=[gr locationInView:self.view];
    //    NSLog(@"%@",NSStringFromCGPoint(location));
    //    _redView.center=location;
    //translation这个属性记录移动的当前点距离之前点的位移
    CGPoint tranlation=[gr translationInView:self.collectionView];
    UITableViewCell* cell1=(UITableViewCell*)[self.collectionView viewWithTag:100];
    if (gr.view==cell1) {
        cell1.center=CGPointMake(cell1.center.x+tranlation.x, cell1.center.y+tranlation.y);
        [gr setTranslation:CGPointZero inView:self.collectionView];
    }
    UITableViewCell* cell2=(UITableViewCell*)[self.collectionView viewWithTag:101];
    if (gr.view==cell2) {
        cell2.center=CGPointMake(cell2.center.x+tranlation.x, cell2.center.y+tranlation.y);
        [gr setTranslation:CGPointZero inView:self.collectionView];
    }

}

@end

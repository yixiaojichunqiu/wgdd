//
//  PersonalPageViewController.m
//  WGForSmile
//
//  Created by tarena on 15/10/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//
#import <BmobSDK/Bmob.h>
#import "PersonalPageViewController.h"
#import "AppDelegate.h"
#import "PersonalPageCollectionViewFlowLayout.h"
#import "PersonalPageCollectionViewCell.h"
#import "LoginViewController.h"

#import "ChangeInfomationViewController.h"
#import "AboutViewController.h"
#import "MyCollectViewController.h"

@interface PersonalPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LoginViewControllerDelegate>
@property (nonatomic,strong) UICollectionView* collectionview;
@property (nonatomic,strong) UIButton * goButton;


//

@property (nonatomic,strong) UIButton * loginButton;
@end

@implementation PersonalPageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //没有反应 不执行 说明一直有
    //NSLog(@"zuoce view出现");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //左侧底图
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageview.image=[UIImage imageNamed:@"leftbackimage2"];
    [self.view addSubview:imageview];
    //建立以此为布局的collectionview 并设置相关属性
    PersonalPageCollectionViewFlowLayout *layout=[[PersonalPageCollectionViewFlowLayout alloc]init];
    UICollectionView *collectionview=[[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collectionview.dataSource=self;
    collectionview.delegate=self;
    collectionview.showsVerticalScrollIndicator=NO;
    collectionview.showsHorizontalScrollIndicator=NO;
    //collectionview.scrollEnabled=NO;
    collectionview.backgroundColor=NULL;
    //注册collectionview的cell
    [collectionview registerClass:[PersonalPageCollectionViewCell class]forCellWithReuseIdentifier:@"personalpagecell"];
    //注册collectionview的头尾
    [collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"personalPageHeader"];
    [collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"personalPageFooter"];
    self.collectionview=collectionview;
    [self.view addSubview:collectionview];
    
}

-(void)ifloaded
{
    BmobUser* bUser=[BmobUser getCurrentUser];
    if (bUser) {
        self.nickNameLabel.text=[bUser objectForKey:@"nickName"];
        self.headimageview.image=[UIImage imageNamed:@"elephant"];
        self.outButton.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//代理方法 返回每个section里有几个
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
#pragma mark===collecionviewcell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalPageCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"personalpagecell" forIndexPath:indexPath];
    //cell不算复杂 就不自定义了 加label和imageview
    NSArray *labeltexts=@[@"我的发布",@"我的收藏",@"我的评论",@"敬请期待"];
    //,@"我的社区",@"离线视频",@"我的任务",@"我的竞猜"];
    NSArray *imagenames=@[@"left_offline",@"left_fav",@"left_comment",@"left_communty"];
    //,@"left_communty",@"left_offline",@"left_offline",@"left_offline"];
    cell.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    cell.label.text=labeltexts[indexPath.row];
    cell.imageView.image=[UIImage imageNamed:imagenames[indexPath.row]];
    return cell;
}
//collectionView点击，如果没登录，跳转登录页
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self jump2LoginPage:self.goButton];
    BmobUser* bUser=[BmobUser getCurrentUser];
    if (bUser) {
        if (indexPath.row==0) {
            NSLog(@"我的发布");
        }
        else if(indexPath.row==1){
            NSLog(@"我的收藏");
            MyCollectViewController* mycollect=[MyCollectViewController new];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.leftsilderVC.navigationController pushViewController:mycollect animated:NO];
        }
        else if(indexPath.row==2)
        {
            NSLog(@"我的评论");
        }
        else{
            
        }
    }
}
//collecionview头和尾如何显示
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind==UICollectionElementKindSectionHeader) {
        UICollectionReusableView* headerview=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"personalPageHeader" forIndexPath:indexPath];
        //headerview.backgroundColor=[UIColor redColor];
        //往头部视图添加view
        UIImageView *headimageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginhead"]];
        headimageview.frame=CGRectMake(35, 90, 65, 65);
        //修改图片的layer层渲染效果
        //正方形图片变圆形
        headimageview.layer.cornerRadius=headimageview.frame.size.width/2;
        headimageview.layer.masksToBounds=YES;
        self.headimageview=headimageview;
        [headerview addSubview:headimageview];
        //头像旁边昵称
        self.nickNameLabel=[UILabel new];
        self.nickNameLabel.text=@"请登录";
        self.nickNameLabel.textColor=[UIColor lightGrayColor];
        self.nickNameLabel.font=[UIFont systemFontOfSize:15];
        self.nickNameLabel.frame=CGRectMake(150, 140, 50, 30);
        [headerview addSubview:self.nickNameLabel];
        [self ifloaded];
        //添加头部的4个按钮
        NSArray* headerButtonsName=@[@"相册",@"动态",@"关注",@"粉丝"];
        NSArray* headerLabelsName=@[@"0",@"0",@"0",@"0"];
        for (int i=0; i<4; i++) {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeSystem];
            CGFloat width=(self.view.frame.size.width*0.7)/4;
            button.frame=CGRectMake(i*width, 190, width, 60 );
            [button setTitle:headerButtonsName[i] forState:UIControlStateNormal];
            button.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
            [button addTarget:self action:@selector(jump2LoginPage:) forControlEvents:UIControlEventTouchUpInside];
            self.goButton=button;
            [headerview addSubview:button];
            UILabel* label=[UILabel new];
            label.frame=CGRectMake(i*width, 220, width, 30);
            label.text=headerLabelsName[i];
            label.font=[UIFont systemFontOfSize:13];
            label.textAlignment=NSTextAlignmentCenter;
            [headerview addSubview:label];
        }
        //添加登录的按钮 是透明的 在头像部位
        UIButton* loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.backgroundColor=[UIColor clearColor];
        CGRect frame=headerview.bounds;
        frame.size.height-=60;
        loginButton.frame=frame;
        [loginButton addTarget:self action:@selector(jump2LoginPage:) forControlEvents:UIControlEventTouchUpInside];
        //loginButton.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        self.loginButton=loginButton;
        [headerview addSubview:loginButton];
        return headerview;
    }
    else
    {
        UICollectionReusableView* footerview=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"personalPageFooter" forIndexPath:indexPath];
        //添加尾部的2个按钮
        for (int i=0; i<1; i++) {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat width=(self.view.frame.size.width*0.7)/3;
            button.frame=CGRectMake(i*width, 0, width, 30 );
            [button setTitle:@"设置" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"left_setting"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//字体颜色
            [button addTarget:self action:@selector(setSome:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font=[UIFont systemFontOfSize:15];
            button.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
            [footerview addSubview:button];
        }
#pragma mark===退出帐号 按钮
        UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width=(self.view.frame.size.width*0.7)/3;
        button.frame=CGRectMake(1*width, 0, width, 30 );
        [button setTitle:@"退出帐号" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"left_setting"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//字体颜色
        button.titleLabel.font=[UIFont systemFontOfSize:15];
        button.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        button.hidden=YES;
        self.outButton=button;
        [button addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        [footerview addSubview:button];
        BmobUser *bUser = [BmobUser getCurrentUser];
        NSLog(@"%@",bUser);
        if (bUser) {
            button.hidden=NO;
        }
        
        return footerview;
    }
}



//section头部距离
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size=CGSizeMake(375, 250);
    return size;
}
//section尾部距离
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size=CGSizeMake(375, thisScreenHeight/4.5);
    return size;
}

#pragma mark===设置

-(void)setSome:(UIButton*)sender
{
    AboutViewController* about=[AboutViewController new];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.leftsilderVC.navigationController pushViewController:about animated:NO];
}


#pragma mark===跳转登录页面的方法
-(void)jump2LoginPage:(UIButton*)sender
{
    BmobUser* bUser=[BmobUser getCurrentUser];
    if (!bUser) {
        LoginViewController* loginViewController=[LoginViewController new];
        loginViewController.delegate=self;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.leftsilderVC.navigationController pushViewController:loginViewController animated:YES];
        return;
    }
    else
    {
    if (sender==self.loginButton) {
        ChangeInfomationViewController* changeInformation=[ChangeInfomationViewController new];
        changeInformation.block=^(NSString* nick){
            self.nickNameLabel.text=nick;
        };
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.leftsilderVC.navigationController pushViewController:changeInformation animated:NO];
        
    }
    }
}

#pragma mark===注销
-(void)logout:(UIButton*)sender{
    BmobUser* bUser=[BmobUser getCurrentUser];
    [bUser setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (!error) {
        }
    }];
    [BmobUser logout];
    self.nickNameLabel.text=@"请登录";
    self.headimageview.image=[UIImage imageNamed:@"loginhead"];
    sender.hidden=YES;
}
#pragma mark===LoginViewController代理方法
-(void)refresh
{
    BmobUser* bUser=[BmobUser getCurrentUser];
    self.outButton.hidden=NO;
    self.nickNameLabel.text=[bUser objectForKey:@"nickName"];
    self.headimageview.image=[UIImage imageNamed:@"elephant"];
}

@end

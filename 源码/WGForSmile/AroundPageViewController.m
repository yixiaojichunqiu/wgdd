//
//  AroundPageViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/15.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "AroundPageViewController.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "NavLeftView.h"
#import "UIBarButtonItem+WGBarButtonItem.h"
#import "WGRegionViewController.h"
#import "Region.h"
#import "UnderLineTextField.h"
#import "DPAPI.h"
#import "AroundDataTool.h"
#import "AroundPageCollectionViewFlowLayout.h"
#import "AroundCollectionViewCell.h"
#import "Deal.h"
#import "DealDetailViewController.h"

@interface AroundPageViewController ()<DPRequestDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>


@property (nonatomic,strong) NavLeftView * regionView;
@property (nonatomic,strong) NSString * selectedCity;
@property (nonatomic,strong) NSString * selectedRegion;
@property (nonatomic,strong) NSString * selectedSubRegion;
@property (nonatomic,strong) NSArray * dealsArray;
@property (nonatomic,strong) UICollectionView * collectionview;
@property (nonatomic,strong) UnderLineTextField * searchTextField;

@end

@implementation AroundPageViewController

//这是tabbar
-(id)init{
    self.title=@"周边";
    self.tabBarItem.selectedImage=[UIImage imageNamed:@"tab_video_selected"];
    //    self.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_infomation_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image=[UIImage imageNamed:@"tab_video_normal"];
    //    self.tabBarController.tabBar.backgroundImage=nil;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建navigationBar左边的items
    [self setUpLeftItems];
    //创建navigationBar右边的items
    [self setUpRightItems];
    //监听其他控制器发送来的通知事件
    [self setUpListenEvents];
    //设置collectionview
    [self setUpcollection];
    
    [self loadNewsDeals];
}

#pragma mark===添加collectionview
-(void)setUpcollection
{
    AroundPageCollectionViewFlowLayout* layout=[AroundPageCollectionViewFlowLayout new];
    UICollectionView* collectionview=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionview.dataSource=self;
    collectionview.delegate=self;
    collectionview.showsVerticalScrollIndicator=NO;
    collectionview.showsHorizontalScrollIndicator=NO;
    //注册collectionview的cell
    [collectionview registerClass:[AroundCollectionViewCell class]forCellWithReuseIdentifier:@"aroundcell"];
    //注册collectionview的头尾
//    [collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"aroundHeader"];
//    [collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"aroundFooter"];
    collectionview.backgroundColor=[UIColor whiteColor];
    self.collectionview=collectionview;
    [self.view addSubview:collectionview];
    
}
-(void)setUpLeftItems
{
    UIButton *menubtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menubtn.frame=CGRectMake(0, 0, 20, 18);
    [menubtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menubtn addTarget:self action:@selector(openorcloseleftlist) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* personalItem=[[UIBarButtonItem alloc]initWithCustomView:menubtn];
    self.regionView=[NavLeftView customView];
    UIBarButtonItem* regionItem=[[UIBarButtonItem alloc]initWithCustomView:self.regionView];
    //加regionView点击事件
    [self.regionView.imageButton addTarget:self action:@selector(clickRegionView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems=@[personalItem,regionItem];
}
-(void)setUpRightItems
{

    UIBarButtonItem *locationItem=[UIBarButtonItem itemWithImage:@"icon_map" withHighlightedImage:@"icon_map_highlighted" withTarget:self withAction:@selector(clickLoctionItem)];
    UIBarButtonItem *searchItem=[UIBarButtonItem itemWithImage:@"icon_search" withHighlightedImage:@"icon_search_highlighted" withTarget:self withAction:@selector(clickSearchItem)];
    UnderLineTextField* textField=[UnderLineTextField new];
    textField.textColor=[UIColor whiteColor];
    textField.frame=CGRectMake(0, 0, 70, 20);
    textField.keyboardType=UIKeyboardTypeDefault;
    textField.returnKeyType=UIReturnKeyDone;
    textField.delegate=self;
    self.searchTextField=textField;
    UIBarButtonItem* underlineItem=[[UIBarButtonItem alloc]initWithCustomView:textField];
    self.navigationItem.rightBarButtonItems=@[locationItem,searchItem,underlineItem];

}
-(void)clickLoctionItem{
    NSLog(@"1");
}
-(void)clickSearchItem{
    [self loadNewsDeals];
}
#pragma mark===点击搜索键后
-(void)loadNewsDeals
{
    [self sendRequestToserver];
}

-(void)sendRequestToserver
{
    //创建参数可变字典
    NSMutableDictionary* params=[NSMutableDictionary dictionary];
    //城市 给默认的城市 最好定位
    if (self.selectedCity.length==0) {
        params[@"city"]=@"北京";
    }
    else
    {
        params[@"city"]=self.selectedCity;
    }
    //区域
    if (self.selectedRegion&&![self.selectedRegion isEqualToString:@"全部"]) {
        if (self.selectedSubRegion&&![self.selectedSubRegion isEqualToString:@"全部"]) {
            params[@"region"]=self.selectedSubRegion;
        }
        else
        {
            params[@"region"]=self.selectedRegion;
        }
    }
    //NSLog(@"%lu",_searchTextField.text.length);
    if (self.searchTextField.text.length!=0) {
        params[@"keyword"]=self.searchTextField.text;
    }
    //创建api对象
    DPAPI *api=[DPAPI new];
    //发送请求
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

//regionView点击方法
-(void)clickRegionView
{
    [self.navigationController pushViewController:[WGRegionViewController new] animated:YES];
    
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
#pragma mark==监听发来的城市信息
-(void)setUpListenEvents
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityDidChange:) name:@"CityDidChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regionDidChange:) name:@"RegionDidChange" object:nil];
 
}

-(void)cityDidChange:(NSNotification*)notification
{
    self.selectedCity=notification.userInfo[@"SelectedCityName"];
    
}
-(void)regionDidChange:(NSNotification*)notification
{
    Region *region=notification.userInfo[@"SelectedRegion"];
    self.selectedRegion=region.name;
    self.selectedSubRegion=notification.userInfo[@"SelectedSubRegion"];
    
    if (self.selectedSubRegion.length==0) {
        self.regionView.subLabel.text=@"---";
    }
    else
    {
        self.regionView.subLabel.text=self.selectedSubRegion;
    }
    self.regionView.titleLabel.text=[NSString stringWithFormat:@"%@-%@",self.selectedCity,self.selectedRegion];
    //发送请求
    //[self loadNewsDeals];
}


#pragma mark--dprequestdelegate
//成功
-(void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //NSLog(@"成功返回 %@",result);
    self.dealsArray=[AroundDataTool dealsFromResult:result];
    [self.collectionview reloadData];
}


//失败返回
-(void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"失败%@",error.userInfo);
}




#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dealsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AroundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"aroundcell" forIndexPath:indexPath];
    Deal* deal=self.dealsArray[indexPath.row];
    
    cell.deal=deal;
    return cell;
    
}



#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建详情视图控制器对象
    Deal* deal=self.dealsArray[indexPath.row];
    //推出
    DealDetailViewController* detailViewController=[DealDetailViewController new];
    detailViewController.deal=deal;
    [self.navigationController pushViewController:detailViewController animated:YES];
}



//点击屏幕空白处 收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




@end

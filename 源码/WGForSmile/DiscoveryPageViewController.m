//
//  DiscoveryPageViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/14.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "DiscoveryPageViewController.h"
#import "AppDelegate.h"
//#import "TRHero.h"
#import "LSSelectMenuView.h"
#import "DiscoveryPageCollectionViewFlowLayout.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "RankList.h"
#import "RankListDataTool.h"
#import "DiscoveryCollectionViewCell.h"

@interface DiscoveryPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LSSelectMenuViewDelegate,LSSelectMenuViewDataSource>

@property (nonatomic,strong) LSSelectMenuView* menuview;
@property (nonatomic,strong) NSArray* array;
@property (nonatomic,strong) UICollectionView* collectionview;
//@property (nonatomic,strong) NSArray * heroarray;//已经解析好的人物弄成对象放在这个数组里
//@property (nonatomic,strong) NSMutableArray* seekheroarray;

@property (nonatomic,strong) NSArray * rankListArray;

@property (nonatomic,strong) NSDictionary * category;
@end

@implementation DiscoveryPageViewController

-(NSDictionary *)category
{
    if (!_category) {
        _category=@{@"电影":@"movie",@"音乐":@"music",@"书":@"ebook",@"软件":@"software"};
    }
    return _category;
}

-(id)init
{
    self.title=@"发现";
    self.tabBarItem.selectedImage=[UIImage imageNamed:@"tab_community_selected"];
    //    self.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_infomation_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.image=[UIImage imageNamed:@"tab_community_normal"];
    //    self.tabBarController.tabBar.backgroundImage=nil;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *menubtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menubtn.frame=CGRectMake(0, 0, 20, 18);
    [menubtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menubtn addTarget:self action:@selector(openorcloseleftlist) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:menubtn];
    
#pragma mark----
    DiscoveryPageCollectionViewFlowLayout* layout=[DiscoveryPageCollectionViewFlowLayout new];
    
    UICollectionView* collectionview=[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionview.dataSource=self;
    collectionview.delegate=self;
    collectionview.showsVerticalScrollIndicator=NO;
    collectionview.showsHorizontalScrollIndicator=NO;
    //注册collectionview的cell
    [collectionview registerClass:[DiscoveryCollectionViewCell class]forCellWithReuseIdentifier:@"discoverycell"];
    //注册collectionview的头尾
    [collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"discoveryHeader"];
    [collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"discoveryFooter"];
    collectionview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:collectionview];
    
    self.array=@[@"分类热榜",@"名人堂",@"兴趣",@"其他"];
    LSSelectMenuView* menuview=[[LSSelectMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    menuview.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    menuview.delegate = self;
    menuview.dataSource = self;
    [self.view addSubview:menuview];
    UIView* showView = [[UIView alloc] initWithFrame:CGRectMake(0, menuview.frame.origin.y+menuview.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-64-44)];
    //    showView.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0.65];
    showView.backgroundColor=[UIColor redColor];
    [self.view addSubview:showView];
    menuview.showView = showView;
    
    self.menuview=menuview;
    self.collectionview=collectionview;
    
    [self requestJSONFromTop:@"幽默" and:@"software"];
    
    
}


//-(void)getJSONData
//{
//    NSMutableArray* array=[NSMutableArray new];
//    for (int i=1; i<=32; i++) {
//        NSString* heropath=[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"json"];
//        NSData* herodata=[NSData dataWithContentsOfFile:heropath];
//        NSError* error;
//        NSDictionary* herodic=[NSJSONSerialization JSONObjectWithData:herodata options:0 error:&error];
//        if (error) {
//            NSLog(@"error %@",error.userInfo);
//        }
//        TRHero* hero=[TRHero heroWithDic:herodic];
//        [array addObject:hero];
//    }
//    self.heroarray=array;
//}

#pragma mark===随机颜色
- (UIColor *)randomColor {
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        (time(NULL));
    }
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}


#pragma mark collectionView代理
//代理方法 返回每个section里有几个
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.rankListArray.count;
}
#pragma mark===collectionview cell
//返回collecionviewcell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveryCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"discoverycell" forIndexPath:indexPath];
    //cell.backgroundColor=[UIColor yellowColor];
//    
//    UILabel *label=[[UILabel alloc]init];
    RankList* rankList=self.rankListArray[indexPath.row];
    
    //NSLog(@"%@",hero.heroName);
    cell.label.text=rankList.trackName;
    
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:rankList.artworkUrl60] placeholderImage:[UIImage imageNamed:@"elephant"]];

//#pragma mark===这里没有用任何图片缓存技术 也没有建立单例类 也没有封装 一层 二层以后需要写＝＝＝＝＝＝＝第三方！
//    
//    NSURL *url=[NSURL URLWithString:hero.heroPictureUrl];
//    dispatch_queue_t queue=dispatch_get_global_queue(0, 0);
//    //下载图片逻辑放到异步执行的block中
//    dispatch_async(queue, ^{
//        NSData *imageData=[NSData dataWithContentsOfURL:url];
//        UIImage *image=[UIImage imageWithData:imageData];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImageView *imageview=[UIImageView new];
//            imageview.frame=cell.bounds;
//            imageview.image=image;
//            [cell addSubview:imageview];
//        });
//    });
    //＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    return cell;
}
//collecionview头和尾如何显示



-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind==UICollectionElementKindSectionHeader) {
        UICollectionReusableView* headerview=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"discoveryHeader" forIndexPath:indexPath];
        return headerview;
    }
    else
    {
        UICollectionReusableView* footerview=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"discoveryFooter" forIndexPath:indexPath];
        return footerview;
    }
}
//section头部距离
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size=CGSizeMake(375, thisScreenHeight/5);
    return size;
}
//section尾部距离
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size=CGSizeMake(375, thisScreenHeight/5);
    return size;
}

//collectionview点击方法 每个的
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%ld",indexPath.row);
}




#pragma mark - LSSelectMenuViewDataSource
//返回有几个按钮点击会有下拉效果
- (NSInteger)numberOfItemsInMenuView:(LSSelectMenuView *)menuview{
    //NSLog(@"%ld",self.array.count);
    return self.array.count;
}
//返回每个的名字
- (NSString*)menuView:(LSSelectMenuView *)menuview titleForItemAtIndex:(NSInteger)index{
    
    return self.array[index];
}
//返回每个的高度
- (CGFloat)menuView:(LSSelectMenuView *)menuview heightForCurrViewAtIndex:(NSInteger)index{
    if (index==0) {
        return 100;
    }
    else if(index==1)
    {
        return 150;
    }
    else if(index==2)
    {
        return 60;
    }
    else
    {
        return 100;
    }
}

#pragma mark===下出页上的各个按钮
//按钮需要封装！！！＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
- (UIView*)menuView:(LSSelectMenuView *)menuview currViewAtIndex:(NSInteger)index{
    UIView* vv = [[UIView alloc] initWithFrame:CGRectZero];
    NSLog(@"%lf %lf",vv.frame.size.width,vv.frame.size.height);
    vv.backgroundColor = [self randomColor];
    
    if (index==0) {
        NSArray* array=@[@"分类热榜",@"ios",@"android",@"java",@"c＃",@"html5",@"js",@"python"];
        for (int i=0; i<array.count; i++) {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array[i] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            button.backgroundColor=[UIColor lightGrayColor];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonSelected"] forState:UIControlStateSelected];
            button.frame=CGRectMake(10+(i%4)*80, 10+(i/4)*40, 70, 30);
            //button.backgroundColor=[UIColor blueColor];
            [button addTarget:self action:@selector(paixu:) forControlEvents:UIControlEventTouchUpInside];
            [vv addSubview:button];
        }
        
        //CGRect frame=vv.bounds;
        //NSLog(@"%lf",frame.size.width);
        //
        //    button.frame=CGRectMake(0, 0, frame.size.width/5, frame.size.height/5);
        
    }
    else if(index==1)
    {
        NSArray* array=@[@"名人堂",@"技术精英",@"大神",@"产品",@"前端",@"后台",@"名家",@"言传身教",@"传承",@"潜力小白",@"蜀山"];
        for (int i=0; i<array.count; i++) {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array[i] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            button.backgroundColor=[UIColor lightGrayColor];
            button.frame=CGRectMake(10+(i%4)*80, 10+(i/4)*40, 70, 30);
            //button.backgroundColor=[UIColor blueColor];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonSelected"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(paixu:) forControlEvents:UIControlEventTouchUpInside];
            [vv addSubview:button];
        }
    }
    else if(index==2)
    {
        NSArray* array=@[@"兴趣",@"开发",@"设计",@"管理"];
        for (int i=0; i<array.count; i++) {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array[i] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            button.backgroundColor=[UIColor lightGrayColor];
            button.frame=CGRectMake(10+(i%4)*80, 10+(i/4)*40, 70, 30);
            //button.backgroundColor=[UIColor blueColor];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonSelected"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(paixu:) forControlEvents:UIControlEventTouchUpInside];
            [vv addSubview:button];
        }
    }
    else
    {
        NSArray* array=@[@"其他",@"随便看看",@"擂台",@"酒馆",@"禁地"];
        for (int i=0; i<array.count; i++) {
            UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:array[i] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            button.backgroundColor=[UIColor lightGrayColor];
            button.frame=CGRectMake(10+(i%4)*80, 10+(i/4)*40, 70, 30);
            //button.backgroundColor=[UIColor blueColor];
            [button addTarget:self action:@selector(paixu:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonSelected"] forState:UIControlStateSelected];
            [vv addSubview:button];
        }
    }
    
    return vv;
}

#pragma mark - LSSelectMenuViewDelegate
//点击后出现时触发
- (void)selectMenuView:(LSSelectMenuView *)selectmenuview didSelectAtIndex:(NSInteger)index{
    //NSLog(@"show row = %ld",index);
    
}
//点击收回后触发
- (void)selectMenuView:(LSSelectMenuView *)selectmenuview didRemoveAtIndex:(NSInteger)index{
    //NSLog(@"remove row = %ld",index);
}

#pragma mark===点击每项

//点击button触发方法
-(void)paixu:(UIButton*)sender
{
    UIButton* btn=(UIButton*)sender;
    //btn.selected=YES;
    //NSLog(@"%@",btn.titleLabel.text);
    [self requestJSONFromTop:btn.titleLabel.text and:@"software"];
    [self.collectionview reloadData];
    
}

#pragma mark==没用
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

#pragma mark===请求数据

//请求数据
-(void)requestJSONFromTop:(NSString*)term and:(NSString*)entity
{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    NSString* urlName=[NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&country=cn&limit=20&entity=%@",term,entity];
    NSString* encodedString = [urlName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodedString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary* dic=responseObject;
        self.rankListArray=[RankListDataTool rankListFromResult:dic];
        [self.collectionview reloadData];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
}

@end

//bh
//  NewsPageViewController.m
//  WGForSmile
//
//  Created by tarena on 15/10/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "NewsPageViewController.h"
#import "AppDelegate.h"
#import "TopRepeatScrollView.h"
#import "AFNetworking.h"
#import "NewsMetaDataTool.h"
#import "HomeNews.h"
#import "NewestDetailViewController.h"
#import "MJRefresh.h"
#import "BooksChaptersViewController.h"
#import "MusicViewController.h"
@interface NewsPageViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIScrollView* scrollview;
@property (nonatomic,strong) UITableView* newestTableView;
@property (nonatomic,strong) UITableView* booksTableView;
@property (nonatomic,strong) UITableView* musicTableView;
@property (nonatomic,strong) UITableView* entertainmentTableView;
//@property (nonatomic,strong) TopRepeatScrollView * toprepeatscrollview;
//暂时存储接收到的json解析后转换成模型后的
@property (nonatomic,strong) NSMutableArray * newestArray;
//存储一下页数
@property (nonatomic,assign) int page;

@end

@implementation NewsPageViewController
-(NSMutableArray *)newestArray
{
    if (!_newestArray) {
        _newestArray=[NSMutableArray new];
    }
    return _newestArray;
}

-(id)init
{
    //if (self=[super init]) {
        self.title=@"咨讯";
        self.page=0;
        self.tabBarItem.selectedImage=[UIImage imageNamed:@"tab_infomation_selected"];
        //    self.tabBarItem.selectedImage=[[UIImage imageNamed:@"tab_infomation_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.image=[UIImage imageNamed:@"tab_infomation_normal"];
        //    self.tabBarController.tabBar.backgroundImage=nil;
    //}
    //设置tabbar
    return self;
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear");
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDelegate.leftsilderVC setPanEnabled:YES];
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog(@"viewWillDisappear");
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [tempAppDelegate.leftsilderVC setPanEnabled:NO];
//}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //[self.toprepeatscrollview.timer setFireDate:[NSDate distantPast]];
    TopRepeatScrollView* t1=(TopRepeatScrollView*)self.newestTableView.tableHeaderView;
    TopRepeatScrollView* t2=(TopRepeatScrollView*)self.booksTableView.tableHeaderView;
    TopRepeatScrollView* t3=(TopRepeatScrollView*)self.musicTableView.tableHeaderView;
    TopRepeatScrollView* t4=(TopRepeatScrollView*)self.entertainmentTableView.tableHeaderView;
    [t1.timer setFireDate:[NSDate distantPast]];
    [t2.timer setFireDate:[NSDate distantPast]];
    [t3.timer setFireDate:[NSDate distantPast]];
    [t4.timer setFireDate:[NSDate distantPast]];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.toprepeatscrollview.timer setFireDate:[NSDate distantFuture]];//计数器占内存问题
    TopRepeatScrollView* t1=(TopRepeatScrollView*)self.newestTableView.tableHeaderView;
    TopRepeatScrollView* t2=(TopRepeatScrollView*)self.booksTableView.tableHeaderView;
    TopRepeatScrollView* t3=(TopRepeatScrollView*)self.musicTableView.tableHeaderView;
    TopRepeatScrollView* t4=(TopRepeatScrollView*)self.entertainmentTableView.tableHeaderView;
    [t1.timer setFireDate:[NSDate distantFuture]];
    [t2.timer setFireDate:[NSDate distantFuture]];
    [t3.timer setFireDate:[NSDate distantFuture]];
    [t4.timer setFireDate:[NSDate distantFuture]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航按钮
    UIButton *menubtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menubtn.frame=CGRectMake(0, 0, 20, 18);
    [menubtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menubtn addTarget:self action:@selector(openorcloseleftlist) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:menubtn];
    //设置导航栏下几个互斥按钮
    NSArray* names=@[@"最新",@"书籍",@"音乐",@"娱乐"];
    for (int i=0; i<4; i++) {
        UIButton *newsButton=[UIButton buttonWithType:UIButtonTypeCustom];
        newsButton.frame=CGRectMake(i*self.view.frame.size.width/4, 0,self.view.frame.size.width/4, 30);
        [newsButton setTitle:names[i] forState:UIControlStateNormal];
        [newsButton setBackgroundImage:[UIImage imageNamed:@"button_black_normal"] forState:UIControlStateNormal];
        [newsButton setBackgroundImage:[UIImage imageNamed:@"buttonSelected"] forState:UIControlStateSelected];
        newsButton.tag=i+1;
        [newsButton setBackgroundColor:[UIColor lightGrayColor]];
        [newsButton addTarget:self action:@selector(topButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newsButton];
    }
    //设置一开始第一个按钮选中状态
    UIButton* newestButton=(UIButton*)[self.view viewWithTag:1];
    newestButton.selected=YES;
    //设置按钮下方的滚动视图
    UIScrollView *scrollview=[[UIScrollView alloc]init];
    scrollview.delegate=self;
    CGRect frame=self.view.frame;
    frame.origin.y+=30;
    frame.size.height-=30;
    scrollview.frame=frame;
    scrollview.contentSize=CGSizeMake(frame.size.width*4, 0);
    //设置边缘不能弹跳
    scrollview.bounces = NO;
    //设置整页滚动
    scrollview.pagingEnabled = YES;
    //设置水平滚动条不可见
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.showsVerticalScrollIndicator =NO;
#pragma mark===添加4个table
    //添加4个tableview到滚动视图
    //NSArray* colors=@[[UIColor whiteColor],[UIColor redColor],[UIColor yellowColor],[UIColor greenColor]];
    for (NSInteger i=0; i<4; i++) {
        UITableView* tableview=[[UITableView alloc]init];
        tableview.frame=CGRectMake(self.view.bounds.size.width*i, 0, self.view.bounds.size.width, thisScreenHeight-44-40-50);
        //tableview.backgroundColor=colors[i];
        tableview.tag=(i+11);
        tableview.delegate=self;
        tableview.dataSource=self;
        tableview.bounces=YES;
#pragma mark----设置tableview头部滚动视图
        //
        TopRepeatScrollView* repeatscrollview=[[TopRepeatScrollView alloc]initWithFrame:frame];
        tableview.tableHeaderView=repeatscrollview;
        //self.toprepeatscrollview=repeatscrollview;
        [scrollview addSubview:tableview];
    }
    self.newestTableView=(UITableView*)[scrollview viewWithTag:11];
//    [self.newestTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"newestTableViewCell"]; //不用这个采用了旧方式
    self.booksTableView=(UITableView*)[scrollview viewWithTag:12];
    [self.booksTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"booksTableViewCell"];//采用了新方式
    self.musicTableView=(UITableView*)[scrollview viewWithTag:13];
    [self.musicTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"musicTableViewCell"];
    self.entertainmentTableView=(UITableView*)[scrollview viewWithTag:14];
    //上方已 注册tableview的cell
    
    self.scrollview=scrollview;
    [self.view addSubview:scrollview];
#pragma mark===加上下拉刷新
    //tableview加上下拉刷新
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.newestTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page=1;
        [weakSelf requestJSONFromInternet];
    }];
    [self.newestTableView.mj_header beginRefreshing];
    self.newestTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        self.page++;
        [weakSelf requestJSONFromInternet];
    }];
    //[self.newestTableView.mj_footer beginRefreshing];
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
    
}
//设置top4个按钮的方法
-(void)topButtonAction:(UIButton*)sender
{
    if (sender.tag==1) {
        [self.scrollview setContentOffset:CGPointMake(self.view.bounds.size.width*0, 0) animated:YES];
    }
    else if(sender.tag==2)
    {
        [self.scrollview setContentOffset:CGPointMake(self.view.bounds.size.width*1, 0) animated:YES];
    }
    else if(sender.tag==3)
    {
        [self.scrollview setContentOffset:CGPointMake(self.view.bounds.size.width*2, 0) animated:YES];
    }
    else
    {
        [self.scrollview setContentOffset:CGPointMake(self.view.bounds.size.width*3, 0) animated:YES];
    }
}
#pragma mark---滚动视图监测滚动
//首先滚动视图的代理方法 监测他的滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset=scrollView.contentOffset;
    if (offset.x!=0) {
        NSInteger index=round(offset.x/self.view.frame.size.width);
        UIButton *newestButton=(UIButton*)[self.view viewWithTag:1];
        UIButton *newsButton=(UIButton*)[self.view viewWithTag:2];
        UIButton *musicButton=(UIButton*)[self.view viewWithTag:3];
        UIButton *entertainmentButton=(UIButton*)[self.view viewWithTag:4];
        newestButton.selected=NO;
        newsButton.selected=NO;
        musicButton.selected=NO;
        entertainmentButton.selected=NO;
        if (index==0) {
            newestButton.selected=YES;
            //[self topButtonAction:(UIButton*)[self.view viewWithTag:index+1]];
        }
        else if(index==1)
        {
            newsButton.selected=YES;
            //[self topButtonAction:(UIButton*)[self.view viewWithTag:index+1]];
        }
        else if(index==2)
        {
            musicButton.selected=YES;
            //[self topButtonAction:(UIButton*)[self.view viewWithTag:index+1]];
        }
        else
        {
            entertainmentButton.selected=YES;
            //[self topButtonAction:(UIButton*)[self.view viewWithTag:index+1]];
        }

    }
    
    
}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    scrollView.scrollEnabled=YES;
//}







#pragma mark - tableview 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.newestTableView) {
        return 1;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.newestTableView) {
        //NSLog(@"%ld",self.newestArray.count);
        return self.newestArray.count;
    }
    if (tableView==self.booksTableView) {
        return 4;
    }
    if (tableView==self.musicTableView) {
        return 1;
    }
    return 20;
}
#pragma mark---tableviewdelegate cell布置
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tableviewcell" forIndexPath:indexPath ];
    if (tableView==self.newestTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newestTableViewCell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newestTableViewCell"];
        }
        cell.contentView.tag=31;
        if (self.newestArray.count!=0) {
            HomeNews* homeNews=self.newestArray[indexPath.row];
            cell.textLabel.text=homeNews.title;
            cell.textLabel.font=[UIFont systemFontOfSize:12];
        }
        return cell;
    }
    else if(tableView==self.booksTableView)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"booksTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.tag=32;
        NSArray* booksArray=@[@"周易",@"道德经",@"世说新语",@"山海经"];
        cell.textLabel.text=booksArray[indexPath.row];
        return cell;
    }
    else if(tableView==self.musicTableView)
    {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"musicTableViewCell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.tag=32;
        cell.textLabel.text=@"麦振鸿－痴颜";
        return cell;
    }
    else{
        UITableViewCell *cell=[[UITableViewCell alloc]init];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.tag=32;
        cell.textLabel.text=@"敬请期待";
        return cell;
    }

}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return thisScreenHeight/5.5;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 40;
//}

//tableview 每个session的头视图高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 150;
//}
#pragma mark--点击tablecell每行后跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.newestTableView) {
        NewestDetailViewController *newestdetail=[NewestDetailViewController new];
        newestdetail.homeNews=self.newestArray[indexPath.row];
        [self.navigationController pushViewController:newestdetail animated:NO];
    }
    if (tableView==self.booksTableView) {
        BooksChaptersViewController* booksChapters=[BooksChaptersViewController new];
        NSArray* booksArray=@[@"zhouyi",@"laozi",@"shishuoxinyu",@"shanhaijing"];
        booksChapters.bookName=booksArray[indexPath.row];
        [self.navigationController pushViewController:booksChapters animated:YES];
    }
    if (tableView==self.musicTableView) {
        MusicViewController* music=[MusicViewController new];
        [self.navigationController pushViewController:music animated:YES];
    }
}

#pragma mark===请求json数据
//请求第一页新闻数据
-(void)requestJSONFromInternet
{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.huceo.com/guonei/other/?key=7a93a8112635fdf1c282482a43fd9d14&num=10&rand=1&page=%d",self.page] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary* dic=responseObject;
        NSString* plistPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"newest.plist"];
        [dic writeToFile:plistPath atomically:YES];
        //从服务器获取的数据已经弄好是字典类型
        if (self.page==1) {
            [self.newestArray removeAllObjects];
        }
        [self.newestArray addObjectsFromArray:[NewsMetaDataTool newsFromResult:dic]];
        [self.newestTableView reloadData];
        [self.newestTableView.mj_header endRefreshing];
        [self.newestTableView.mj_footer endRefreshing];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
}





@end

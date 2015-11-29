//
//  BooksChaptersViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "BooksChaptersViewController.h"
#import "AFNetworking.h"
#import "NewsMetaDataTool.h"
#import "BooksChapters.h"
#import "BooksContentViewController.h"
#import "MBProgressHUD.h"
@interface BooksChaptersViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * booksChaptersTableView;
@property (nonatomic,strong) NSArray* booksChaptersArray;
@end

@implementation BooksChaptersViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView* tableview=[[UITableView alloc]init];
    tableview.frame=self.view.bounds;
    tableview.delegate=self;
    tableview.dataSource=self;
    [self.view addSubview:tableview];
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"booksChaptersTableViewCell"];
    self.booksChaptersTableView=tableview;
    
    //加载的时候 提示正在加载 用的MBProgressHUD
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self requestJSONFromInternet];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark===tableview delegate datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.booksChaptersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"booksChaptersTableViewCell" forIndexPath:indexPath];
    BooksChapters* booksChapters=self.booksChaptersArray[indexPath.row];
    cell.textLabel.text=booksChapters.name;
    return cell;
}

#pragma mark===cell点击

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BooksChapters* booksChapters=self.booksChaptersArray[indexPath.row];
    NSString* index=booksChapters.detailid;
    [self requestBooksContentFromInternet:[index intValue]];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark===请求json数据
//请求章节数据
-(void)requestJSONFromInternet
{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.jisuapi.com/%@/chapter?appkey=ba2e12e9bdb34eb7",self.bookName] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary* dic=responseObject;
        //从服务器获取的数据已经弄好是字典类型
        self.booksChaptersArray=[NewsMetaDataTool booksChapter:dic];
        [self.booksChaptersTableView reloadData];
        //关闭MBProgressHUD
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
}

//请求每章内容数据

-(void)requestBooksContentFromInternet:(NSInteger)index
{
    AFHTTPRequestOperationManager* manager=[AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.jisuapi.com/%@/detail?appkey=ba2e12e9bdb34eb7&detailid=%d",self.bookName,(int)index] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary* dic=responseObject;
        NSString* str=dic[@"result"][@"content"];
        BooksContentViewController* booksContent=[BooksContentViewController new];
        [self setHidesBottomBarWhenPushed:YES];
        booksContent.content=str;
        [self.navigationController pushViewController:booksContent animated:YES];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
}


@end

//
//  NewestDetailViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/11.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "NewestDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "FMDB.h"
#import <BmobSDK/Bmob.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface NewestDetailViewController ()

@property (nonatomic,strong) FMDatabase* database;
@end

@implementation NewestDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //右侧navi
    UIBarButtonItem* collect=[[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(collectNews:)];
    self.navigationItem.rightBarButtonItem=collect;
    //主体布局
    UIScrollView* scrollView=[UIScrollView new];
    scrollView.frame=self.view.frame;
    
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    
    UILabel* title=[UILabel new];
    title.textAlignment=NSTextAlignmentCenter;
    CGRect frame=self.view.bounds;
    frame.size.height=thisScreenHeight/6;
    title.frame=frame;
    title.text=self.homeNews.title;
    title.backgroundColor=[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.5];
    [scrollView addSubview:title];
    
    UILabel* ctime=[UILabel new];
    frame.origin.y+=frame.size.height;
    ctime.frame=frame;
    ctime.textAlignment=NSTextAlignmentRight;
    ctime.text=self.homeNews.ctime;
    [scrollView addSubview:ctime];
    
    if (self.homeNews.picUrl!=nil) {
        UIImageView* imageview=[UIImageView new];
        frame.origin.y+=frame.size.height;
        frame.origin.x=30;
        frame.size.width=thisScreenWidth-60;
        imageview.frame=frame;
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.homeNews.picUrl] placeholderImage:[UIImage imageNamed:@"elephant"]];
        [scrollView addSubview:imageview];
    }
    UIButton* button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"原网址" forState:UIControlStateNormal];
    [scrollView addSubview:button];
    frame.origin.y+=frame.size.height;
    frame.size.height=50;
    frame.origin.x=thisScreenWidth-80;
    frame.size.width=80;
    button.frame=frame;
    
    UITextView* detail=[UITextView new];
    frame.origin.y+=frame.size.height;
    frame.origin.x=10;
    //定义这个字符串画到界面上时的属性，例如文字大小和颜色
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:30],NSForegroundColorAttributeName:[UIColor blackColor]};
    //根据设定的最大宽度 算出字符串需要多高才能显示
    CGSize size=[self.homeNews.descript boundingRectWithSize:CGSizeMake(self.view.frame.size.width-20, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    frame.size=size;
    detail.frame=frame;
    detail.scrollEnabled=NO;
    detail.text=self.homeNews.descript;
    detail.font=[UIFont systemFontOfSize:30];
    [scrollView addSubview:detail];
    detail.editable=NO;
    //算出滚动的高度
    scrollView.contentSize=CGSizeMake(0, detail.origin.y+detail.size.height);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectNews:(UIBarButtonItem*)sender
{
    BmobUser* bUser=[BmobUser getCurrentUser];
    if (!bUser) {
        LoginViewController* loginViewController=[LoginViewController new];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.leftsilderVC.navigationController pushViewController:loginViewController animated:YES];
        return;
    }
    else{
        NSString* documentPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString* fmdbPath=[documentPath stringByAppendingPathComponent:@"fmdb.sqlite"];
        //sqlite3_open 创建了一个空的数据库
        self.database=[FMDatabase databaseWithPath:fmdbPath];
        //打开数据库 !!!手动执行打开操作
        [self.database open];
        
        BOOL isSuccess=[self.database executeUpdate:@"create table if not exists news (id integer primary key,title text,ctime text,detail text)"];
        if (!isSuccess) {
            NSLog(@"创建表失败%@",[self.database lastError]);
        }
        BOOL isSuccessinsert=[self.database executeUpdate:@"insert into news(title,ctime,detail) values (?,?,?)",self.homeNews.title,self.homeNews.ctime,self.homeNews.descript];
        if (!isSuccessinsert) {
            NSLog(@"插入失败%@",[self.database lastError]);
        }
        
        [self.database close];
        
        [sender setTitle:@"已收藏"];
        sender.enabled=NO;
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

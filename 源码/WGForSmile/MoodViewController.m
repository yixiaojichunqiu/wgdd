//
//  MoodViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "MoodViewController.h"
#import "TicklerViewController.h"
#import "WeatherView.h"
#import "WeatherModel.h"
#import "UILabel+TRLabel.h"
#import <CoreLocation/CoreLocation.h>
@interface MoodViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) WeatherView * weatherView;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) CLLocationManager * mgr;
@end

@implementation MoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建tableview
    [self setUpTableView];
    [self setUpHeadView];
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
-(void)setUpHeadView
{
    //创建自定义头部视图
//    self.headerView=[[TRHeaderView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //设置tableview的headview
//    self.tableView.tableHeaderView=self.headerView;
}

-(void)setUpTableView
{
    UIImageView* imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
    imageView.frame=self.view.bounds;
    [self.view addSubview:imageView];
    UITableView* tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorColor=[UIColor colorWithWhite:0 alpha:0];
    tableView.pagingEnabled=YES;
    tableView.backgroundColor=[UIColor clearColor];
    self.tableView=tableView;
    [self.view addSubview:self.tableView];
    

}

#pragma mark====tableviewdelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//    }
    UITableViewCell *cell=[[UITableViewCell alloc]init];//静态
    if (indexPath.section==0) {
        cell.textLabel.text=@"或许某一刻，你的灵感就悄然降临，记录下来，这是一笔财富";
    }
    else if(indexPath.section==1)
    {
        CGRect frame=cell.bounds;
        frame.size.height=[UIScreen mainScreen].bounds.size.height-100;
        self.weatherView=[[WeatherView alloc]initWithFrame:frame];
        [cell addSubview:self.weatherView];
    }
    else
    {
        cell.textLabel.text=@"搜搜";
        UILabel* label=[UILabel labelWithFrameByCategory:CGRectMake(20, 80, 100, 30)];
        label.text=@"简易英译汉";
        self.label=cell.textLabel;
        [cell addSubview:label];
        UITextField* textField=[[UITextField alloc]init];
        textField.backgroundColor=[UIColor clearColor];
        textField.borderStyle=UITextBorderStyleRoundedRect;
        textField.frame=CGRectMake(130, 80, 100, 30);
        self.textField=textField;
        [cell addSubview:textField];
        UIButton* button=[UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont boldSystemFontOfSize:20];
        [button addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        button.frame=CGRectMake(240, 80, 50, 30);
        [cell addSubview:button];
    }
    cell.textLabel.numberOfLines=0;
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height-44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [self.navigationController pushViewController:[TicklerViewController new] animated:YES];
    }
    else if(indexPath.section==1){
        [self location];
        
    }
    [self.view endEditing:YES];
}

#pragma mark--- getjson

-(void)getJSONData:(NSString*)cityName
{

    //接地图定位的通知
    NSString* urlStr=[NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%@&num_of_days=2&format=json&tp=6&key=16e14525272add5a09bd29ce27573",cityName];
    NSURLRequest* request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //获取单例对象nsurksession
    NSURLSession* session=[NSURLSession sharedSession];
    //创建数据任务对象 发送请求
    NSURLSessionDataTask* task=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error.userInfo);
        }
        NSInteger statusCode=[(NSHTTPURLResponse*)response statusCode];
        if (statusCode==200) {
            NSDictionary* weatherDic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateWeatherView:weatherDic];
            });
        }
        
    }];
    [task resume];
}

//解析数据更新天气界面
-(void)updateWeatherView:(NSDictionary*)jsonDic
{
    //使用jsondic对象 调用模型类方法解析
    NSDictionary *dataDic=jsonDic[@"data"];
    WeatherModel* weather=[WeatherModel weatherWithHeader:dataDic];
    
    self.weatherView.conditionsLabel.text=weather.conditionsStr;
    self.weatherView.temperatureLabel.text=weather.tempStr;
    self.weatherView.hiloLabel.text=[NSString stringWithFormat:@"最高温%@/最低温%@",weather.maxTempStr,weather.minTempStr];
    
}

#pragma mark---第三页的搜索

-(void)search:(UIButton*)sender
{
    NSString* textlower=[self.textField.text lowercaseString];
    
    [self searchJSON:textlower];
}

#pragma mark---第三页获取json 不知道这里怎么封装出去 其他线程从网上获取数据 到时候在block里 主线程已经回来了
-(void)searchJSON:(NSString*)text
{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/tranlateservice/translate";
    NSString *httpArg = [NSString stringWithFormat:@"query=%@&from=en&to=zh",text];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"34bc2b1aae5a608d7b0af8e7453a4c1d" forHTTPHeaderField: @"apikey"];
    __block NSString* resultStr;
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   //NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                   self.label.text=@"翻译失败,注意不要有空格";
                                       });
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   if (responseCode==200) {
                                       NSDictionary* dreamDic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                       NSString* path=[[NSBundle mainBundle]pathForResource:@"123.plist" ofType:nil];
                                       [dreamDic writeToFile:path atomically:YES];
                                       NSLog(@"%@",dreamDic);
                                       resultStr=dreamDic[@"retData"][@"trans_result"][0][@"dst"];
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.label.text=resultStr;
                                        });
                                   }
                               }
                           }];
}

-(void)location{
    self.mgr=[[CLLocationManager alloc]init];
    self.mgr.delegate=self;
    if ([[UIDevice currentDevice].systemVersion doubleValue]>=8.0) {
        //使用期间定位
        [self.mgr requestWhenInUseAuthorization];
    }
    else
    {
        //小于8.0
        [self.mgr startUpdatingLocation];
    }
}


#pragma mark---
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"用户允许定位");
            //设定一下定位准确性
            self.mgr.desiredAccuracy=kCLLocationAccuracyBest;
            //开始更新位置
            [self.mgr startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"用户不允许定位");
            break;
        default:
            break;
    }
}
//通知用户的位置
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations 数组 按照一定的先后顺序，数组中的最后一项是最新的位置
    CLLocation* location=[locations lastObject];
    //NSLog(@"%f %f",location.coordinate.latitude,location.coordinate.longitude);
    NSString* str=[NSString stringWithFormat:@"%lf,%lf",location.coordinate.latitude,location.coordinate.longitude];
    [self getJSONData:str];
    //反地理编码
    //1创建地理编码对象
    CLGeocoder *coder=[CLGeocoder new];
    //2发送请求
    [coder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        //
        for (CLPlacemark* placemark in placemarks) {
            //NSLog(@"详细信息%@",placemark.addressDictionary[@"City"]);
            self.weatherView.cityLabel.text=placemark.addressDictionary[@"City"];
//            NSString* str=placemark.addressDictionary[@"City"];
//            str=[str substringToIndex:str.length-1];
//            [self getJSONData:str];
            
        //这里本应该封装到工具类
            NSString* plistPath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:@"weather.plist"];
            NSArray* weatherArray=@[self.weatherView.cityLabel.text,self.weatherView.conditionsLabel.text,self.weatherView.temperatureLabel.text,self.weatherView.hiloLabel.text];
            [weatherArray writeToFile:plistPath atomically:YES];
            
        }
    }];
    [self.mgr stopUpdatingLocation];//停止定位
}

@end

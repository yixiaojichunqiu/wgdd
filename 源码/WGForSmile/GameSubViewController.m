//
//  GameSubViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/13.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "GameSubViewController.h"

@interface GameSubViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView * webView;
@end

@implementation GameSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIWebView* webView=[UIWebView new];
    webView.frame=self.view.frame;
    webView.tag=32;
    self.webView=webView;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlName]]];
    [self.view addSubview:webView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _webView.delegate = nil;
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    _webView=nil;
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
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

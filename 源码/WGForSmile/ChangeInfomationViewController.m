//
//  ChangeInfomationViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/17.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "ChangeInfomationViewController.h"
#import <BmobSDK/Bmob.h>
#import "Masonry.h"

@interface ChangeInfomationViewController ()
@property (nonatomic,strong) UITextField * textField;
@end

@implementation ChangeInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    UITextField* textField=[UITextField new];
    textField.placeholder=@"请输入您要改的昵称";
    
    textField.borderStyle=UITextBorderStyleRoundedRect;
    textField.backgroundColor=[UIColor clearColor];
    self.textField=textField;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.top.equalTo(self.view).with.offset(120);
        make.right.equalTo(self.view).with.offset(-40);
        make.height.mas_equalTo(@30);
    }];
    
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor=[UIColor blueColor];
    [button setTitle:@"修改" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(40);
        make.top.equalTo(textField.mas_bottom).with.offset(80);
        make.right.equalTo(self.view).with.offset(-40);
        make.height.mas_equalTo(@30);

    }];
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:(UIButton*)sender
{
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bUser setObject:self.textField.text forKey:@"nickName"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            self.block(self.textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (error) {
            NSLog(@"error %@",[error description]);
        }
    }];
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

//
//  EditViewController.m
//  WGForSmile
//
//  Created by tarena on 15/11/9.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()
@property (nonatomic,strong) UITextView * textView;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    UITextView *textView=[[UITextView alloc]init];
    textView.frame=self.view.bounds;
    textView.text=self.textViewString;
    self.textView=textView;
    [self.view addSubview:textView];
    
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

-(void)save:(UIBarButtonItem*)sender
{
    if (self.textView.text.length==0) {
        return;
    }
    if ([self.behaviour isEqualToString:@"编辑"]) {
        [self.delegate addText:self.textView.text andin:self.textIndex];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self.behaviour isEqualToString:@"添加"]) {
        [self.delegate addText:self.textView.text];
        [self.navigationController popViewControllerAnimated:YES];
    }

}
@end

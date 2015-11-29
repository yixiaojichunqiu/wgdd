//
//  BooksContentDataViewController.m
//  PageViewControllerDemo
//
//  Created by tarena on 15/11/12.
//  Copyright © 2015年 Sumtice：http://sacrelee.me. All rights reserved.
//

#import "BooksContentDataViewController.h"

@interface BooksContentDataViewController ()
@property (nonatomic,strong) NSArray * contentArray;

@end

@implementation BooksContentDataViewController
-(NSArray *)contentArray
{
    if (!_contentArray) {
        _contentArray=[NSArray array];
    }
    return _contentArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict=@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor blackColor]};
    //根据设定的最大宽度 算出字符串需要多高才能显示
    NSString* str=self.content;
    //str=@"2222";
    CGSize size=[str boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
    //NSLog(@"算出的需要多高才能显示%lf",size.height);
    //NSLog(@"view的高度%lf",self.view.frame.size.height-40);
    double i=size.height/(self.view.frame.size.height-40);
    //NSLog(@"%d",(int)i);
    //NSLog(@"算出的高度是屏幕的几倍%lf",i);
    //NSLog(@"字符串总长度%lu",(unsigned long)str.length);
    int j=str.length/i;
    //NSLog(@"字符串应该的长度%d",j);
    NSMutableArray* array=[NSMutableArray new];
    for (int m=0; m<(int)i+1; m++) {
        if (m==(int)i) {
            NSString* sub=[str substringFromIndex:m*(j)];
            [array addObject:sub];
            break;
        }
        int x=m*j;
        //int y=(m+1)*j-1;
        
        NSString* sub=[str substringWithRange:NSMakeRange(x,j)];
        //NSLog(@"每个长度%lu",sub.length);
        [array addObject:sub];
    }
    self.contentArray=array;
    
    // Do any additional setup after loading the view.
    CGFloat height = self.view.bounds.size.height;
    CGFloat width = self.view.bounds.size.width;
    self.view.backgroundColor = [UIColor grayColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = _backColor;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake( width - 200, height - 45, 200, 60);
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"第%@页",_index];
    [self.view addSubview:label];
    
    UITextView* text=[[UITextView alloc]init];
    text.tag=32;
    text.frame=CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20);
    text.backgroundColor=[UIColor clearColor];
    text.font=[UIFont systemFontOfSize:20];
    text.editable=NO;
    int index=[self.index intValue];
    if (index-1<self.contentArray.count) {
        text.text=self.contentArray[index-1];
    }
    [self.view addSubview:text];
    
    //需求用户双击界面 返回上层
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    //设置需要点按的次数
    tapGR.numberOfTapsRequired=2;
    //设置需要触点的个数
    tapGR.numberOfTouchesRequired=1;
    //把点击手势添加到self.view上
    [text addGestureRecognizer:tapGR];
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

#pragma mark===返回手势 后加

-(void)tap:(UITapGestureRecognizer*)gr
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

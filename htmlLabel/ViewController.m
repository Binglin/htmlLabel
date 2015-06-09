//
//  ViewController.m
//  htmlLabel
//
//  Created by Zhenglinqin on 15/6/8.
//  Copyright (c) 2015年 Binglin. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+htmlText.h"

@interface ViewController ()<NSXMLParserDelegate>
{
    UILabel *del;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *str = @"<p><font color=orange><b><strike color='green'><u color='#00ffff'>bold</u></strike></b></font>  <uu color='#0000ff'>and</uu> <i>italic</i> style <a href='www.baidu.com'>百度</a><bi>bi</bi>你好    // Do any additional setup after loading the view, typically from a nib.</p><p>p1</p><p>p2</p><font size=14 color='red'>¥</font><font size=24 color='red'><del>29</del></font> <font><del>¥100</del></font>";
    
    del = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 300, 400)];
    del.numberOfLines = 0;
    del.text   = @"heihei";
    [del setHTMLText:str];
    
    
    
//    del.backgroundColor = [UIColor redColor];
    [self.view addSubview:del];
    
//    del.paragraphStyle.lineSpacing = 10;
    del.paragraphStyle.paragraphSpacing = 0;
//    del.paragraphStyle.firstLineHeadIndent = 40.f;
//    del.paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    del.paragraphStyle.headIndent = 20.f;
    [del layoutText];
    [del sizeToFit];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

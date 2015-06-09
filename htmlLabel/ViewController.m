//
//  ViewController.m
//  htmlLabel
//
//  Created by Zhenglinqin on 15/6/8.
//  Copyright (c) 2015年 Binglin. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+htmlText.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *del;
    NSArray *listData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *del_html = @"<font color=orange><b><strike><u>bold</u></strike></b></font>";
    NSString *bold  = @"<b>bold</b>";
    NSString *italic  = @"<i>italic</i>";
    NSString *bold_italic  = @"<bi>bold_italic</bi>";
    NSString *link  = @"<a href='www.baidu.com' style=color:red;fontSize:30>百度</a>";
    NSString *under  = @"<u>underline</u>";

    NSString *DoubleUnder  = @"<uu>DoubleUnder</uu>";
    NSString *deleteLine   = @"<del>删除线</del>";
    NSString *insert  = @"<ins>insert</ins>";
    NSString *paragraph  = @"<p>paragraph</p>";
    
    NSString *style = @"style";
    NSString *promotion = @"<font size=14 color='red'>¥</font><font size=24 color=red><del>29</del></font> <font><del>¥100</del></font> ";
    
    
    
    listData = @[link,del_html,bold,italic,bold_italic,link,under,DoubleUnder,deleteLine,insert,style,paragraph,promotion];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    [cell.textLabel setHTMLText:listData[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listData.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

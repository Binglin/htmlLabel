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
    NSString *testSTR1 = @"<font color=\"#ff6600\" size=\"24\">29元 &nbsp;</font><font size=\"20\"><del>99元</del></font>";
    NSString *TEST2 = @"<b>bold</b>,<i>italic</i> and <u>underlined</u> text, and <font face='HelveticaNeue-CondensedBold' size=20 color='#CCFF00'>text with custom font and color</font>";
    
    NSString *TEST3 = @"<font color='#99cc00' style='font-size: 13px;'>sdfrsd</font><span style='color: rgb(0, 0, 0);'><span style='font-size: 13px;'>f &nbsp; &nbsp;s</span><font size='4'>dfsdf</font></span>";
    
    NSString *del_html = @"<font color=orange><b><strike><u>bold</u></strike></b></font>";
    NSString *bold  = @"<b>bold</b>";
    NSString *italic  = @"<i>italic</i>";
    NSString *bold_italic  = @"<bi>bold_italic</bi>";
    NSString *link  = @"<a href='www.baidu.com' style=color:\"#FF0000\";fontSize:30px>百度</a>";
    NSString *under  = @"<u>underline</u>";

    NSString *DoubleUnder  = @"<uu>DoubleUnder</uu>";
    NSString *deleteLine   = @"<del>删除线</del>";
    NSString *insert  = @"<ins>insert</ins>";
    NSString *paragraph  = @"<p>paragraph</p>";
    
    NSString *style = @"style";
    NSString *promotion = @"<font size=14 color='red'>¥</font><font size=24 color=red><del>29</del></font> <font><del>¥100</del></font> ";
    
    
    
    listData = @[link,testSTR1,TEST2,TEST3,link,del_html,bold,italic,bold_italic,link,under,DoubleUnder,deleteLine,insert,style,paragraph,promotion];
    
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
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell.textLabel heightWithWidth:CGRectGetWidth(self.view.frame) - 20];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listData.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

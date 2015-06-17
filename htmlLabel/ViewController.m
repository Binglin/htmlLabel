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
    
//    [self.rtLabel setText:@"<small>small</small><medium>medium</medium><big>large</big><del><small><span>del</span>"/*[NSString stringWithFormat:@"<font size=16px color=p0_orange>%.0f</font><font size=10px color=p0_orange>元</font>  <s><font size=14px color=p0_gray>¥%.0f</font></s><span style='font-size:30px'> span font 30</span>",20.f,100.f]*/];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSString *testSTR1 = @"<font color=\"#ff6600\" size=\"24\">29元 &nbsp;</font><font size=\"20\"><del>99元</del></font>";
    NSString *TEST2 = @"<b>bold</b>,<i>italic</i> and <u>underlined</u> text, and <font face='HelveticaNeue-CondensedBold' size=20 color='#CCFF00'>text with custom font and color</font>";
    
    NSString *TEST3 = @"<font color='#99cc00' style='font-size:  13px;'>sdfrsd</font><span style='color: rgb(0, 0, 0);'><span style='font-size:20px;'>f &nbsp; &nbsp;s</span><font size='4'>dfsdf</font></span>";
    
    NSString *del_html = @"<font color=orange><b><strike><u>bold</u></strike></b></font>";
    NSString *bold  = @"<b>bold</b>";
    NSString *italic  = @"<i>italic</i>";
    NSString *bold_italic  = @"<bi>bold_italic</bi>";
    NSString *link  = @"<a href='www.baidu.com'>百度</a>";//style=color:\"#FF0000\";fontSize:30px
    NSString *under  = @"<u>underline</u>";

    NSString *DoubleUnder  = @"<uu>DoubleUnder</uu>";
    NSString *deleteLine   = @"<del>删除线</del>";
    NSString *insert  = @"<ins>insert</ins>";
    NSString *paragraph  = @"<p>paragraph</p>";
    
    NSString *style = @"style";
    NSString *promotion = @"<font size=14 color='red'>¥</font><font size=24 color=red><del>29</del></font> <font><del>¥100</del></font><font size=14 color='red'>¥</font><font size=24 color=red><del>29</del></font> <font><del>¥100</del></font> ";
    
    NSString *htmlString = @"<small>small</small><medium>medium</medium><big>large</big><del><small><span>del</span>";
    
    NSAttributedString *attri = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    const char *charD = OS_STRINGIFY(<html>
                                     <head>
                                     <style type="text/css">
                                     h1 {color: gray;font-size: 14px}
                                     h6 {color: orange;font-size: 16px}
                                     body {color:black;font-size:16px}
                                     span {color:orange;font-size: 16px}
                                     p {color: blue}
                                     </style>
                                     </head>
                                    
                                     <h1>购买须知</h1>
                                     
                                     <p><span>适用范围:</span><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;全场通用</p>
                                     
                                     <p><span>有效期:</span><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;2014-2-14至2015-12-14</p>
                                     
                                     <p><span>不可用日期:</span><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;2014-2-14至2015-12-14</p>
                                     
                                     <p><span>适用时间:</span><br>
                                     &nbsp;&nbsp;&nbsp;&nbsp;09:00-21:00</p>
                                     
                                     <p><span>使用规则:</span><br>
                                     <table><li>无需预约 高峰时期可能需要等位</li><li>可叠加使用</li></table>
                                     </p>
                                     
                                     </body>
                                     
                                     </html>);
    NSString *tt = [NSString stringWithUTF8String:charD];
    
    listData = @[htmlString,link,testSTR1,TEST2,TEST3,link,del_html,bold,italic,bold_italic,link,under,DoubleUnder,deleteLine,insert,style,paragraph,promotion,[tt stringByReplacingOccurrencesOfString:@"\"" withString:@"'"]];
    
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
    if (indexPath.row != listData.count - 1) {
        [cell.textLabel setHTMLText:listData[indexPath.row]];
    }else{
        NSString *data = listData[indexPath.row];
        NSAttributedString *attri = [[NSAttributedString alloc] initWithData:[data dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        cell.textLabel.attributedText = attri;
    }
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

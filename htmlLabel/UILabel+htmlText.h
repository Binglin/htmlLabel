//
//  UILabel+htmlText.h
//  htmlLabel
//
//  Created by Zhenglinqin on 15/6/8.
//  Copyright (c) 2015年 Binglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLComponentAssemble : NSObject

@property (nonatomic, strong) NSMutableArray *textComponent;
@property (nonatomic, copy  ) NSString *pureText;

@end


@interface HTMLComponent : NSObject

@property (nonatomic, assign) NSInteger componentIndex;
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSMutableDictionary * attributes;
@property (nonatomic, assign) NSInteger        position;

@end


@interface NSString (html_component)


- (HTMLComponentAssemble *)getHTMLComponentWithparagraphReplacement:(NSString*)paragraphReplacement;

@end


@interface UILabel (htmlText)

- (void)setHTMLText:(NSString *)text;

@end



@interface UILabel (layout)

@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;

- (void)layoutText;

- (CGSize)bestSize;

@end

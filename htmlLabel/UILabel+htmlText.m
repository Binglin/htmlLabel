//
//  UILabel+htmlText.m
//  htmlLabel
//
//  Created by Zhenglinqin on 15/6/8.
//  Copyright (c) 2015年 Binglin. All rights reserved.
//

#import "UILabel+htmlText.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

@implementation HTMLComponentAssemble


@end



@implementation HTMLComponent


@end



@implementation NSString (html_component)

- (HTMLComponentAssemble *)getHTMLComponentWithparagraphReplacement:(NSString*)paragraphReplacement{
    
    NSScanner *scanner = nil;
    NSString *text = nil;
    NSString *tag = nil;
    
    NSString *data = self;
    
    NSMutableArray *components = [NSMutableArray array];
    
    NSInteger last_position = 0;
    scanner = [NSScanner scannerWithString:data];
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        NSString *delimiter = [NSString stringWithFormat:@"%@>", text];
        NSInteger position = [data rangeOfString:delimiter].location;
        if (position!=NSNotFound)
        {
            if ([delimiter rangeOfString:@"<p"].location==0)
            {
                data = [data stringByReplacingOccurrencesOfString:delimiter withString:paragraphReplacement options:NSCaseInsensitiveSearch range:NSMakeRange(last_position, position+delimiter.length-last_position)];
            }
            else
            {
                data = [data stringByReplacingOccurrencesOfString:delimiter withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(last_position, position+delimiter.length-last_position)];
            }
            
            data = [data stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
            data = [data stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
            data = [data stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        }
        
        if ([text rangeOfString:@"</"].location==0)
        {
            // end of tag
            tag = [text substringFromIndex:2];
            if (position!=NSNotFound)
            {
                for (NSInteger i = [components count]-1; i>=0; i--)
                {
                    HTMLComponent *component = [components objectAtIndex:i];
                    if (component.text==nil && [component.tag isEqualToString:tag])
                    {
                        NSString *text2 = [data substringWithRange:NSMakeRange(component.position, position-component.position)];
                        component.text = text2;
                        break;
                    }
                }
            }
        }
        else
        {
            // start of tag
            NSArray *textComponents = [[text substringFromIndex:1] componentsSeparatedByString:@" "];
            tag = [textComponents objectAtIndex:0];
            //NSLog(@"start of tag: %@", tag);
            NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
            for (NSUInteger i=1; i<[textComponents count]; i++)
            {
                NSArray *pair = [[textComponents objectAtIndex:i] componentsSeparatedByString:@"="];
                
                if ([pair count] > 0) {
                    
                    NSString *key = [[pair objectAtIndex:0] lowercaseString];
                    
                    if ([key isEqualToString:@"style"]) {
                        NSString *styleString = pair[1];
                        [styleString stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSArray *styleAttr = [styleString componentsSeparatedByString:@";"];
                        
                        NSMutableDictionary *styleDic = [NSMutableDictionary dictionaryWithCapacity:styleAttr.count];

                        for (NSString *styleItem in styleAttr) {
                            NSArray *styleItemKeyValue = [styleItem componentsSeparatedByString:@":"];
                            [styleDic setObject:styleItemKeyValue[1] forKey:styleItemKeyValue[0]];
                        }
                        
                        [attributes setObject:styleDic forKey:key];
                        continue;
                    }
                    
                    if ([pair count]>=2) {
                        // Trim " charactere
                        NSString *value = [[pair subarrayWithRange:NSMakeRange(1, [pair count] - 1)] componentsJoinedByString:@"="];
                        value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, 1)];
                        value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSLiteralSearch range:NSMakeRange([value length]-1, 1)];
                        
                        [attributes setObject:value forKey:key];
                    } else if ([pair count]==1) {
                        [attributes setObject:key forKey:key];
                    }
                }
            }
            HTMLComponent *component = [HTMLComponent new];
            component.tag = tag;
            component.attributes = attributes;
            component.position = position;
            [components addObject:component];
        }
        last_position = position;
    }
    
    HTMLComponentAssemble *assemble = [HTMLComponentAssemble new];
    assemble.textComponent = components;
    assemble.pureText = data;
    
    return assemble;
}

@end



@implementation UILabel (htmlText)

- (void)setHTMLText:(NSString *)text{
    HTMLComponentAssemble *components = [text getHTMLComponentWithparagraphReplacement:@"\n"];
    NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:components.pureText ];
    for (HTMLComponent *component in components.textComponent){
        NSString *TAG =[component.tag lowercaseString];
        if ([TAG isEqualToString:@"i"]) {
            [self applyFontStype:kCTFontTraitItalic attrText:attriText withComponent:component];
        }else if([TAG isEqualToString:@"b"]) {
            [self applyFontStype:kCTFontTraitBold   attrText:attriText withComponent:component];
        }
        else if([TAG isEqualToString:@"bi"]) {
            [self applyFontStype:kCTFontTraitItalic|kCTFontTraitBold   attrText:attriText withComponent:component];
        }
        else if([TAG isEqualToString:@"a"]) {
            [self appleURLLink:attriText withComponent:component];
        }
        else if([TAG isEqualToString:@"u"] || [TAG isEqualToString:@"ins"]) {
            [self applyLineType:kCTUnderlineStyleSingle attrText:attriText withComponent:component];
        }
        else if([TAG isEqualToString:@"uu"]) {
            [self applyLineType:kCTUnderlineStyleDouble attrText:attriText withComponent:component];
        }
        else if([TAG isEqualToString:@"del"] ||[TAG isEqualToString:@"strike"]) {
            [self appleDeleteLineTOattrText:attriText withComponent:component];
        }
        else if([TAG isEqualToString:@"font"]) {
            [self setColorForAttributeStr:attriText Attribute:NSForegroundColorAttributeName component:component];
            [self setFontSizeForAttributeStr:attriText Attribute:NSFontAttributeName component:component];
        }
        else if([TAG isEqualToString:@"p"]) {
            
        }
    }
    self.attributedText = attriText;
    CFAttributedStringRef stringRef = (__bridge CFAttributedStringRef)(attriText);
    
}


- (void)applyFontStype:(CTFontSymbolicTraits) traits attrText:(NSMutableAttributedString *)attriText withComponent:(HTMLComponent *)component{
    CFTypeRef  actualFontRef = CFAttributedStringGetAttribute((__bridge CFMutableAttributedStringRef)attriText, component.position, kCTFontAttributeName, NULL);
    CTFontRef FontRef = CTFontCreateCopyWithSymbolicTraits(actualFontRef, 0.0, NULL, traits, traits);
    UIFont *finalFont ;
    
    if (!FontRef) {
        
        CGFloat fontSize = actualFontRef ? CTFontGetSize(FontRef) : self.font.pointSize;
        if (traits ==    kCTFontTraitItalic) {
            finalFont = [UIFont italicSystemFontOfSize:fontSize];
        }else if (traits == kCTFontTraitBold){
            finalFont = [UIFont boldSystemFontOfSize:fontSize];
        }else if (traits == (kCTFontTraitItalic | kCTFontTraitBold)){
            CTFontRef boldItalic = CTFontCreateWithName ((__bridge CFStringRef)self.font.fontName, [self.font pointSize], NULL);
            boldItalic = CTFontCreateCopyWithSymbolicTraits(boldItalic, 0.0, NULL, traits, traits);

            finalFont = (__bridge UIFont *)(boldItalic);
        }
        
    }else{
        finalFont = (__bridge UIFont *)(FontRef);
    }

    
    [attriText addAttribute:NSFontAttributeName value:finalFont range:NSMakeRange(component.position, [component.text length])];
    [self   setColorForAttributeStr:attriText Attribute:NSForegroundColorAttributeName component:component];
}


- (void)applyLineType:(CTUnderlineStyle)stype attrText:(NSMutableAttributedString *)attriText withComponent:(HTMLComponent *)component{
    [attriText addAttribute:NSUnderlineStyleAttributeName value:@(stype) range:NSMakeRange(component.position, [component.text length])];
    [self setColorForAttributeStr:attriText Attribute:NSUnderlineColorAttributeName component:component];
}

- (void)appleDeleteLineTOattrText:(NSMutableAttributedString *)attriText withComponent:(HTMLComponent *)component{
    
    [attriText addAttribute:NSStrikethroughStyleAttributeName value:@(1) range:NSMakeRange(component.position, [component.text length])];
    [self setColorForAttributeStr:attriText Attribute:NSStrikethroughColorAttributeName component:component];
}

- (void)appleURLLink:(NSMutableAttributedString *)attri  withComponent:(HTMLComponent *)component{
    NSString *lineKey = @"URLlink";
    [attri addAttribute:lineKey value:[component.attributes[@"href"] stringByReplacingOccurrencesOfString:@"'" withString:@""] range:NSMakeRange(component.position, [component.text length])];
    [self setColorForAttributeStr:attri Attribute:NSForegroundColorAttributeName component:component];
    [self setFontSizeForAttributeStr:attri Attribute:nil component:component];
    [self applyLineType:kCTUnderlineStyleSingle attrText:attri withComponent:component];
}

- (void)applyFont:(NSMutableAttributedString *)attri  withComponent:(HTMLComponent *)component{
    
}

-  (void)setColorForAttributeStr:(NSMutableAttributedString  *)attrStr Attribute:(NSString  *)attr component:(HTMLComponent *)component{
    UIColor *color = [self getComponentColor:component];
    if (color) {
        [attrStr addAttribute:attr value:color range:NSMakeRange(component.position, [component.text length])];
    }
}

- (void)setFontSizeForAttributeStr:(NSMutableAttributedString  *)attrStr Attribute:(NSString  *)attr component:(HTMLComponent *)component{
    NSString *size_st = component.attributes[@"size"];
    if (size_st == nil) {
        size_st = [component.attributes[@"style"] objectForKey:@"fontSize"];
    }
    if (size_st) {
        CGFloat size = [size_st floatValue];
        [attrStr addAttribute:NSFontAttributeName  value:[UIFont systemFontOfSize:size] range:NSMakeRange(component.position, [component.text length])];
    }
}

- (UIColor *)getComponentColor:(HTMLComponent *)component{
    NSString *colorText = component.attributes[@"color"];
    if (colorText == nil) {
        colorText = [component.attributes[@"style"] objectForKey:@"color"];
    }
    colorText = [colorText stringByReplacingOccurrencesOfString:@"'" withString:@""];
    if (colorText)
    {
        if ([colorText rangeOfString:@"#"].location != NSNotFound) {
            colorText = [colorText stringByReplacingOccurrencesOfString:@"#" withString:@""];
            return [self colorFromHexString:colorText];
        }
        else{
            colorText = [colorText stringByAppendingString:@"Color"];
            SEL colorSel = NSSelectorFromString(colorText);
            if ([UIColor respondsToSelector:colorSel])
            {
                UIColor *_color = [UIColor performSelector:colorSel];
                return _color;
            }
        }
    }
    
    return nil;
}

- (UIColor *)colorFromHexString:(NSString *)hexString{
    
    unsigned int hex ;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
    
    NSInteger red   = (hex & 0xff0000) >> 16;
    NSInteger green = (hex & 0x00ff00) >> 8;
    NSInteger blue  = (hex & 0x0000ff);
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:1.f];
}


@end




@implementation UILabel (layout)

- (void)setParagraphStyle:(NSMutableParagraphStyle *)paragraphStyle{
    objc_setAssociatedObject(self, @selector(paragraphStyle), paragraphStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSMutableParagraphStyle *)paragraphStyle{
    id pStype =  objc_getAssociatedObject(self, _cmd);
    if (pStype == nil) {
        NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
        pStype                  = style;
        [self setParagraphStyle:style];
    }
    return pStype;
}
//
//- (void)setLineSpace:(CGFloat)lineSpace{
//    self.paragraphStyle.lineSpacing = lineSpace;
//}
//
//- (CGFloat)lineSpace{
//    return [self.paragraphStyle lineSpacing];
//}

- (void)layoutText{
    NSMutableAttributedString *selfAttr = [self.attributedText mutableCopy];
    [selfAttr addAttribute:NSParagraphStyleAttributeName value:self.paragraphStyle range:NSMakeRange(0, selfAttr.length)];
    self.attributedText = selfAttr;
}

- (CGSize)bestSize{
    return [self sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT)];
}

- (CGFloat)heightWithWidth:(CGFloat)width{
    return [self sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}
@end


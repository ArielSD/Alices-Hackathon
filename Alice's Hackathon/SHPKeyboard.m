//
//  SHPKeyboard.m
//  Alice's Hackathon
//
//  Created by Ariel Scott-Dicker on 6/16/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "SHPKeyboard.h"

@implementation SHPKeyboard

+ (instancetype)keyboardFromProductDictionary:(NSDictionary *)productDictionary
                            variantDictionary:(NSDictionary *)variantDictionary {
    SHPKeyboard *keyboard = [SHPKeyboard new];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    keyboard.name = productDictionary[@"title"];
    keyboard.color = variantDictionary[@"title"];
    keyboard.price = [numberFormatter numberFromString:variantDictionary[@"price"]];
    keyboard.weight = variantDictionary[@"grams"];
    return keyboard;
}

@end

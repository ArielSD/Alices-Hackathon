//
//  SHPComputer.m
//  Alice's Hackathon
//
//  Created by Ariel Scott-Dicker on 6/16/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "SHPComputer.h"

@implementation SHPComputer

+ (instancetype)computerFromProductDictionary:(NSDictionary *)productDictionary
                            variantDictionary:(NSDictionary *)variantDictionary {
    SHPComputer *computer = [SHPComputer new];
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    computer.name = productDictionary[@"title"];
    computer.color = variantDictionary[@"title"];
    computer.price = [numberFormatter numberFromString:variantDictionary[@"price"]];
    computer.weight = variantDictionary[@"grams"];
    return computer;
}

@end

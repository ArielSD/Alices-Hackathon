//
//  SHPKeyboard.h
//  Alice's Hackathon
//
//  Created by Ariel Scott-Dicker on 6/16/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHPKeyboard : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *weight;

+ (instancetype)keyboardFromProductDictionary:(NSDictionary *)productDictionary
                            variantDictionary:(NSDictionary *)variantDictionary;

@end

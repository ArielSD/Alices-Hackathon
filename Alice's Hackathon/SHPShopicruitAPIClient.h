//
//  SHPShopicruitAPIClient.h
//  Alice's Hackathon
//
//  Created by Ariel Scott-Dicker on 6/16/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHPShoppingListViewController;

@interface SHPShopicruitAPIClient : NSObject

+ (void)getComputersAndKeyboardsFromAPIPage:(NSUInteger)page
                           inViewController:(SHPShoppingListViewController *)viewController
                          withSuccess:(void (^)(NSDictionary *hardware))successBlock;

@end

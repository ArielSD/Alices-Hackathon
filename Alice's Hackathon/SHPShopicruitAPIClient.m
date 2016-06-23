//
//  SHPShopicruitAPIClient.m
//  Alice's Hackathon
//
//  Created by Ariel Scott-Dicker on 6/16/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "SHPShopicruitAPIClient.h"
#import <UIKit/UIKit.h>
#import "SHPShoppingListViewController.h"

@implementation SHPShopicruitAPIClient

+ (void)getComputersAndKeyboardsFromAPIPage:(NSUInteger)page
                           inViewController:(SHPShoppingListViewController *)viewController
                                withSuccess:(void (^)(NSDictionary *hardware))successBlock {
    
    NSString *pageNumber = [NSString stringWithFormat:@"%lu", page];
    NSString *shopicruitURLString = [NSString stringWithFormat:@"http://shopicruit.myshopify.com/products.json?page=%@", pageNumber];
    NSURL *url = [NSURL URLWithString:shopicruitURLString];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithURL:url
                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                   if (error) {
                                                       
                                                       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Whoops!"
                                                                                                                                message:@"Something went wrong..."
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                       
                                                       UIAlertAction *action = [UIAlertAction actionWithTitle:@"Try Again"
                                                                                                        style:UIAlertActionStyleDefault
                                                                                                      handler:^(UIAlertAction *action) {
                                                                                                          viewController.buildingShoppingListLabel.hidden = NO;
                                                                                                          [viewController organizeShoppingList];
                                                                                                      }];
                                                       
                                                       [alertController addAction:action];
                                                       dispatch_async(dispatch_get_main_queue(), ^ {
                                                           [viewController presentViewController:alertController
                                                                                        animated:YES
                                                                                      completion:^{
                                                                                          viewController.buildingShoppingListLabel.hidden = YES;
                                                                                      }];
                                                       });
                                                       
                                                   } else {
                                                       NSDictionary *hardware = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                options:0
                                                                                                                  error:nil];
                                                       successBlock(hardware);
                                                   }
                                               }];
    [dataTask resume];
}

@end

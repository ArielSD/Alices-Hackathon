//
//  SHPShoppingListViewController.h
//  Alice's Hackathon
//
//  Created by Ariel Scott-Dicker on 6/15/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHPShopicruitAPIClient;

@interface SHPShoppingListViewController : UIViewController

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UILabel *buildingShoppingListLabel;

- (void)organizeShoppingList;

@end

//
//  SHPShoppingListViewController.m
//  Alice's Hackathon
//
//  Created by Ariel Scott-Dicker on 6/15/16.
//  Copyright © 2016 Ariel Scott-Dicker. All rights reserved.
//

#import "SHPShoppingListViewController.h"
#import "SHPShopicruitAPIClient.h"
#import "SHPComputer.h"
#import "SHPKeyboard.h"
#import "SHPShoppingListItemTableViewCell.h"

@interface SHPShoppingListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UILabel *aliceShoppingListLabel;
@property (strong, nonatomic) UILabel *totalWeightLabel;
@property (strong, nonatomic) UILabel *totalPriceLabel;
@property (strong, nonatomic) UITableView *shoppingListTableView;

@property (strong, nonatomic) NSMutableArray *computers;
@property (strong, nonatomic) NSMutableArray *keyboards;

@property CGFloat totalPrice;
@property CGFloat totalWeight;

@property NSUInteger APIPageNumber;

@end

@implementation SHPShoppingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.APIPageNumber = 1;

    self.computers = [NSMutableArray new];
    self.keyboards = [NSMutableArray new];
    
    [self configureShoppingListTableView];
    [self configureShoppingListLabel];
    [self configureTotalWeightLabel];
    [self configureTotalPriceLabel];
    [self configureLoadingScreen];
    
    [self organizeShoppingList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"Did receive memory warning");
}

#pragma mark - UI Layout

- (void)configureShoppingListTableView {
    self.shoppingListTableView = [UITableView new];
    [self.view addSubview:self.shoppingListTableView];
    
    self.shoppingListTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.shoppingListTableView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.shoppingListTableView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.shoppingListTableView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.shoppingListTableView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor
                                                          multiplier:6.0/8.0].active = YES;
    
    [self.shoppingListTableView registerClass:[SHPShoppingListItemTableViewCell class]
                       forCellReuseIdentifier:@"listItemCell"];
    
    self.shoppingListTableView.dataSource = self;
    self.shoppingListTableView.delegate = self;
}

- (void)configureShoppingListLabel {
    self.aliceShoppingListLabel = [UILabel new];
    [self.view addSubview:self.aliceShoppingListLabel];
    
    self.aliceShoppingListLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.aliceShoppingListLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.aliceShoppingListLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.aliceShoppingListLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor
                                                          constant:(self.view.frame.size.height) / 16].active = YES;
    
    self.aliceShoppingListLabel.text = @"Alice's Shopping List";
    self.aliceShoppingListLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configureTotalWeightLabel {
    self.totalWeightLabel = [UILabel new];
    [self.view addSubview:self.totalWeightLabel];
    
    self.totalWeightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.totalWeightLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.totalWeightLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.totalWeightLabel.topAnchor constraintEqualToAnchor:self.shoppingListTableView.bottomAnchor
                                                    constant:(self.view.frame.size.height) / 50].active = YES;
    
    self.totalWeightLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configureTotalPriceLabel {
    self.totalPriceLabel = [UILabel new];
    [self.view addSubview:self.totalPriceLabel];
    
    self.totalPriceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.totalPriceLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.totalPriceLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.totalPriceLabel.topAnchor constraintEqualToAnchor:self.totalWeightLabel.bottomAnchor].active = YES;
    
    self.totalPriceLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)configureLoadingScreen {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
    
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.activityIndicator.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.activityIndicator.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
    self.activityIndicator.backgroundColor = [UIColor whiteColor];
    
    self.buildingShoppingListLabel = [UILabel new];
    [self.view addSubview:self.buildingShoppingListLabel];
    
    self.buildingShoppingListLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.buildingShoppingListLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.buildingShoppingListLabel.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.buildingShoppingListLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor
                                                                 constant:(self.view.frame.size.height) / 8].active = YES;
    
    self.buildingShoppingListLabel.textAlignment = NSTextAlignmentCenter;
    self.buildingShoppingListLabel.text = @"Building your shopping list, Alice...";
    
    [self.activityIndicator startAnimating];
}

#pragma mark - Network Call

- (void)organizeShoppingList {
        [SHPShopicruitAPIClient getComputersAndKeyboardsFromAPIPage:self.APIPageNumber
                                                   inViewController:self
                                                     withSuccess:^(NSDictionary *hardware) {
                                                         
                                                         NSArray *products = hardware[@"products"];
                                                         
                                                         if (products.count != 0) {
                                                             for (NSDictionary *product in products) {
                                                                 [self pullOnlyComputersAndKeyboardsFromJSONDictionary:product];
                                                             }
                                                             self.APIPageNumber += 1;
                                                             [self organizeShoppingList];
                                                         }
                                                         else {
                                                             dispatch_async(dispatch_get_main_queue(), ^ {
                                                                 [self.activityIndicator stopAnimating];
                                                                 self.buildingShoppingListLabel.hidden = YES;
                                                                 
                                                                 [self sortComputersByPrice];
                                                                 [self sortKeyboardsByPrice];
                                                                 [self equalNumberOfComputersAndKeyboards];
                                                                 [self calculateTotalPrice];
                                                                 [self calculateTotalWeight];
                                                                 [self.shoppingListTableView reloadData];
                                                             });
                                                         }
                                                     }];
}

#pragma mark - Table View Datasource / Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        numberOfRows = self.computers.count;
    }
    else if (section == 1) {
        numberOfRows = self.keyboards.count;
    }
    return  numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = [NSString new];
    
    if (section == 0) {
        title = [NSString stringWithFormat:@"Computers: %lu", self.computers.count];
    }
    else if (section == 1) {
        title = [NSString stringWithFormat:@"Keyboards: %lu", self.computers.count];
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHPShoppingListItemTableViewCell *cell = [[SHPShoppingListItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"listItemCell"];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"listItemCell"
                                           forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        SHPComputer *computer = self.computers[indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:11.0]];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", computer.name, computer.color];
        
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [computer.price floatValue]];
    }
    else if (indexPath.section == 1) {
        SHPKeyboard *keyboard = self.keyboards[indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:11.0]];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", keyboard.name, keyboard.color];
        
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", [keyboard.price floatValue]];
    }
    return cell;
}

#pragma mark - Helper Methods

- (void)pullOnlyComputersAndKeyboardsFromJSONDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"product_type"] isEqualToString:@"Computer"]) {
        
        NSArray *variants = dictionary[@"variants"];
        for (NSDictionary *variant in variants) {
            SHPComputer *computer = [SHPComputer computerFromProductDictionary:dictionary
                                                             variantDictionary:variant];
            [self.computers addObject:computer];
        }
    }
    if ([dictionary[@"product_type"] isEqualToString:@"Keyboard"]) {
        
        NSArray *variants = dictionary[@"variants"];
        for (NSDictionary *variant in variants) {
            SHPKeyboard *keyboard = [SHPKeyboard keyboardFromProductDictionary:dictionary
                                                             variantDictionary:variant];
            [self.keyboards addObject:keyboard];
        }
    }
}

- (void)sortComputersByPrice {
    NSSortDescriptor *sortByPriceAscending = [NSSortDescriptor sortDescriptorWithKey:@"price"
                                                                           ascending:YES];
    self.computers = [[self.computers sortedArrayUsingDescriptors:@[sortByPriceAscending]] mutableCopy];
}

- (void)sortKeyboardsByPrice {
    NSSortDescriptor *sortByPriceAscending = [NSSortDescriptor sortDescriptorWithKey:@"price"
                                                                           ascending:YES];
    self.keyboards = [[self.keyboards sortedArrayUsingDescriptors:@[sortByPriceAscending]] mutableCopy];
}

- (void)equalNumberOfComputersAndKeyboards {
    NSMutableArray *biggerArray = [NSMutableArray new];
    NSMutableArray *smallerArray = [NSMutableArray new];
    
    biggerArray = (self.computers.count > self.keyboards.count) ? self.computers : self.keyboards;
    smallerArray = (self.computers.count < self.keyboards.count) ? self.computers : self.keyboards;
    
    NSUInteger differenceOfArrays = biggerArray.count - smallerArray.count;
    
    for (NSUInteger i = 1; i <= differenceOfArrays; i++) {
        [biggerArray removeLastObject];
    }
}

- (void)calculateTotalPrice {
    self.totalPrice = 0.0;
    
    for (NSUInteger i = 0; i < self.computers.count ; i++) {
        SHPComputer *computer = self.computers[i];
        SHPKeyboard *keyboard = self.keyboards[i];
        self.totalPrice = self.totalPrice + computer.price.floatValue + keyboard.price.floatValue;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"Total Price: $%.2f", self.totalPrice];
}

- (void)calculateTotalWeight {
    self.totalWeight = 0.0;
    
    for (NSUInteger i = 0; i < self.computers.count; i ++) {
        SHPComputer *computer = self.computers[i];
        SHPKeyboard *keyboard = self.keyboards[i];
        self.totalWeight = self.totalWeight + computer.weight.floatValue + keyboard.weight.floatValue;
    }
    self.totalWeightLabel.text = [NSString stringWithFormat:@"Total Weight: %.2f KG", self.totalWeight / 1000];
}

@end

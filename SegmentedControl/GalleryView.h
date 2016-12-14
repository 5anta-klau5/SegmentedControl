//
//  GalleryView.h
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 12/11/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITableView *linksTable;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

- (IBAction)addBtnPressed:(id)sender;
@end

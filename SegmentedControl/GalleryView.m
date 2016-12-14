//
//  GalleryView.m
//  SegmentedControl
//
//  Created by Serhii Serhiienko on 12/11/16.
//  Copyright © 2016 Serhii Serhiienko. All rights reserved.
//

#import "GalleryView.h"
#import "GalleryViewCell.h"

@interface GalleryView() {
    NSMutableArray *_linksArr;
}
@end

@implementation GalleryView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    _linksArr = [[NSMutableArray alloc] init];
    NSArray *initialArr = @[
    @"http://awfj.org/wp-content/uploads/2015/08/portman-left-1.jpg",
    @"http://www.indiewire.com/wp-content/uploads/2014/11/keira-knightley.jpg",
    @"http://media.filmz.ru/photos/full/filmz.ru_f_64844.jpg"
                           ];
    
    [_linksArr addObjectsFromArray:initialArr];
    [self.linksTable reloadData];
}

- (IBAction)addBtnPressed:(id)sender {
    NSString *text = self.txtField.text;
    if (![text  isEqual: @""]) {
        [_linksArr addObject:self.txtField.text];
        [self.linksTable reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_linksArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    long itemsCount = [_linksArr count];
    long currentRow = indexPath.row;
    NSString *cellIdentifier = @"GalleryCellDefault";
//    NSString *cellIdentifier2 = @"GalleryCell";
    
//    GalleryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
//    if (!cell) {
//        [tableView registerNib:[UINib nibWithNibName:@"GalleryViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
//        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
//    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [_linksArr objectAtIndex:itemsCount - currentRow - 1];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long itemsCount = [_linksArr count];
    long currentRow = indexPath.row;
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *str = [_linksArr objectAtIndex:itemsCount - currentRow - 1];
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.image = tmpImage;
    
//    NSLog(@"touch on row %lu and text: %@", currentRow, url);
}

@end

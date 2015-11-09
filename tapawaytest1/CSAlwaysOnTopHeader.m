//
//  CSAlwaysOnTopHeader.m
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSAlwaysOnTopHeader.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"

@implementation CSAlwaysOnTopHeader

- (void)applyLayoutAttributes:(CSStickyHeaderFlowLayoutAttributes *)layoutAttributes {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sections = @[
                      @[
                          @"Song 1",
                          @"Song 2",
                          @"Song 3",
                          @"Song 4",
                          @"Song 5",
                          @"Song 6",
                          @"Song 7",
                          @"Song 8",
                          @"Song 9",
                          @"Song 10",
                          @"Song 11",
                          @"Song 12",
                          @"Song 13",
                          @"Song 14",
                          @"Song 15",
                          @"Song 16",
                          @"Song 17",
                          @"Song 18",
                          @"Song 19",
                          @"Song 20",
                          ],
                      ];

    [self.collectionView registerNib:[UINib nibWithNibName:@"CSCell1"
                                                            bundle:[NSBundle mainBundle]]
                  forCellWithReuseIdentifier:@"CSCell1"];
    
    [self.collectionView1 registerNib:[UINib nibWithNibName:@"CSCell1"
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:@"CSCell1"];

}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *obj = self.sections[indexPath.section][indexPath.row];
    
    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CSCell1"
                                                             forIndexPath:indexPath];
    
    cell.textLabel.text = obj;
    
    return cell;
}


@end

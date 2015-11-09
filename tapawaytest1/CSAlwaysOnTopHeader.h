//
//  CSAlwaysOnTopHeader.h
//  CSStickyHeaderFlowLayoutDemo
//
//  Created by James Tang on 6/4/14.
//  Copyright (c) 2014 Jamz Tang. All rights reserved.
//

#import "CSCell.h"

@interface CSAlwaysOnTopHeader : CSCell

@property (nonatomic, strong) NSArray *sections;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView1;

@end

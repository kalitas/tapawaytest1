#import "ViewController.h"
#import "CSCell.h"
#import "CSSectionHeader.h"
#import "CSStickyHeaderFlowLayout.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataSourceOriginal;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *dataSourceFromServer;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) UINib *headerNibSection;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearchOn;
@property (nonatomic, assign) int headerHeight;

@end

@implementation ViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.dataSourceOriginal = [@[
                          
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
                              @"Song 20"
                              
                          ] mutableCopy];;
        self.dataSourceFromServer = [NSArray arrayWithObjects:@"Song 13",
                               @"Song 14",
                               @"Song 15",
                               @"Song 16",
                               @"Song 17",
                               @"Song 18",
                               @"Song 19",
                               @"Song 20", nil];
        
        self.headerNib = [UINib nibWithNibName:@"CSAlwaysOnTopHeader" bundle:nil];
        self.headerNibSection = [UINib nibWithNibName:@"CSSearchBarHeader" bundle:nil];
        self.filterArray = [NSMutableArray new];
        self.dataSource = [NSMutableArray arrayWithArray:self.dataSourceOriginal];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadLayout];
    
    // Also insets the scroll indicator so it appears below the search bar
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.collectionView registerNib:self.headerNib
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"header"];
    [self.collectionView registerNib:self.headerNibSection
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:@"sectionHeader"];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self reloadLayout];
}
- (void)reloadLayout
{
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        if (self.isSearchOn)
        {
            layout.parallaxHeaderReferenceSize = CGSizeZero;
            layout.parallaxHeaderMinimumReferenceSize = CGSizeZero;
            layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
            layout.parallaxHeaderAlwaysOnTop = NO;
            
            // If we want to disable the sticky header effect
            layout.disableStickyHeaders = NO;

        }
        else
        {
            layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 258);
            layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 258);
            layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
            layout.parallaxHeaderAlwaysOnTop = NO;
            
            // If we want to disable the sticky header effect
            layout.disableStickyHeaders = NO;
        }
    }
    
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *obj = self.dataSource[indexPath.row];
    
    CSCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];
    
    cell.textLabel.text = obj;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        CSSectionHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                   withReuseIdentifier:@"sectionHeader"
                                                                          forIndexPath:indexPath];
        cell.bar.delegate = self;
        self.searchBar = cell.bar;
        return cell;
        
    }
    else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
        if (self.isSearchOn) [cell setFrame:CGRectMake(0, 0, 0, 0)];
        self.headerHeight = cell.frame.size.height;
        return cell;
    }
    return nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    self.isSearchOn = YES;

    if (searchText.length > 0) {
        // search and reload data source
        [self filterContentForSearchText:searchText
                                   scope:nil];
        [self reloadDataSmooth];
    }
    else if (searchBar.text.length == 0)
    {
        //self.dataSource = [NSMutableArray arrayWithArray:self.dataSourceOriginal];
        self.filterArray = [NSMutableArray arrayWithArray:self.dataSourceOriginal];
        [self reloadDataSmooth];
    //    [self scrollToSearchBar];
        [self.searchBar becomeFirstResponder];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.isSearchOn = YES;
    [self reloadLayout];
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchText];
    
    self.filterArray = [NSMutableArray arrayWithArray:[self.dataSourceFromServer filteredArrayUsingPredicate:predicate]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.isSearchOn = NO;
    self.dataSource = [NSMutableArray arrayWithArray:self.dataSourceOriginal];
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    [self.searchBar resignFirstResponder];
    [self reloadLayout];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.isSearchOn = YES;

    [self.searchBar resignFirstResponder];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
   
    return  CGSizeMake(0, 44);

}

-(void)deleteItemsFromDataSourceAtIndexPaths:(NSArray *)itemPaths
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *itemPath  in itemPaths) {
        [indexSet addIndex:itemPath.row];
    }
    [self.dataSource removeObjectsAtIndexes:indexSet];
}

-(void)insertItems:(NSArray*)items ToDataSourceAtIndexPaths:(NSArray  *)itemPaths
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *itemPath  in itemPaths) {
        [indexSet addIndex:itemPath.row];
    }
    [self.dataSource insertObjects:items atIndexes:indexSet];
}

-(void)reloadDataSmooth{
    [self.collectionView performBatchUpdates:^{
        
        NSMutableArray *arrayWithIndexPathsDelete = [NSMutableArray array];
        NSMutableArray *arrayWithIndexPathsInsert = [NSMutableArray array];
        
        int itemCount = [self.dataSource count];
        
        for (int d = 0; d<itemCount; d++) {
            [arrayWithIndexPathsDelete addObject:[NSIndexPath indexPathForRow:d inSection:0]];
        }
        [self deleteItemsFromDataSourceAtIndexPaths:arrayWithIndexPathsDelete];
        [self.collectionView deleteItemsAtIndexPaths:arrayWithIndexPathsDelete];
        
        int newItemCount = [self.filterArray count];
        
        for (int i=0; i< newItemCount; i++) {
            [arrayWithIndexPathsInsert addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self insertItems:self.filterArray ToDataSourceAtIndexPaths:arrayWithIndexPathsInsert];
        [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPathsInsert];
   }
                                  completion:^(BOOL finished) {
                                      
                                  }];
    
    [self.searchBar becomeFirstResponder];
}

- (void)scrollToSearchBar  {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];

    CGPoint topOfHeader = CGPointMake(0, attributes.frame.origin.y - self.collectionView.contentInset.top + self.headerHeight);
    [self.collectionView setContentOffset:topOfHeader animated:self.searchBar.text.length == 0];
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    UIView *topView = self.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            [(UIButton*)subView setEnabled:YES];
        }
    }
}


@end

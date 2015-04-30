//
//  BracketCollectionViewController.m
//  tournamentor
//
//  Created by Brian Khoshbakht on 2015-04-23.
//  Copyright (c) 2015 Zachary Mallicoat. All rights reserved.
//

#import "BracketCollectionView.h"

#import "User.h"
#import "Match.h"
#import "Tournament.h"

#import "ChallongeCommunicator.h"
#import "WebViewController.h"

@interface BracketCollectionView () 

@end

@implementation BracketCollectionView

static NSString * const reuseIdentifier = @"bracketCollectionViewCell";


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.matches.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *bracketCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    

    
    return bracketCollectionViewCell;
}

#pragma mark <UICollectionViewDelegate>



@end

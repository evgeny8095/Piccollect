//
//  Album.m
//  Piccollect
//
//  Created by Josh on 2015/11/22.
//  Copyright © 2015年 Mu Mu Corp. All rights reserved.
//

#import "Album.h"

@implementation Album

@synthesize mAlbumName, mAlbumKey, mCreateDate, mOrder, mAlbumPhotos, mIncrease, mSerial;

- (void)initWithName:(NSString*) name key:(NSString*)key date:(NSDate*)date order:(NSNumber*)order incr:(NSString*) incr serial:(NSNumber*) serial{
    self.mAlbumName = name;
    self.mAlbumKey = key;
    self.mCreateDate = date;
    self.mOrder = order;
    self.mIncrease = incr;
    self.mSerial = serial;
}



@end

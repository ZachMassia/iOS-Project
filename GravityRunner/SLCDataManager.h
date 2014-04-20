//
//  SLCDataManager.h
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-20.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLCDataManager : NSObject

/**
 *  Get a shared instance of the data manager.
 *
 *  @return A pointer to the manager.
 */
+ (SLCDataManager *)sharedInstance;

/**
 *  The dictionary which is saved and loaded as NSData from a file.
 */
@property (strong, nonatomic) NSMutableDictionary *data;

/**
 *  The file to persist the dictionary in.
 */
@property (strong, nonatomic) NSString *fileName;

/**
 *  Save the dictionary to the file.
 */
- (void)saveData;

/**
 *  Load the dictionary from the file.
 */
- (void)loadData;

@end

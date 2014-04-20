//
//  SLCDataManager.m
//  GravityRunner
//
//  Created by Zachary Massia on 2014-04-20.
//  Copyright (c) 2014 edu.stlawrencetech. All rights reserved.
//

#import "SLCDataManager.h"

@interface SLCDataManager()

/**
 *  Appends the filename to the document directory.
 */
@property (strong, nonatomic) NSString *fullFilePath;

@end

@implementation SLCDataManager

+ (SLCDataManager *)sharedInstance {
    static SLCDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)saveData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.data];
    [data writeToFile:self.fullFilePath atomically:YES];
}

- (void)loadData {
    NSData *data = [[NSData alloc] initWithContentsOfFile:self.fullFilePath];
    self.data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!self.data) {
        self.data = [NSMutableDictionary dictionary];
    }
}

- (NSString *)fileName {
    if (!_fileName) {
        // Set a default file name.
        _fileName = @"SLCDataManagerData";
    }
    return _fileName;
}

- (NSString *)fullFilePath {
    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentDir stringByAppendingPathComponent:self.fileName];
}

@end

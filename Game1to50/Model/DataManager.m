//
//  DataManager.m
//  recorderExample
//
//  Created by Steven Lin on 2017/8/17.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import "DataManager.h"
#import <CommonCrypto/CommonCrypto.h>

static DataManager *_shareDataManager = nil;

@implementation DataManager{
    NSMutableArray *filenames;
    NSString *documentPath;
}

+(instancetype)sharedInstance{
    if (_shareDataManager== nil) {
        _shareDataManager = [DataManager new];
        
        [_shareDataManager prepareFilenameList];
    }
    return _shareDataManager;
}

-(void)prepareFilenameList{
    
    NSURL *documentsURL = [[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSLog(@"Documents at: %@", documentsURL);
    
    documentPath = documentsURL.path;
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:nil];
    filenames = [NSMutableArray arrayWithArray:files];
    
    NSInteger fileIndex= [filenames indexOfObject:@".DS_Store"];
    if (fileIndex != NSNotFound) {
        [filenames removeObjectAtIndex:fileIndex];
    }
    NSLog(@"Total: %ld files\n%@",filenames.count,filenames.description);
}

-(NSInteger)count{
    return filenames.count;
}

-(NSString *)filenameByIndex:(NSInteger)index{
    if (index < 0 || index >= filenames.count) {
        return nil;
    }
    
    return filenames[index];
}

-(NSArray*) returnArray{
    return filenames;
}

@end

//
//  DataManager.h
//  recorderExample
//
//  Created by Steven Lin on 2017/8/17.
//  Copyright © 2017年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCrypto.h>

@interface DataManager : NSObject

+(instancetype)sharedInstance;
-(NSInteger)count;
-(NSString* )filenameByIndex:(NSInteger)index;
//@property(strong, nonatomic)NSMutableArray *filenames;
-(NSMutableArray*) returnArray;
-(void)prepareFilenameList;

@end

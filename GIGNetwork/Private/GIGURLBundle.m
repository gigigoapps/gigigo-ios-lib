//
//  GIGURLBundle.m
//  gignetwork
//
//  Created by Sergio Baró on 07/04/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import "GIGURLBundle.h"


@interface GIGURLBundle ()

@property (strong, nonatomic) NSBundle *bundle;

@end


@implementation GIGURLBundle

- (instancetype)init
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    return [self initWithBundle:bundle];
}

- (instancetype)initWithBundle:(NSBundle *)bundle
{
    self = [super init];
    if (self)
    {
        _bundle = bundle;
    }
    return self;
}

#pragma mark - PUBLIC

- (NSData *)dataForFile:(NSString *)fileName
{
    NSString *filePath = [self.bundle pathForResource:fileName ofType:nil];
    if (!filePath) return nil;
    
    NSError *error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:filePath options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }
    
    return fileData;
}

- (id)loadJSONFile:(NSString *)jsonFile rootNode:(NSString *)rootNode
{
    NSData *jsonData = [self dataForFile:jsonFile];
    if (!jsonData) return nil;
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if (error)
    {
        NSLog(@"ERROR: %@", error.localizedDescription);
    }
    
    return (rootNode.length > 0) ? json[rootNode] : json;
}

@end

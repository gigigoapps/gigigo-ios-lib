//
//  GIGParseClass.h
//  GiGLibrary
//
//  Created by  Eduardo Parada on 5/10/15.
//  Copyright © 2015 Gigigo SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIGParseClass : NSObject

/**
 This method convert the class properties to a dictionary
 where the key is the name of the property and the value its content. 
 **/

- (NSDictionary *)parseClass:(id)parseClass;

+ (NSDictionary *)parseClass:(id)parseClass;

@end

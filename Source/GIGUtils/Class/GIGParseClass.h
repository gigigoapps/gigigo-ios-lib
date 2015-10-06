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
 
 Este metodo transaforma las propiedades de una clase, en un diccionario. 
 
 Donde su clave es el nombre de la propiedad y el valor su contenido.
 
 **/

- (NSDictionary *)parseClass:(id)parseClass;

+ (NSDictionary *)parseClass:(id)parseClass;

@end

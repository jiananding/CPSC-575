//
//  ExpressionEvaluator.h
//  camcat
//
//  Created by stephen on 2019-11-26.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
//

#ifndef ExpressionEvaluator_h
#define ExpressionEvaluator_h

#import <Foundation/Foundation.h>

@interface ExpressionEvaluator : NSObject

+ (NSNumber *) getValue:(NSString *)input;

#endif /* ExpressionEvaluator_h */

@end

//
//  ExpressionEvaluator.m
//  test
//
//  Created by Zilin Ye on 2019-11-26.
//  Copyright © 2019 Zilin Ye. All rights reserved.
//

#import "ExpressionEvaluator.h"

@implementation ExpressionEvaluator

+ (NSNumber *)getValue:(NSString *)input{
    @try{
        NSExpression *expression = [NSExpression expressionWithFormat:input];
        NSNumber *result = [expression expressionValueWithObject:nil context:nil];
        return result;
    }@catch(NSException *e){
        return nil;
    }
}

@end

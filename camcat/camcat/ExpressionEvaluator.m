//
//  ExpressionEvaluator.m
//  camcat
//
//  Created by stephen on 2019-11-26.
//  Copyright © 2019 Sophia Zhu. All rights reserved.
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

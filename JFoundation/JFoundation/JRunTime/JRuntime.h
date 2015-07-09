//
//  JRuntimeSystem.h
//  
//
//  Created by 方阳 on 15/5/16.
//
//

#import <Foundation/Foundation.h>

@interface JRuntime : NSObject

@end

//ios system info
@interface JRuntime (System)

+ (NSString*)systemVersion;

@end



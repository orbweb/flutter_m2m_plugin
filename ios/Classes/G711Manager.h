//
//  G711Manager.h
//  magic
//
//  Created by 谭琪元 on 2018/12/28.
//  Copyright © 2018 CloudMagic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define G711ALAW 0
#define G711ULAW 1

NS_ASSUME_NONNULL_BEGIN

@interface G711Manager : NSObject

- (NSData *)encodeG711:(NSData *)inputData CodecType:(NSInteger)type;
//- (NSData *)encodeG711:(NSData *)inputData;

@end

NS_ASSUME_NONNULL_END

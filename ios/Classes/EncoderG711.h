//
//  EncoderG711.h
//  magic
//
//  Created by 谭琪元 on 2018/12/28.
//  Copyright © 2018 CloudMagic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EncoderG711 : NSObject
- (unsigned char)linear2alaw:(int)pcm_val;
- (unsigned char)linear2ulaw:(int)pcm_val;
- (unsigned char) a2u:(unsigned char) val;
- (unsigned char) u2a:(unsigned char) val;
@end
    

NS_ASSUME_NONNULL_END

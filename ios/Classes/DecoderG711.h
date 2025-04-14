//
//  DecoderG711.h
//  magic
//
//  Created by 谭琪元 on 2018/12/28.
//  Copyright © 2018 CloudMagic. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DecoderG711 : NSObject

enum _e_g711_tp
{
    TP_ALAW,
    TP_ULAW
};

int g711_decode(void *pout_buf, int *pout_len, const void *pin_buf, const int in_len , int type);
@end

NS_ASSUME_NONNULL_END

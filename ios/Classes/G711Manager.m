//
//  G711Manager.m
//  magic
//
//  Created by 谭琪元 on 2018/12/28.
//  Copyright © 2018 CloudMagic. All rights reserved.
//

#import "G711Manager.h"
#import "EncoderG711.h"

@implementation G711Manager

- (NSData *)encodeG711:(NSData *)inputData CodecType:(NSInteger)type
{
    NSUInteger datalength = [inputData length];
    Byte *byteData = (Byte *)[inputData bytes];
    short *pPcm = (short *)byteData;
    //int outlen = 0;
    int len =(int)datalength / 2;
    Byte * G711Buff = (Byte *)malloc(len);
    memset(G711Buff,0,len);
    EncoderG711 *encode = [[EncoderG711 alloc] init];
    int i;
    for (i=0; i<len; i++) {
        //此处修改转换格式（a-law或u-law）
        if (type == G711ALAW){
            //G711Buff[i] = [encode linear2alaw:pPcm[i]];
            G711Buff[i] = [encode linear2ulaw:pPcm[i]];
            G711Buff[i] = [encode u2a:G711Buff[i]];
        }
        else
            G711Buff[i] = [encode linear2ulaw:pPcm[i]];
        
    }
    //outlen = i;
    Byte *sendbuff = (Byte *)G711Buff;
    NSData * sendData = [[NSData alloc]initWithBytes:sendbuff length:len];
    free(G711Buff);
    return sendData;
}

@end

//
//  Network.m
//  handy
//
//  Created by 方阳 on 15/6/23.
//  Copyright (c) 2015年 dw_fangyang. All rights reserved.
//

#import "Network.h"
#import <CoreFoundation/CoreFoundation.h> 
#import <sys/socket.h>
#import <netinet/in.h>
#import "arpa/inet.h"
#include <string>
using namespace std;

@implementation Network

static void callback(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    NSLog(@"callback");
    switch ( type ) {
        case kCFSocketConnectCallBack:
            if ( data == NULL ) {
                NSLog(@"connect succeeded");
            }
            else{
                NSLog(@"connect failed");
            }
            break;
        case kCFSocketDataCallBack:
        {
//            CFDataRef dataRef = (CFDataRef)data;
//            Byte *array = new Byte[CFDataGetLength(dataRef)];
//            CFDataGetBytes(dataRef, CFRangeMake(0, CFDataGetLength(dataRef)), array);
//            NSString* str = [NSString stringWithUTF8String:(const char*)array];
//            NSLog(@"%s",(const char*)array);
//            NSLog(@"data callback");
//            delete [] array;
            //            static Byte* tmpd = NULL;
            
            CFDataRef dataRef = (CFDataRef)data;
            CFIndex thelen = CFDataGetLength(dataRef);
            if ( thelen == 0 ) {
                return;
            }
            static CFMutableDataRef ab = NULL;
            static BOOL bGotRspLength = NO;
            static NSUInteger headerlen = 0;
            static NSInteger rsplen = 0;
            if ( ab == NULL ) {
                ab = CFDataCreateMutableCopy(kCFAllocatorDefault, 0l, (CFDataRef)data);
            }
            else
            {
                CFDataRef dataRef = (CFDataRef)data;
                CFIndex len = CFDataGetLength(dataRef);
                Byte* tmpcd = new Byte[len];
                CFDataGetBytes(dataRef, CFRangeMake(0, len), tmpcd);
                CFDataAppendBytes(ab, tmpcd, len);
                delete [] tmpcd;
            }
//            size_t curlen = CFDataGetLength(dataRef);
            //            CFDataGetBytes(dataRef, CFRangeMake(0, CFDataGetLength(dataRef)), &tmpd[len - curlen]);
//            CFDataRef ref = CFDataCreateCopy(NULL, ab);
            CFIndex len = CFDataGetLength(ab);
            Byte* cd = new Byte[len];
            CFDataGetBytes(ab, CFRangeMake(0, len), cd);
            
            NSLog(@"%ld",len);//(const char*)cd);
            if ( bGotRspLength || len <= 0 ) {
                return;
            }
            NSString* rsp = [NSString stringWithUTF8String:(const char*)cd];
            NSRange range = [rsp rangeOfString:@"\r\n\r\n"];
            if ( range.length > 0 ) {
                headerlen = range.length + range.location;
                NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"Content-Length:\\s*(\\d+)\\s*\r\n" options:NSRegularExpressionCaseInsensitive error:nil];
                NSTextCheckingResult* contentrange = [regex firstMatchInString:rsp options:0 range:NSMakeRange(0, rsp.length)];
                NSRange lenrange = [contentrange rangeAtIndex:1];
                if ( lenrange.length > 0 ) {
                    NSString* len = [rsp substringWithRange:lenrange];
                    rsplen = [len integerValue];
                    bGotRspLength = YES;
                }
            }
            delete [] cd;
        }
            break;
        case kCFSocketWriteCallBack:
        {
            NSLog(@"write callback");
            CFMutableDataRef data = CFDataCreateMutable(kCFAllocatorDefault, 0);
            std::string d("GET / HTTP/1.0\r\nHost:sports.sina.com.cn\r\n\r\n");
            CFDataAppendBytes(data, (UInt8*)d.c_str(), d.length() +1);
            CFSocketError err = CFSocketSendData(s, NULL, data, 1);
            switch ( err ) {
                case kCFSocketSuccess:
                    NSLog(@"write succeed");
                    break;
                case kCFSocketError:
                    NSLog(@"write error");
                    break;
                case kCFSocketTimeout:
                    NSLog(@"write timeout");
                    break;
                    
                default:
                    NSLog(@"write err");
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)ok
{
    CFSocketRef sock = CFSocketCreate(NULL/*默认内存分配器*/, 0/*默认INET协议族*/, SOCK_STREAM, IPPROTO_TCP , kCFSocketDataCallBack|kCFSocketConnectCallBack|kCFSocketWriteCallBack,callback,nil);
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(NULL,sock,1);
    CFRunLoopAddSource(CFRunLoopGetCurrent(),source,kCFRunLoopDefaultMode);
    struct sockaddr_in addr;
    NSUInteger size = sizeof(struct sockaddr_in);
    memset(&addr, 0, size);
//    NSLog(@"sockaddr_in len is %@",@(size));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = inet_addr("58.63.236.248");
    addr.sin_port = htons(80);
    CFDataRef ref = CFDataCreate(NULL, (UInt8*)&addr, size);
    CFSocketConnectToAddress(sock, ref, 0.2);
    CFRelease(source);
    NSLog(@"connecting....");
}


@end

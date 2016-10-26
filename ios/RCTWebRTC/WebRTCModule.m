//
//  WebRTCModule.m
//
//  Created by one on 2015/9/24.
//  Copyright © 2015 One. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RCTBridge.h"
#import "RCTEventDispatcher.h"
#import "RCTUtils.h"

#import <WebRTC/RTCLogging.h>

#import "WebRTCModule.h"

@interface WebRTCModule ()

@end

@implementation WebRTCModule

@synthesize bridge = _bridge;

- (instancetype)init
{
  self = [super init];
  if (self) {
    _peerConnectionFactory = [RTCPeerConnectionFactory new];
//    [RTCPeerConnectionFactory initializeSSL];

    // Enable this line to get incredibly detailed logs from WebRTC.
    // This should remain disabled for production builds.
    //RTCSetMinDebugLogLevel(RTCLoggingSeverityVerbose);

    _peerConnections = [NSMutableDictionary new];
    _mediaStreams = [NSMutableDictionary new];
    _tracks = [NSMutableDictionary new];
    _dataChannels = [NSMutableDictionary new];
    _dataChannelBinaryTypeIsBlob = [NSMutableDictionary new];
  }
  return self;
}

- (void)dealloc
{
  [_tracks removeAllObjects];
  _tracks = nil;
  [_mediaStreams removeAllObjects];
  _mediaStreams = nil;
  for (NSNumber *dataChannelId in _dataChannels) {
    RTCDataChannel *dataChannel = _dataChannels[dataChannelId];
    dataChannel.delegate = nil;
    [dataChannel close];
  }
  [_dataChannels removeAllObjects];

  for (NSNumber *peerConnectionId in _peerConnections) {
    RTCPeerConnection *peerConnection = _peerConnections[peerConnectionId];
    peerConnection.delegate = nil;
    [peerConnection close];
  }
  [_peerConnections removeAllObjects];

  _peerConnectionFactory = nil;
}

RCT_EXPORT_MODULE();

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

@end

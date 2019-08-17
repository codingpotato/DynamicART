//
//  CPTrace.h
//  DynamicArt
//
//  Created by wangyw on 11/4/12.
//  Copyright (c) 2012 codingpotato. All rights reserved.
//

#if DEBUG
#define CPLOGGING_ENABLED 1
#endif

#if CPLOGGING_ENABLED

#define CPLOGGING_INCLUDE_CODE_LOCATION 1

#define CPLOG_FORMAT_NO_LOCATION(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#define CPLOG_FORMAT_WITH_LOCATION(fmt, ...) NSLog((@"{ %s: %d } " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#if CPLOGGING_INCLUDE_CODE_LOCATION
#define CPTrace(fmt, ...) CPLOG_FORMAT_WITH_LOCATION(fmt, ##__VA_ARGS__)
#else
#define CPTrace(fmt, ...) CPLOG_FORMAT_NO_LOCATION(fmt, ##__VA_ARGS__)
#endif

#else

#define CPTrace(fmt, ...)

#endif // CPLOGGING_ENABLED

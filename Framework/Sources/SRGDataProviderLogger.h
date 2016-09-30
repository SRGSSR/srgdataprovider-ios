//
//  Copyright (c) SRG. All rights reserved.
//
//  License information is available from the LICENSE file.
//

#import <SRGLogger/SRGLogger.h>

/**
 *  Helper macros for logging
 */
#define SRGDataProviderLogVerbose(category, format, ...) SRGLogVerbose(@"ch.srgssrg.dataprovider", category, format, ##__VA_ARGS__)
#define SRGDataProviderLogDebug(category, format, ...)   SRGLogDebug(@"ch.srgssrg.dataprovider", category, format, ##__VA_ARGS__)
#define SRGDataProviderLogInfo(category, format, ...)    SRGLogInfo(@"ch.srgssrg.dataprovider", category, format, ##__VA_ARGS__)
#define SRGDataProviderLogWarning(category, format, ...) SRGLogWarning(@"ch.srgssrg.dataprovider", category, format, ##__VA_ARGS__)
#define SRGDataProviderLogError(category, format, ...)   SRGLogError(@"ch.srgssrg.dataprovider", category, format, ##__VA_ARGS__)

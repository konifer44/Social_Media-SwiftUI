/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FirebaseDatabase/Sources/Core/FRepoInfo.h"
#import "FirebaseDatabase/Sources/Constants/FConstants.h"

@interface FRepoInfo ()

@property(nonatomic, strong) NSString *domain;

@end

@implementation FRepoInfo

<<<<<<< HEAD
@synthesize namespace;
@synthesize host;
@synthesize internalHost;
@synthesize secure;
@synthesize domain;

- (id)initWithHost:(NSString *)aHost
          isSecure:(bool)isSecure
     withNamespace:(NSString *)aNamespace {
    self = [super init];
    if (self) {
        host = aHost;
        domain =
            [host containsString:@"."]
                ? [host
                      substringFromIndex:[host rangeOfString:@"."].location + 1]
                : host;
        secure = isSecure;
        namespace = aNamespace;

        // Get cached internal host if it exists
        NSString *internalHostKey =
            [NSString stringWithFormat:@"firebase:host:%@", self.host];
=======
@synthesize internalHost;

- (instancetype)init {
    [NSException
         raise:@"FIRDatabaseInvalidInitializer"
        format:@"Invalid initializer invoked. This is probably a bug in RTDB."];
    abort();
}

- (instancetype)initWithHost:(NSString *)aHost
                    isSecure:(BOOL)isSecure
               withNamespace:(NSString *)aNamespace {
    self = [super init];
    if (self) {
        _host = [aHost copy];
        _domain =
            [_host containsString:@"."]
                ? [_host
                      substringFromIndex:[_host rangeOfString:@"."].location +
                                         1]
                : _host;
        _secure = isSecure;
        _namespace = aNamespace;

        // Get cached internal host if it exists
        NSString *internalHostKey =
            [NSString stringWithFormat:@"firebase:host:%@", _host];
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404
        NSString *cachedInternalHost = [[NSUserDefaults standardUserDefaults]
            stringForKey:internalHostKey];
        if (cachedInternalHost != nil) {
            internalHost = cachedInternalHost;
        } else {
<<<<<<< HEAD
            internalHost = self.host;
=======
            internalHost = [_host copy];
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404
        }
    }
    return self;
}

<<<<<<< HEAD
- (NSString *)description {
    // The namespace is encoded in the hostname, so we can just return this.
    return [NSString
        stringWithFormat:@"http%@://%@", (self.secure ? @"s" : @""), self.host];
=======
- (instancetype)initWithInfo:(FRepoInfo *)info emulatedHost:(NSString *)host {
    self = [self initWithHost:host isSecure:NO withNamespace:info.namespace];
    return self;
}

- (NSString *)description {
    // The namespace is encoded in the hostname, so we can just return this.
    return [NSString
        stringWithFormat:@"http%@://%@", (_secure ? @"s" : @""), _host];
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404
}

- (void)setInternalHost:(NSString *)newHost {
    if (![internalHost isEqualToString:newHost]) {
        internalHost = newHost;

        // Cache the internal host so we don't need to redirect later on
        NSString *internalHostKey =
            [NSString stringWithFormat:@"firebase:host:%@", self.host];
        NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
        [cache setObject:internalHost forKey:internalHostKey];
        [cache synchronize];
    }
}

- (void)clearInternalHostCache {
<<<<<<< HEAD
    internalHost = self.host;
=======
    self.internalHost = self.host;
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404

    // Remove the cached entry
    NSString *internalHostKey =
        [NSString stringWithFormat:@"firebase:host:%@", self.host];
    NSUserDefaults *cache = [NSUserDefaults standardUserDefaults];
    [cache removeObjectForKey:internalHostKey];
    [cache synchronize];
}

- (BOOL)isDemoHost {
    return [self.domain isEqualToString:@"firebaseio-demo.com"];
}

- (BOOL)isCustomHost {
    return ![self.domain isEqualToString:@"firebaseio-demo.com"] &&
           ![self.domain isEqualToString:@"firebaseio.com"];
}

- (NSString *)connectionURL {
    return [self connectionURLWithLastSessionID:nil];
}

- (NSString *)connectionURLWithLastSessionID:(NSString *)lastSessionID {
    NSString *scheme;
    if (self.secure) {
        scheme = @"wss";
    } else {
        scheme = @"ws";
    }
    NSString *url =
        [NSString stringWithFormat:@"%@://%@/.ws?%@=%@&ns=%@", scheme,
                                   self.internalHost, kWireProtocolVersionParam,
                                   kWebsocketProtocolVersion, self.namespace];

    if (lastSessionID != nil) {
        url = [NSString stringWithFormat:@"%@&ls=%@", url, lastSessionID];
    }
    return url;
}

<<<<<<< HEAD
- (id)copyWithZone:(NSZone *)zone;
{
=======
- (id)copyWithZone:(NSZone *)zone {
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404
    return self; // Immutable
}

- (NSUInteger)hash {
<<<<<<< HEAD
    NSUInteger result = host.hash;
    result = 31 * result + (secure ? 1 : 0);
    result = 31 * result + namespace.hash;
    result = 31 * result + host.hash;
=======
    NSUInteger result = _host.hash;
    result = 31 * result + (_secure ? 1 : 0);
    result = 31 * result + _namespace.hash;
    result = 31 * result + _host.hash;
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404
    return result;
}

- (BOOL)isEqual:(id)anObject {
<<<<<<< HEAD
    if (![anObject isKindOfClass:[FRepoInfo class]])
        return NO;
    FRepoInfo *other = (FRepoInfo *)anObject;
    return secure == other.secure && [host isEqualToString:other.host] &&
           [namespace isEqualToString:other.namespace];
=======
    if (![anObject isKindOfClass:[FRepoInfo class]]) {
        return NO;
    }
    FRepoInfo *other = (FRepoInfo *)anObject;
    return _secure == other.secure && [_host isEqualToString:other.host] &&
           [_namespace isEqualToString:other.namespace];
>>>>>>> b0fe4ede551b697175ef2c12175fcf3e42038404
}

@end

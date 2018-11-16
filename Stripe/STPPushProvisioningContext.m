//
//  STPPushProvisioningContext.m
//  Stripe
//
//  Created by Jack Flintermann on 9/27/18.
//  Copyright © 2018 Stripe, Inc. All rights reserved.
//

#import "STPPushProvisioningContext.h"
#import "STPEphemeralKeyManager.h"
#import "STPAPIClient+Private.h"

@interface STPPushProvisioningContext()
@property (nonatomic, strong) STPEphemeralKeyManager *keyManager;
@end

@implementation STPPushProvisioningContext

- (instancetype)initWithKeyProvider:(id<STPEphemeralKeyProvider>)keyProvider {
    self = [super init];
    if (self) {
        _keyManager = [[STPEphemeralKeyManager alloc] initWithKeyProvider:keyProvider apiVersion:[STPAPIClient apiVersion] performsEagerFetching:NO];
    }
    return self;
}

@end

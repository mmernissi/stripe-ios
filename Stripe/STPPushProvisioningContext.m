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
#import "STPAPIClient+PushProvisioning.m"
#import "STPEphemeralKey.h"

@interface STPPushProvisioningContext()
@property (nonatomic, strong) STPEphemeralKeyManager *keyManager;
@property (nonatomic, strong, nullable) STPEphemeralKey *ephemeralKey;
@end

@implementation STPPushProvisioningContext

- (instancetype)initWithKeyProvider:(id<STPIssuingCardEphemeralKeyProvider>)keyProvider {
    self = [super init];
    if (self) {
        _keyManager = [[STPEphemeralKeyManager alloc] initWithKeyProvider:keyProvider apiVersion:[STPAPIClient apiVersion] performsEagerFetching:NO];
    }
    return self;
}

+ (PKAddPaymentPassRequestConfiguration *)requestConfigurationWithName:(NSString *)name
                                                           description:(nullable NSString *)description
                                                                 last4:(nullable NSString *)last4
                                                                 brand:(STPCardBrand)brand {
    PKAddPaymentPassRequestConfiguration *config = [[PKAddPaymentPassRequestConfiguration alloc] initWithEncryptionScheme:PKEncryptionSchemeECC_V2];
    config.cardholderName = name;
    config.primaryAccountSuffix = last4;
    config.localizedDescription = description;
    if (@available(iOS 12.0, *)) {
        config.style = PKAddPaymentPassStylePayment;
    }
    if (brand == STPCardBrandVisa) {
        config.paymentNetwork = PKPaymentNetworkVisa;
    }
    return config;
}

- (void)addPaymentPassViewController:(__unused PKAddPaymentPassViewController *)controller generateRequestWithCertificateChain:(NSArray<NSData *> *)certificates nonce:(NSData *)nonce nonceSignature:(NSData *)nonceSignature completionHandler:(void (^)(PKAddPaymentPassRequest *))handler {
    [self.keyManager getOrCreateKey:^(STPEphemeralKey * _Nullable ephemeralKey, NSError * _Nullable keyError) {
        if (keyError != nil) {
            handler([PKAddPaymentPassRequest new]);
            return;
        }
        STPPushProvisioningDetailsParams *params = [STPPushProvisioningDetailsParams paramsWithCardId:ephemeralKey.issuingCardID certificates:certificates nonce:nonce nonceSignature:nonceSignature];
        STPAPIClient *client = [STPAPIClient apiClientWithEphemeralKey:ephemeralKey];
        [client retrievePushProvisioningDetailsWithParams:params completion:^(STPPushProvisioningDetails * _Nullable details, NSError * _Nullable error) {
            if (error != nil) {
                handler([PKAddPaymentPassRequest new]);
                return;
            }
            PKAddPaymentPassRequest *request = [[PKAddPaymentPassRequest alloc] init];
            request.activationData = details.activationData;
            request.encryptedPassData = details.encryptedPassData;
            request.ephemeralPublicKey = details.ephemeralPublicKey;
            handler(request);
        }];
    }];
}

@end

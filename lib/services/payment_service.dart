import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pay/pay.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  // Initialize Stripe
  static Future<void> initializeStripe(String publishableKey) async {
    Stripe.publishableKey = publishableKey;
    await Stripe.instance.applySettings();
  }

  /// Process Apple Pay payment
  static Future<Map<String, dynamic>> processApplePay({
    required double amount,
    required String currency,
    required String planTitle,
  }) async {
    if (!Platform.isIOS) {
      throw Exception('Apple Pay is only available on iOS');
    }

    try {
      // Create payment items
      final paymentItems = [
        PaymentItem(
          label: planTitle,
          amount: amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ];

      // Configure payment configuration
      final paymentConfiguration = PaymentConfiguration.fromJsonString('''
      {
        "provider": "apple_pay",
        "data": {
          "merchantIdentifier": "merchant.com.yourapp.identifier",
          "displayName": "Cage Connect",
          "countryCode": "US",
          "currencyCode": "$currency"
        }
      }
      ''');

      // Create Pay instance
      final payClient = Pay({
        PayProvider.apple_pay: paymentConfiguration,
      });

      // Check if user can pay
      final canPay = await payClient.userCanPay(PayProvider.apple_pay);
      if (!canPay) {
        throw Exception('Apple Pay is not available on this device');
      }

      // Present Apple Pay sheet
      final result = await payClient.showPaymentSelector(
        PayProvider.apple_pay,
        paymentItems,
      );

      if (result.isNotEmpty) {
        // Apple Pay returns payment token directly or in paymentMethodData
        String? paymentToken;
        
        if (result.containsKey('paymentMethodData')) {
          final paymentMethodData = result['paymentMethodData'] as Map<String, dynamic>?;
          if (paymentMethodData != null && paymentMethodData.containsKey('tokenizationData')) {
            final tokenizationData = paymentMethodData['tokenizationData'] as Map<String, dynamic>?;
            if (tokenizationData != null && tokenizationData.containsKey('token')) {
              final tokenString = tokenizationData['token'] as String;
              // Parse the token JSON to extract payment method ID
              try {
                final tokenJson = json.decode(tokenString) as Map<String, dynamic>;
                paymentToken = tokenJson['id'] as String?;
              } catch (e) {
                // If parsing fails, use the token string directly
                paymentToken = tokenString;
              }
            }
          }
        }
        
        // Fallback to direct token keys
        paymentToken ??= result['paymentToken'] as String?;
        paymentToken ??= result['token'] as String?;
        
        if (paymentToken == null || paymentToken.isEmpty) {
          throw Exception('Failed to extract payment token from Apple Pay result');
        }
        
        return {
          'success': true,
          'paymentToken': paymentToken,
          'paymentMethod': 'apple_pay',
        };
      } else {
        throw Exception('Payment was cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Apple Pay error: $e');
      }
      rethrow;
    }
  }

  /// Process Google Pay payment
  static Future<Map<String, dynamic>> processGooglePay({
    required double amount,
    required String currency,
    required String planTitle,
  }) async {
    if (!Platform.isAndroid) {
      throw Exception('Google Pay is only available on Android');
    }

    try {
      // Create payment items
      final paymentItems = [
        PaymentItem(
          label: planTitle,
          amount: amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ];

      // Configure payment configuration
      // Note: String interpolation for amount and currency
      final amountString = amount.toStringAsFixed(2);
      final paymentConfigurationJson = '''
      {
        "provider": "google_pay",
        "data": {
          "environment": "TEST",
          "apiVersion": 2,
          "apiVersionMinor": 0,
          "allowedPaymentMethods": [
            {
              "type": "CARD",
              "parameters": {
                "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                "allowedCardNetworks": ["AMEX", "DISCOVER", "JCB", "MASTERCARD", "VISA"]
              },
              "tokenizationSpecification": {
                "type": "PAYMENT_GATEWAY",
                "parameters": {
                  "gateway": "stripe",
                  "stripe:version": "2018-10-31",
                  "stripe:publishableKey": "pk_test_51SQG7nBw0JTYxvz9IsBUIj0TC8k3m7MDUuOnr8zgRKJXmWAvmRvvNTE1hp2cRJsS1tTYjMF1nSQvOyW92Nrcsq7400wy3sLcI1pub"
                }
              }
            }
          ],
          "merchantInfo": {
            "merchantName": "Cage Connect"
          },
          "transactionInfo": {
            "totalPriceStatus": "FINAL",
            "totalPrice": "$amountString",
            "currencyCode": "$currency"
          }
        }
      }
      ''';
      
      final paymentConfiguration = PaymentConfiguration.fromJsonString(paymentConfigurationJson);

      // Create Pay instance
      final payClient = Pay({
        PayProvider.google_pay: paymentConfiguration,
      });

      // Check if user can pay
      final canPay = await payClient.userCanPay(PayProvider.google_pay);
      if (!canPay) {
        throw Exception('Google Pay is not available on this device');
      }

      // Present Google Pay sheet
      final result = await payClient.showPaymentSelector(
        PayProvider.google_pay,
        paymentItems,
      );

      if (result.isNotEmpty) {
        // Google Pay returns paymentMethodData with tokenizationData
        // The token is a JSON string that needs to be parsed
        String? paymentToken;
        
        if (result.containsKey('paymentMethodData')) {
          final paymentMethodData = result['paymentMethodData'] as Map<String, dynamic>?;
          if (paymentMethodData != null && paymentMethodData.containsKey('tokenizationData')) {
            final tokenizationData = paymentMethodData['tokenizationData'] as Map<String, dynamic>?;
            if (tokenizationData != null && tokenizationData.containsKey('token')) {
              final tokenString = tokenizationData['token'] as String;
              // Parse the token JSON to extract payment method ID
              try {
                final tokenJson = json.decode(tokenString) as Map<String, dynamic>;
                paymentToken = tokenJson['id'] as String?;
              } catch (e) {
                // If parsing fails, use the token string directly
                paymentToken = tokenString;
              }
            }
          }
        }
        
        // Fallback to direct token keys
        paymentToken ??= result['paymentMethodToken'] as String?;
        paymentToken ??= result['token'] as String?;
        
        if (paymentToken == null || paymentToken.isEmpty) {
          throw Exception('Failed to extract payment token from Google Pay result');
        }
        
        return {
          'success': true,
          'paymentToken': paymentToken,
          'paymentMethod': 'google_pay',
        };
      } else {
        throw Exception('Payment was cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Google Pay error: $e');
      }
      rethrow;
    }
  }

  /// Process Stripe payment
  static Future<Map<String, dynamic>> processStripePayment({
    required String paymentMethodId,
  }) async {
    try {
      return {
        'success': true,
        'paymentToken': paymentMethodId,
        'paymentMethod': 'stripe',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Stripe payment error: $e');
      }
      rethrow;
    }
  }

  /// Check if Apple Pay is available
  static Future<bool> isApplePayAvailable() async {
    if (!Platform.isIOS) return false;
    try {
      final paymentConfiguration = PaymentConfiguration.fromJsonString('''
      {
        "provider": "apple_pay",
        "data": {
          "merchantIdentifier": "merchant.com.yourapp.identifier",
          "displayName": "Cage Connect",
          "countryCode": "US",
          "currencyCode": "USD"
        }
      }
      ''');
      
      final payClient = Pay({
        PayProvider.apple_pay: paymentConfiguration,
      });
      
      return await payClient.userCanPay(PayProvider.apple_pay);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking Apple Pay availability: $e');
      }
      return false;
    }
  }

  /// Check if Google Pay is available
  static Future<bool> isGooglePayAvailable() async {
    if (!Platform.isAndroid) return false;
    try {
      final paymentConfiguration = PaymentConfiguration.fromJsonString('''
      {
        "provider": "google_pay",
        "data": {
          "environment": "TEST",
          "apiVersion": 2,
          "apiVersionMinor": 0,
          "allowedPaymentMethods": [
            {
              "type": "CARD",
              "parameters": {
                "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                "allowedCardNetworks": ["AMEX", "DISCOVER", "JCB", "MASTERCARD", "VISA"]
              },
              "tokenizationSpecification": {
                "type": "PAYMENT_GATEWAY",
                "parameters": {
                  "gateway": "stripe",
                  "stripe:version": "2018-10-31",
                  "stripe:publishableKey": "pk_test_51SQG7nBw0JTYxvz9IsBUIj0TC8k3m7MDUuOnr8zgRKJXmWAvmRvvNTE1hp2cRJsS1tTYjMF1nSQvOyW92Nrcsq7400wy3sLcI1pub"
                }
              }
            }
          ],
          "merchantInfo": {
            "merchantId": "YOUR_MERCHANT_ID",
            "merchantName": "Cage Connect"
          },
          "transactionInfo": {
            "totalPriceStatus": "FINAL",
            "totalPrice": "0.00",
            "currencyCode": "USD"
          }
        }
      }
      ''');
      
      final payClient = Pay({
        PayProvider.google_pay: paymentConfiguration,
      });
      
      return await payClient.userCanPay(PayProvider.google_pay);
    } catch (e) {
      if (kDebugMode) {
        print('Error checking Google Pay availability: $e');
      }
      return false;
    }
  }
}

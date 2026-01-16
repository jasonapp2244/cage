import 'dart:io';
import 'package:cage/fonts/fonts.dart';
import 'package:cage/models/subscription_plan_model.dart';
import 'package:cage/res/components/app_color.dart';
import 'package:cage/services/payment_service.dart';
import 'package:cage/services/subscription_service.dart';
import 'package:cage/utils/routes/responsive.dart';
import 'package:cage/utils/routes/utils.dart';
import 'package:cage/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubscriptionPlansView extends StatefulWidget {
  const SubscriptionPlansView({super.key});

  @override
  State<SubscriptionPlansView> createState() => _SubscriptionPlansViewState();
}

class _SubscriptionPlansViewState extends State<SubscriptionPlansView> {
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _isLoading = false;
  bool _applePayAvailable = false;
  bool _googlePayAvailable = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _checkPaymentAvailability();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _checkPaymentAvailability() async {
    final applePay = await PaymentService.isApplePayAvailable();
    final googlePay = await PaymentService.isGooglePayAvailable();
    if (!_isDisposed && mounted) {
      setState(() {
        _applePayAvailable = applePay;
        _googlePayAvailable = googlePay;
      });
    }
  }

  Future<void> _handleSubscribe(SubscriptionPlanModel plan, String paymentMethod) async {
    if (_isLoading || _isDisposed || !mounted) return;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> paymentResult;

      // Process payment based on method
      if (paymentMethod == 'apple_pay') {
        paymentResult = await PaymentService.processApplePay(
          amount: plan.amount,
          currency: plan.currency,
          planTitle: plan.title,
        );
      } else if (paymentMethod == 'google_pay') {
        paymentResult = await PaymentService.processGooglePay(
          amount: plan.amount,
          currency: plan.currency,
          planTitle: plan.title,
        );
      } else {
        // For Stripe, you would need to collect payment method first
        // This is a placeholder - implement Stripe payment collection UI
        throw Exception('Stripe payment method not implemented yet');
      }

      if (!_isDisposed && mounted && paymentResult['success'] == true) {
        // Create subscription via Firebase Function
        await _subscriptionService.createSubscriptionPayment(
          planId: plan.id,
          paymentMethod: paymentMethod,
          paymentToken: paymentResult['paymentToken'],
        );

        if (!_isDisposed && mounted) {
          Utils.flushBarErrorMassage(
            'Subscription activated successfully!',
            context,
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        Utils.flushBarErrorMassage(
          'Payment failed: ${e.toString()}',
          context,
        );
      }
    } finally {
      if (!_isDisposed && mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Subscription Plans',
          style: TextStyle(color: AppColor.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Boost Your Profile",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Choose a plan that works for you",
                style: TextStyle(
                  fontFamily: AppFonts.appFont,
                  color: AppColor.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              
              // Subscription Plans List
              Expanded(
                child: StreamBuilder<List<SubscriptionPlanModel>>(
                  stream: _subscriptionService.getActivePlans(),
                  builder: (context, snapshot) {
                    // Check if widget is still mounted
                    if (_isDisposed || !mounted) {
                      return SizedBox.shrink();
                    }
                    
                    // Debug logging
                    if (snapshot.hasError) {
                      debugPrint('Subscription Plans Stream Error: ${snapshot.error}');
                      if (snapshot.stackTrace != null) {
                        debugPrint('Stack trace: ${snapshot.stackTrace}');
                      }
                    }
                    
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: AppColor.red),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: AppColor.red, size: 48),
                              SizedBox(height: 16),
                              Text(
                                'Error loading plans',
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 16,
                                  fontFamily: AppFonts.appFont,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                snapshot.error.toString(),
                                style: TextStyle(
                                  color: AppColor.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                  fontFamily: AppFonts.appFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final plans = snapshot.data ?? [];
                    
                    debugPrint('Subscription Plans loaded: ${plans.length} plans');

                    if (plans.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, color: AppColor.white.withValues(alpha: 0.5), size: 48),
                            SizedBox(height: 16),
                            Text(
                              'No subscription plans available',
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 16,
                                fontFamily: AppFonts.appFont,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please check back later',
                              style: TextStyle(
                                color: AppColor.white.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontFamily: AppFonts.appFont,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        try {
                          final plan = plans[index];
                          return _buildPlanCard(plan);
                        } catch (e, stackTrace) {
                          debugPrint('Error building plan card at index $index: $e');
                          debugPrint('Stack trace: $stackTrace');
                          return Container(
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColor.red.withValues(alpha: 0.1),
                              border: Border.all(color: AppColor.red),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Error loading plan: ${e.toString()}',
                              style: TextStyle(color: AppColor.red),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.white.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/icons/diamond.svg"),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    plan.title,
                    style: TextStyle(
                      fontSize: Responsive.textScaleFactor * 18,
                      color: AppColor.white,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${plan.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 36,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  "/ ${plan.duration}",
                  style: TextStyle(
                    fontSize: Responsive.textScaleFactor * 14,
                    color: AppColor.white,
                    fontFamily: AppFonts.appFont,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              plan.description,
              style: TextStyle(
                fontSize: Responsive.textScaleFactor * 12,
                color: AppColor.white.withValues(alpha: 0.8),
                fontFamily: AppFonts.appFont,
              ),
            ),
            SizedBox(height: 16),
            Divider(color: AppColor.white.withValues(alpha: 0.3)),
            SizedBox(height: 12),
            
            // Features list
            ...plan.features.map((feature) => Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SvgPicture.asset("assets/icons/right.svg"),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: Responsive.textScaleFactor * 12,
                        color: AppColor.white,
                        fontFamily: AppFonts.appFont,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            
            SizedBox(height: 16),
            
            // Payment buttons
            if (Platform.isIOS && _applePayAvailable)
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: AuthButton(
                  buttontext: "Pay with Apple Pay",
                  onPress: () => _handleSubscribe(plan, 'apple_pay'),
                  loading: _isLoading,
                ),
              ),
            
            if (Platform.isAndroid && _googlePayAvailable)
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: AuthButton(
                  buttontext: "Pay with Google Pay",
                  onPress: () => _handleSubscribe(plan, 'google_pay'),
                  loading: _isLoading,
                ),
              ),
            
            AuthButton(
              buttontext: "Subscribe Now",
              onPress: () => _handleSubscribe(plan, 'stripe'),
              loading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

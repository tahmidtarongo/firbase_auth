// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `You Have Got An Email`
  String get youHaveGotAnEmail {
    return Intl.message(
      'You Have Got An Email',
      name: 'youHaveGotAnEmail',
      desc: '',
      args: [],
    );
  }

  /// `We Have Send An Email with instructions on how to reset password to:`
  String get weHaveSendAnEmailwithInstructions {
    return Intl.message(
      'We Have Send An Email with instructions on how to reset password to:',
      name: 'weHaveSendAnEmailwithInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Check Email`
  String get checkEmail {
    return Intl.message(
      'Check Email',
      name: 'checkEmail',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get otp {
    return Intl.message(
      'Close',
      name: 'otp',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password`
  String get forgotPassword {
    return Intl.message(
      'Forgot password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address below to receive password Reset Link.`
  String get pleaseEnterTheEmailAddressBelowToRecive {
    return Intl.message(
      'Please enter your email address below to receive password Reset Link.',
      name: 'pleaseEnterTheEmailAddressBelowToRecive',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `No user found for that email.`
  String get noUserFoundForThatEmail {
    return Intl.message(
      'No user found for that email.',
      name: 'noUserFoundForThatEmail',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password provided for that user.`
  String get wrongPasswordProvidedforThatUser {
    return Intl.message(
      'Wrong password provided for that user.',
      name: 'wrongPasswordProvidedforThatUser',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email Address`
  String get enterYourEmailAddress {
    return Intl.message(
      'Enter Your Email Address',
      name: 'enterYourEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get pleaseEnterAPassword {
    return Intl.message(
      'Please enter a password',
      name: 'pleaseEnterAPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPasswords {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPasswords',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login {
    return Intl.message(
      'Log In',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Haven't any account?`
  String get havenotAnAccounts {
    return Intl.message(
      'Haven\'t any account?',
      name: 'havenotAnAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Manage your business with `
  String get manageYourBussinessWith {
    return Intl.message(
      'Manage your business with ',
      name: 'manageYourBussinessWith',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Start typing to search`
  String get startTypingToSearch {
    return Intl.message(
      'Start typing to search',
      name: 'startTypingToSearch',
      desc: '',
      args: [],
    );
  }

  /// `Enter your phone number`
  String get enterYourNumber {
    return Intl.message(
      'Enter your phone number',
      name: 'enterYourNumber',
      desc: '',
      args: [],
    );
  }

  /// `Get Otp`
  String get getOtp {
    return Intl.message(
      'Get Otp',
      name: 'getOtp',
      desc: '',
      args: [],
    );
  }

  /// `No Connection`
  String get noConnection {
    return Intl.message(
      'No Connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connectivity`
  String get pleaseCheckYourInternetConnectivity {
    return Intl.message(
      'Please check your internet connectivity',
      name: 'pleaseCheckYourInternetConnectivity',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message(
      'Try Again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Verifying OTP`
  String get verifyOtp {
    return Intl.message(
      'Verifying OTP',
      name: 'verifyOtp',
      desc: '',
      args: [],
    );
  }

  /// `Change?`
  String get change {
    return Intl.message(
      'Change?',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP : `
  String get resendOtp {
    return Intl.message(
      'Resend OTP : ',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message(
      'Resend Code',
      name: 'resendCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify Phone Number`
  String get verifyPhoneNumber {
    return Intl.message(
      'Verify Phone Number',
      name: 'verifyPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Setup Your Profile`
  String get setUpYourProfile {
    return Intl.message(
      'Setup Your Profile',
      name: 'setUpYourProfile',
      desc: '',
      args: [],
    );
  }

  /// `Update your profile to connect your doctor with better impression`
  String get updateYourProfileToConnect {
    return Intl.message(
      'Update your profile to connect your doctor with better impression',
      name: 'updateYourProfileToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallary {
    return Intl.message(
      'Gallery',
      name: 'gallary',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Business Category`
  String get businessCategory {
    return Intl.message(
      'Business Category',
      name: 'businessCategory',
      desc: '',
      args: [],
    );
  }

  /// `Company & Shop Name`
  String get companyAndShopName {
    return Intl.message(
      'Company & Shop Name',
      name: 'companyAndShopName',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone Number`
  String get enterPhoneNumber {
    return Intl.message(
      'Enter Phone Number',
      name: 'enterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Company Address`
  String get companyAddress {
    return Intl.message(
      'Company Address',
      name: 'companyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter Full Address`
  String get enterFullAddress {
    return Intl.message(
      'Enter Full Address',
      name: 'enterFullAddress',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Opening Balance `
  String get openingBalance {
    return Intl.message(
      'Opening Balance ',
      name: 'openingBalance',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continu {
    return Intl.message(
      'Continue',
      name: 'continu',
      desc: '',
      args: [],
    );
  }

  /// `Create a Free Account`
  String get createAFreeAccounts {
    return Intl.message(
      'Create a Free Account',
      name: 'createAFreeAccounts',
      desc: '',
      args: [],
    );
  }

  /// `LogIn`
  String get logIn {
    return Intl.message(
      'LogIn',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations`
  String get congratulations {
    return Intl.message(
      'Congratulations',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `You are successfully login into your account. Stay with MOBIPOS.`
  String get youHaveSuccefulyLogin {
    return Intl.message(
      'You are successfully login into your account. Stay with MOBIPOS.',
      name: 'youHaveSuccefulyLogin',
      desc: '',
      args: [],
    );
  }

  /// `Add Contact`
  String get addContact {
    return Intl.message(
      'Add Contact',
      name: 'addContact',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Phone Number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter Your Phone Number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Name.`
  String get name {
    return Intl.message(
      'Enter Your Name.',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Amount.`
  String get enterAmount {
    return Intl.message(
      'Enter Amount.',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Retailer`
  String get retailer {
    return Intl.message(
      'Retailer',
      name: 'retailer',
      desc: '',
      args: [],
    );
  }

  /// `Dealer`
  String get dealer {
    return Intl.message(
      'Dealer',
      name: 'dealer',
      desc: '',
      args: [],
    );
  }

  /// `Wholesaler`
  String get wholSeller {
    return Intl.message(
      'Wholesaler',
      name: 'wholSeller',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get supplier {
    return Intl.message(
      'Supplier',
      name: 'supplier',
      desc: '',
      args: [],
    );
  }

  /// `More Info`
  String get moreInfo {
    return Intl.message(
      'More Info',
      name: 'moreInfo',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Enter Address`
  String get enterAddress {
    return Intl.message(
      'Enter Address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Customer Details`
  String get customerDetails {
    return Intl.message(
      'Customer Details',
      name: 'customerDetails',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to delete this user?`
  String get areYourSureDeleteThisUser {
    return Intl.message(
      'Are you sure to delete this user?',
      name: 'areYourSureDeleteThisUser',
      desc: '',
      args: [],
    );
  }

  /// `The user will be deleted and all the data will be deleted from your account.Are you sure to delete this?`
  String get theUserWillBe {
    return Intl.message(
      'The user will be deleted and all the data will be deleted from your account.Are you sure to delete this?',
      name: 'theUserWillBe',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cacel {
    return Intl.message(
      'Cancel',
      name: 'cacel',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete Forever`
  String get yesDeleteForever {
    return Intl.message(
      'Yes, Delete Forever',
      name: 'yesDeleteForever',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Recent Transactions`
  String get recentTransactions {
    return Intl.message(
      'Recent Transactions',
      name: 'recentTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Click to connect`
  String get clickToConnect {
    return Intl.message(
      'Click to connect',
      name: 'clickToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Please connect your bluetooth Printer`
  String get pleaseConnectYourBluttothPrinter {
    return Intl.message(
      'Please connect your bluetooth Printer',
      name: 'pleaseConnectYourBluttothPrinter',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Parties List`
  String get partiesList {
    return Intl.message(
      'Parties List',
      name: 'partiesList',
      desc: '',
      args: [],
    );
  }

  /// `Party Name`
  String get partyName {
    return Intl.message(
      'Party Name',
      name: 'partyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Party Name`
  String get enterPartyName {
    return Intl.message(
      'Enter Party Name',
      name: 'enterPartyName',
      desc: '',
      args: [],
    );
  }

  /// `Due`
  String get due {
    return Intl.message(
      'Due',
      name: 'due',
      desc: '',
      args: [],
    );
  }

  /// `Update Contact`
  String get updateContact {
    return Intl.message(
      'Update Contact',
      name: 'updateContact',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get upplier {
    return Intl.message(
      'Supplier',
      name: 'upplier',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Name`
  String get enterYourName {
    return Intl.message(
      'Enter Your Name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Bangladesh`
  String get bangladesh {
    return Intl.message(
      'Bangladesh',
      name: 'bangladesh',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noDataAvailable {
    return Intl.message(
      'No data available',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Add Delivery`
  String get addDelivery {
    return Intl.message(
      'Add Delivery',
      name: 'addDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Due List`
  String get dueList {
    return Intl.message(
      'Due List',
      name: 'dueList',
      desc: '',
      args: [],
    );
  }

  /// `Due Collection`
  String get dueCollection {
    return Intl.message(
      'Due Collection',
      name: 'dueCollection',
      desc: '',
      args: [],
    );
  }

  /// `Due Amount: `
  String get dueAmount {
    return Intl.message(
      'Due Amount: ',
      name: 'dueAmount',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Paid Amount`
  String get paidAmount {
    return Intl.message(
      'Paid Amount',
      name: 'paidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type`
  String get paymentType {
    return Intl.message(
      'Payment Type',
      name: 'paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get describtion {
    return Intl.message(
      'Description',
      name: 'describtion',
      desc: '',
      args: [],
    );
  }

  /// `Add note`
  String get addDescription {
    return Intl.message(
      'Add note',
      name: 'addDescription',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter A Confirm Password`
  String get pleaseEnterAConfirmPassword {
    return Intl.message(
      'Please Enter A Confirm Password',
      name: 'pleaseEnterAConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Already Have An Accounts`
  String get alreadyHaveAnAccounts {
    return Intl.message(
      'Already Have An Accounts',
      name: 'alreadyHaveAnAccounts',
      desc: '',
      args: [],
    );
  }

  /// `Add Customer`
  String get addCustomer {
    return Intl.message(
      'Add Customer',
      name: 'addCustomer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

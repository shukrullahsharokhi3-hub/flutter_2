import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
    Locale('fa', 'AF')
  ];

  /// No description provided for @employeesDescription.
  ///
  /// In en, this message translates to:
  /// **'View and manage the factory team in this local demo.'**
  String get employeesDescription;

  /// No description provided for @totalEmployees.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalEmployees;

  /// No description provided for @addEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add Employee'**
  String get addEmployee;

  /// No description provided for @editEmployee.
  ///
  /// In en, this message translates to:
  /// **'Edit Employee'**
  String get editEmployee;

  /// No description provided for @searchEmployees.
  ///
  /// In en, this message translates to:
  /// **'Search name, ID, position, or department'**
  String get searchEmployees;

  /// No description provided for @employeeActions.
  ///
  /// In en, this message translates to:
  /// **'Employee actions'**
  String get employeeActions;

  /// No description provided for @noMatchingEmployees.
  ///
  /// In en, this message translates to:
  /// **'No matching employees'**
  String get noMatchingEmployees;

  /// No description provided for @employeesDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'Local demo data - Changes last for this app session only.'**
  String get employeesDemoNotice;

  /// No description provided for @employeeIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeIdLabel;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @positionLabel.
  ///
  /// In en, this message translates to:
  /// **'Job title / position'**
  String get positionLabel;

  /// No description provided for @departmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get departmentLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @hireDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Hire date'**
  String get hireDateLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Employment status'**
  String get statusLabel;

  /// No description provided for @employeeIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an employee ID.'**
  String get employeeIdRequired;

  /// No description provided for @employeeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the employee\'s full name.'**
  String get employeeNameRequired;

  /// No description provided for @positionRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a job title or position.'**
  String get positionRequired;

  /// No description provided for @departmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a department.'**
  String get departmentRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number.'**
  String get phoneRequired;

  /// No description provided for @deleteEmployeeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete employee?'**
  String get deleteEmployeeQuestion;

  /// No description provided for @deleteEmployeePrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove this employee from the current demo session?'**
  String get deleteEmployeePrompt;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageDari.
  ///
  /// In en, this message translates to:
  /// **'فارسی'**
  String get languageDari;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInHint.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your account to continue.'**
  String get signInHint;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username.'**
  String get pleaseEnterUsername;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get pleaseEnterPassword;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get production;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @addOrder.
  ///
  /// In en, this message translates to:
  /// **'Add Order'**
  String get addOrder;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone, company, or email'**
  String get searchCustomers;

  /// No description provided for @searchOrders.
  ///
  /// In en, this message translates to:
  /// **'Search order number or customer'**
  String get searchOrders;

  /// No description provided for @searchProduction.
  ///
  /// In en, this message translates to:
  /// **'Search order ID or product'**
  String get searchProduction;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get allStatuses;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @delayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get delayed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validEmail;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total customers'**
  String get totalCustomers;

  /// No description provided for @activeCustomers.
  ///
  /// In en, this message translates to:
  /// **'Active customers'**
  String get activeCustomers;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total orders'**
  String get totalOrders;

  /// No description provided for @totalJobs.
  ///
  /// In en, this message translates to:
  /// **'Total jobs'**
  String get totalJobs;

  /// No description provided for @noCustomers.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomers;

  /// No description provided for @noOrders.
  ///
  /// In en, this message translates to:
  /// **'No matching orders'**
  String get noOrders;

  /// No description provided for @noJobs.
  ///
  /// In en, this message translates to:
  /// **'No matching production jobs'**
  String get noJobs;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'GFMS Mobile'**
  String get appName;

  /// No description provided for @factoryName.
  ///
  /// In en, this message translates to:
  /// **'Garment Factory Management System'**
  String get factoryName;

  /// No description provided for @backToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get backToDashboard;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @previewDashboard.
  ///
  /// In en, this message translates to:
  /// **'Preview Dashboard (Demo)'**
  String get previewDashboard;

  /// No description provided for @backendValid.
  ///
  /// In en, this message translates to:
  /// **'Your details are valid. Authentication will be enabled when the backend API is available.'**
  String get backendValid;

  /// No description provided for @backendPending.
  ///
  /// In en, this message translates to:
  /// **'Authentication is not connected yet. Sign in will be enabled when the backend API is available.'**
  String get backendPending;

  /// No description provided for @manageCustomers.
  ///
  /// In en, this message translates to:
  /// **'Manage customer contacts for your garment orders.'**
  String get manageCustomers;

  /// No description provided for @searchNoCustomers.
  ///
  /// In en, this message translates to:
  /// **'No matching customers'**
  String get searchNoCustomers;

  /// No description provided for @searchCustomerHint.
  ///
  /// In en, this message translates to:
  /// **'Try another name, phone number, company, or email.'**
  String get searchCustomerHint;

  /// No description provided for @addFirstCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add your first customer to get started.'**
  String get addFirstCustomer;

  /// No description provided for @localSessionData.
  ///
  /// In en, this message translates to:
  /// **'Local demo data • Changes last for this app session only.'**
  String get localSessionData;

  /// No description provided for @customerColumn.
  ///
  /// In en, this message translates to:
  /// **'CUSTOMER'**
  String get customerColumn;

  /// No description provided for @phoneColumn.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get phoneColumn;

  /// No description provided for @companyColumn.
  ///
  /// In en, this message translates to:
  /// **'COMPANY'**
  String get companyColumn;

  /// No description provided for @addressColumn.
  ///
  /// In en, this message translates to:
  /// **'ADDRESS'**
  String get addressColumn;

  /// No description provided for @emailColumn.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get emailColumn;

  /// No description provided for @statusColumn.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get statusColumn;

  /// No description provided for @actionsColumn.
  ///
  /// In en, this message translates to:
  /// **'ACTIONS'**
  String get actionsColumn;

  /// No description provided for @customerActions.
  ///
  /// In en, this message translates to:
  /// **'Customer actions'**
  String get customerActions;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get editCustomer;

  /// No description provided for @deleteCustomerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete customer?'**
  String get deleteCustomerQuestion;

  /// No description provided for @deleteCustomerPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove this customer from this session’s customer list?'**
  String get deleteCustomerPrompt;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @addCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get addCustomerTitle;

  /// No description provided for @editCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get editCustomerTitle;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name *'**
  String get fullNameRequired;

  /// No description provided for @customerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the customer’s full name.'**
  String get customerNameRequired;

  /// No description provided for @phoneRequiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number *'**
  String get phoneRequiredLabel;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get companyName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @ordersDescription.
  ///
  /// In en, this message translates to:
  /// **'Track customer orders and delivery schedules.'**
  String get ordersDescription;

  /// No description provided for @noMatchingOrders.
  ///
  /// In en, this message translates to:
  /// **'No matching orders'**
  String get noMatchingOrders;

  /// No description provided for @orderNumberColumn.
  ///
  /// In en, this message translates to:
  /// **'ORDER NUMBER'**
  String get orderNumberColumn;

  /// No description provided for @orderDateColumn.
  ///
  /// In en, this message translates to:
  /// **'ORDER DATE'**
  String get orderDateColumn;

  /// No description provided for @deliveryDateColumn.
  ///
  /// In en, this message translates to:
  /// **'DELIVERY DATE'**
  String get deliveryDateColumn;

  /// No description provided for @totalAmountColumn.
  ///
  /// In en, this message translates to:
  /// **'TOTAL AMOUNT'**
  String get totalAmountColumn;

  /// No description provided for @orderActions.
  ///
  /// In en, this message translates to:
  /// **'Order actions'**
  String get orderActions;

  /// No description provided for @editOrder.
  ///
  /// In en, this message translates to:
  /// **'Edit order'**
  String get editOrder;

  /// No description provided for @deleteOrderQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete order?'**
  String get deleteOrderQuestion;

  /// No description provided for @deleteOrderPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove this order from this session’s order list?'**
  String get deleteOrderPrompt;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order number'**
  String get orderNumber;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerName;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Order date'**
  String get orderDate;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery date'**
  String get deliveryDate;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get totalAmount;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order status'**
  String get orderStatus;

  /// No description provided for @enterTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a total amount.'**
  String get enterTotalAmount;

  /// No description provided for @validAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get validAmount;

  /// No description provided for @negativeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot be negative.'**
  String get negativeAmount;

  /// No description provided for @deliveryDateError.
  ///
  /// In en, this message translates to:
  /// **'Delivery date must be on or after the order date.'**
  String get deliveryDateError;

  /// No description provided for @productionDescription.
  ///
  /// In en, this message translates to:
  /// **'Track job quantities and progress through each garment stage.'**
  String get productionDescription;

  /// No description provided for @productionNotLive.
  ///
  /// In en, this message translates to:
  /// **'Local demo data · Not connected to live production.'**
  String get productionNotLive;

  /// No description provided for @totalProductionJobs.
  ///
  /// In en, this message translates to:
  /// **'Total jobs'**
  String get totalProductionJobs;

  /// No description provided for @pendingDelayed.
  ///
  /// In en, this message translates to:
  /// **'Pending / delayed'**
  String get pendingDelayed;

  /// No description provided for @orderIdColumn.
  ///
  /// In en, this message translates to:
  /// **'ORDER ID'**
  String get orderIdColumn;

  /// No description provided for @productColumn.
  ///
  /// In en, this message translates to:
  /// **'PRODUCT'**
  String get productColumn;

  /// No description provided for @plannedQuantityColumn.
  ///
  /// In en, this message translates to:
  /// **'PLANNED QTY'**
  String get plannedQuantityColumn;

  /// No description provided for @producedQuantityColumn.
  ///
  /// In en, this message translates to:
  /// **'PRODUCED QTY'**
  String get producedQuantityColumn;

  /// No description provided for @stageColumn.
  ///
  /// In en, this message translates to:
  /// **'STAGE'**
  String get stageColumn;

  /// No description provided for @plannedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Planned quantity'**
  String get plannedQuantity;

  /// No description provided for @producedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Produced quantity'**
  String get producedQuantity;

  /// No description provided for @productionStage.
  ///
  /// In en, this message translates to:
  /// **'Production stage'**
  String get productionStage;

  /// No description provided for @cutting.
  ///
  /// In en, this message translates to:
  /// **'Cutting'**
  String get cutting;

  /// No description provided for @sewing.
  ///
  /// In en, this message translates to:
  /// **'Sewing'**
  String get sewing;

  /// No description provided for @finishing.
  ///
  /// In en, this message translates to:
  /// **'Finishing'**
  String get finishing;

  /// No description provided for @qualityControl.
  ///
  /// In en, this message translates to:
  /// **'Quality Control'**
  String get qualityControl;

  /// No description provided for @noJobsHint.
  ///
  /// In en, this message translates to:
  /// **'Try another order ID, product, or status.'**
  String get noJobsHint;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'WORKSPACE'**
  String get workspace;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @reportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Review order, production, customer, and revenue summaries in one place.'**
  String get reportsDescription;

  /// No description provided for @reportsDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'These figures and charts use demo data and are not live factory reports until the backend is connected.'**
  String get reportsDemoNotice;

  /// No description provided for @reportingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Reporting period'**
  String get reportingPeriod;

  /// No description provided for @periodThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get periodThisWeek;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get periodThisMonth;

  /// No description provided for @periodThisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get periodThisYear;

  /// No description provided for @reportInsights.
  ///
  /// In en, this message translates to:
  /// **'Report overview'**
  String get reportInsights;

  /// No description provided for @reportCategories.
  ///
  /// In en, this message translates to:
  /// **'Report categories'**
  String get reportCategories;

  /// No description provided for @orderReports.
  ///
  /// In en, this message translates to:
  /// **'Order Reports'**
  String get orderReports;

  /// No description provided for @productionReports.
  ///
  /// In en, this message translates to:
  /// **'Production Reports'**
  String get productionReports;

  /// No description provided for @customerReports.
  ///
  /// In en, this message translates to:
  /// **'Customer Reports'**
  String get customerReports;

  /// No description provided for @revenueReports.
  ///
  /// In en, this message translates to:
  /// **'Revenue Reports'**
  String get revenueReports;

  /// No description provided for @averageOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Average order value'**
  String get averageOrderValue;

  /// No description provided for @reportTrendCaption.
  ///
  /// In en, this message translates to:
  /// **'Trend across six demo periods · USD'**
  String get reportTrendCaption;

  /// No description provided for @reportsRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Demo reports refreshed.'**
  String get reportsRefreshed;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get employees;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @qualityChecks.
  ///
  /// In en, this message translates to:
  /// **'Quality Checks'**
  String get qualityChecks;

  /// No description provided for @finishedStock.
  ///
  /// In en, this message translates to:
  /// **'Finished Stock'**
  String get finishedStock;

  /// No description provided for @payroll.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payroll;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @returnToLogin.
  ///
  /// In en, this message translates to:
  /// **'Return to login'**
  String get returnToLogin;

  /// No description provided for @dashboardActions.
  ///
  /// In en, this message translates to:
  /// **'Dashboard actions'**
  String get dashboardActions;

  /// No description provided for @notificationsFuture.
  ///
  /// In en, this message translates to:
  /// **'Notifications will be available in a future update.'**
  String get notificationsFuture;

  /// No description provided for @profileNotImplemented.
  ///
  /// In en, this message translates to:
  /// **'Profile settings are not implemented yet.'**
  String get profileNotImplemented;

  /// No description provided for @notImplemented.
  ///
  /// In en, this message translates to:
  /// **'This section is not implemented yet.'**
  String get notImplemented;

  /// No description provided for @productionOverview.
  ///
  /// In en, this message translates to:
  /// **'Production overview'**
  String get productionOverview;

  /// No description provided for @productionPerformance.
  ///
  /// In en, this message translates to:
  /// **'Production overview and factory performance'**
  String get productionPerformance;

  /// No description provided for @demoData.
  ///
  /// In en, this message translates to:
  /// **'DEMO DATA'**
  String get demoData;

  /// No description provided for @totalOrdersMetric.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrdersMetric;

  /// No description provided for @productionOutput.
  ///
  /// In en, this message translates to:
  /// **'Production Output'**
  String get productionOutput;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @overallEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Overall Efficiency'**
  String get overallEfficiency;

  /// No description provided for @changeThisMonth.
  ///
  /// In en, this message translates to:
  /// **'this month'**
  String get changeThisMonth;

  /// No description provided for @monthlyProduction.
  ///
  /// In en, this message translates to:
  /// **'Monthly Production'**
  String get monthlyProduction;

  /// No description provided for @unitsThousands.
  ///
  /// In en, this message translates to:
  /// **'Units produced • thousands'**
  String get unitsThousands;

  /// No description provided for @revenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get revenueTrend;

  /// No description provided for @revenueThousandsUsd.
  ///
  /// In en, this message translates to:
  /// **'Monthly revenue • thousands USD'**
  String get revenueThousandsUsd;

  /// No description provided for @recentProductionInsights.
  ///
  /// In en, this message translates to:
  /// **'Recent Production Insights'**
  String get recentProductionInsights;

  /// No description provided for @unitsColumn.
  ///
  /// In en, this message translates to:
  /// **'UNITS'**
  String get unitsColumn;

  /// No description provided for @efficiencyColumn.
  ///
  /// In en, this message translates to:
  /// **'EFFICIENCY'**
  String get efficiencyColumn;

  /// No description provided for @efficiencyPending.
  ///
  /// In en, this message translates to:
  /// **'Efficiency pending'**
  String get efficiencyPending;

  /// No description provided for @unitsLabel.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get unitsLabel;

  /// No description provided for @percentEfficiency.
  ///
  /// In en, this message translates to:
  /// **'efficiency'**
  String get percentEfficiency;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @ordersChange.
  ///
  /// In en, this message translates to:
  /// **'+12.8% this month'**
  String get ordersChange;

  /// No description provided for @productionChange.
  ///
  /// In en, this message translates to:
  /// **'+8.2% this month'**
  String get productionChange;

  /// No description provided for @revenueChange.
  ///
  /// In en, this message translates to:
  /// **'+6.4% this month'**
  String get revenueChange;

  /// No description provided for @efficiencyChange.
  ///
  /// In en, this message translates to:
  /// **'+2.1% this month'**
  String get efficiencyChange;

  /// No description provided for @noOrdersHint.
  ///
  /// In en, this message translates to:
  /// **'Try another order number or customer name.'**
  String get noOrdersHint;

  /// No description provided for @uiPreview.
  ///
  /// In en, this message translates to:
  /// **'GFMS • UI preview'**
  String get uiPreview;

  /// No description provided for @materialsDescription.
  ///
  /// In en, this message translates to:
  /// **'Maintain factory material master records.'**
  String get materialsDescription;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @newMaterial.
  ///
  /// In en, this message translates to:
  /// **'New material'**
  String get newMaterial;

  /// No description provided for @searchMaterials.
  ///
  /// In en, this message translates to:
  /// **'Search code, name, or description'**
  String get searchMaterials;

  /// No description provided for @materialTypeFilter.
  ///
  /// In en, this message translates to:
  /// **'Material type'**
  String get materialTypeFilter;

  /// No description provided for @defaultUnitFilter.
  ///
  /// In en, this message translates to:
  /// **'Default unit'**
  String get defaultUnitFilter;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @materialCodeColumn.
  ///
  /// In en, this message translates to:
  /// **'MATERIAL CODE'**
  String get materialCodeColumn;

  /// No description provided for @materialNameColumn.
  ///
  /// In en, this message translates to:
  /// **'MATERIAL NAME'**
  String get materialNameColumn;

  /// No description provided for @materialTypeColumn.
  ///
  /// In en, this message translates to:
  /// **'TYPE'**
  String get materialTypeColumn;

  /// No description provided for @defaultUnitColumn.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT UNIT'**
  String get defaultUnitColumn;

  /// No description provided for @descriptionColumn.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get descriptionColumn;

  /// No description provided for @materialActions.
  ///
  /// In en, this message translates to:
  /// **'Material actions'**
  String get materialActions;

  /// No description provided for @viewMaterial.
  ///
  /// In en, this message translates to:
  /// **'View material'**
  String get viewMaterial;

  /// No description provided for @editMaterial.
  ///
  /// In en, this message translates to:
  /// **'Edit material'**
  String get editMaterial;

  /// No description provided for @deactivateMaterial.
  ///
  /// In en, this message translates to:
  /// **'Deactivate material'**
  String get deactivateMaterial;

  /// No description provided for @activateMaterial.
  ///
  /// In en, this message translates to:
  /// **'Activate material'**
  String get activateMaterial;

  /// No description provided for @noMaterials.
  ///
  /// In en, this message translates to:
  /// **'No materials yet'**
  String get noMaterials;

  /// No description provided for @noMatchingMaterials.
  ///
  /// In en, this message translates to:
  /// **'No matching materials'**
  String get noMatchingMaterials;

  /// No description provided for @materialCode.
  ///
  /// In en, this message translates to:
  /// **'Material code'**
  String get materialCode;

  /// No description provided for @materialName.
  ///
  /// In en, this message translates to:
  /// **'Material name'**
  String get materialName;

  /// No description provided for @materialTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Material type'**
  String get materialTypeLabel;

  /// No description provided for @defaultUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Default unit'**
  String get defaultUnitLabel;

  /// No description provided for @materialDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get materialDescription;

  /// No description provided for @saveMaterial.
  ///
  /// In en, this message translates to:
  /// **'Save material'**
  String get saveMaterial;

  /// No description provided for @createMaterialTitle.
  ///
  /// In en, this message translates to:
  /// **'Create material'**
  String get createMaterialTitle;

  /// No description provided for @editMaterialTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit material'**
  String get editMaterialTitle;

  /// No description provided for @materialDialogHint.
  ///
  /// In en, this message translates to:
  /// **'Add the details used to identify and issue this factory material.'**
  String get materialDialogHint;

  /// No description provided for @selectMaterialType.
  ///
  /// In en, this message translates to:
  /// **'Select a material type'**
  String get selectMaterialType;

  /// No description provided for @selectDefaultUnit.
  ///
  /// In en, this message translates to:
  /// **'Select a default unit'**
  String get selectDefaultUnit;

  /// No description provided for @fabricRollHint.
  ///
  /// In en, this message translates to:
  /// **'Fabric roll workflows use Meter or Kilogram. Piece is accepted by Material Master but cannot be received as fabric.'**
  String get fabricRollHint;

  /// No description provided for @materialCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a material code.'**
  String get materialCodeRequired;

  /// No description provided for @materialNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a material name.'**
  String get materialNameRequired;

  /// No description provided for @duplicateMaterialCode.
  ///
  /// In en, this message translates to:
  /// **'This material code is already in use.'**
  String get duplicateMaterialCode;

  /// No description provided for @deleteMaterialQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete material?'**
  String get deleteMaterialQuestion;

  /// No description provided for @deleteMaterialPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove this material from the current demo session?'**
  String get deleteMaterialPrompt;

  /// No description provided for @otherMaterialType.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherMaterialType;

  /// No description provided for @fabricMaterialType.
  ///
  /// In en, this message translates to:
  /// **'Fabric'**
  String get fabricMaterialType;

  /// No description provided for @accessoryMaterialType.
  ///
  /// In en, this message translates to:
  /// **'Accessory'**
  String get accessoryMaterialType;

  /// No description provided for @otherMaterialUnit.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherMaterialUnit;

  /// No description provided for @meterUnit.
  ///
  /// In en, this message translates to:
  /// **'Meter'**
  String get meterUnit;

  /// No description provided for @kilogramUnit.
  ///
  /// In en, this message translates to:
  /// **'Kilogram'**
  String get kilogramUnit;

  /// No description provided for @pieceUnit.
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get pieceUnit;

  /// No description provided for @adminUser.
  ///
  /// In en, this message translates to:
  /// **'Admin User'**
  String get adminUser;

  /// No description provided for @administratorRole.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administratorRole;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @materialsDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'Local demo data • Changes last for this app session only.'**
  String get materialsDemoNotice;

  /// No description provided for @cuttingDescription.
  ///
  /// In en, this message translates to:
  /// **'Review and manage Cutting records in this local demo.'**
  String get cuttingDescription;

  /// No description provided for @totalCuttingRecords.
  ///
  /// In en, this message translates to:
  /// **'Total Cutting records'**
  String get totalCuttingRecords;

  /// No description provided for @searchCuttingRecords.
  ///
  /// In en, this message translates to:
  /// **'Search order reference or description'**
  String get searchCuttingRecords;

  /// No description provided for @addCuttingRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Cutting record'**
  String get addCuttingRecord;

  /// No description provided for @editCuttingRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Cutting record'**
  String get editCuttingRecord;

  /// No description provided for @cuttingDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get cuttingDescriptionLabel;

  /// No description provided for @cuttingDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get cuttingDate;

  /// No description provided for @orderReference.
  ///
  /// In en, this message translates to:
  /// **'Order reference'**
  String get orderReference;

  /// No description provided for @orderReferenceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an order reference.'**
  String get orderReferenceRequired;

  /// No description provided for @cuttingDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a description.'**
  String get cuttingDescriptionRequired;

  /// No description provided for @cuttingRecordActions.
  ///
  /// In en, this message translates to:
  /// **'Cutting record actions'**
  String get cuttingRecordActions;

  /// No description provided for @deleteCuttingRecordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete Cutting record?'**
  String get deleteCuttingRecordQuestion;

  /// No description provided for @deleteCuttingRecordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remove this record from the current demo session?'**
  String get deleteCuttingRecordPrompt;

  /// No description provided for @noCuttingRecords.
  ///
  /// In en, this message translates to:
  /// **'No Cutting records yet'**
  String get noCuttingRecords;

  /// No description provided for @noCuttingRecordsHint.
  ///
  /// In en, this message translates to:
  /// **'Add a demo record to get started.'**
  String get noCuttingRecordsHint;

  /// No description provided for @noMatchingCuttingRecords.
  ///
  /// In en, this message translates to:
  /// **'No matching Cutting records'**
  String get noMatchingCuttingRecords;

  /// No description provided for @noMatchingCuttingHint.
  ///
  /// In en, this message translates to:
  /// **'Try another order reference, description, or status.'**
  String get noMatchingCuttingHint;

  /// No description provided for @cuttingDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'Local demo data. Changes last for this app session only.'**
  String get cuttingDemoNotice;

  /// No description provided for @managerRole.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get managerRole;

  /// No description provided for @factoryOperations.
  ///
  /// In en, this message translates to:
  /// **'Factory Operations'**
  String get factoryOperations;

  /// No description provided for @cuttingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor customer order and stock Cutting work.'**
  String get cuttingSubtitle;

  /// No description provided for @searchCutting.
  ///
  /// In en, this message translates to:
  /// **'Search Cutting'**
  String get searchCutting;

  /// No description provided for @searchCuttingPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Cutting, order, customer, model, or cutter...'**
  String get searchCuttingPlaceholder;

  /// No description provided for @cuttingStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get cuttingStatusLabel;

  /// No description provided for @sourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get sourceLabel;

  /// No description provided for @allSources.
  ///
  /// In en, this message translates to:
  /// **'All sources'**
  String get allSources;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @cuttingFiltersUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Search and filters are inactive until a Cutting data source is connected.'**
  String get cuttingFiltersUnavailable;

  /// No description provided for @notConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected'**
  String get notConnected;

  /// No description provided for @cuttingNotConnectedExplanation.
  ///
  /// In en, this message translates to:
  /// **'No confirmed Cutting endpoint is configured, so records cannot be loaded yet.'**
  String get cuttingNotConnectedExplanation;

  /// No description provided for @cuttingNoRequestSent.
  ///
  /// In en, this message translates to:
  /// **'Retry will not contact the server until a data source is configured.'**
  String get cuttingNoRequestSent;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'fa':
      {
        switch (locale.countryCode) {
          case 'AF':
            return AppLocalizationsFaAf();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

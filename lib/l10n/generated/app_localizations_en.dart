// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get employeesDescription =>
      'View and manage the factory team in this local demo.';

  @override
  String get totalEmployees => 'Total';

  @override
  String get addEmployee => 'Add Employee';

  @override
  String get editEmployee => 'Edit Employee';

  @override
  String get searchEmployees => 'Search name, ID, position, or department';

  @override
  String get employeeActions => 'Employee actions';

  @override
  String get noMatchingEmployees => 'No matching employees';

  @override
  String get employeesDemoNotice =>
      'Local demo data - Changes last for this app session only.';

  @override
  String get employeeIdLabel => 'Employee ID';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get positionLabel => 'Job title / position';

  @override
  String get departmentLabel => 'Department';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get emailLabel => 'Email address';

  @override
  String get hireDateLabel => 'Hire date';

  @override
  String get statusLabel => 'Employment status';

  @override
  String get employeeIdRequired => 'Enter an employee ID.';

  @override
  String get employeeNameRequired => 'Enter the employee\'s full name.';

  @override
  String get positionRequired => 'Enter a job title or position.';

  @override
  String get departmentRequired => 'Enter a department.';

  @override
  String get phoneRequired => 'Enter a phone number.';

  @override
  String get deleteEmployeeQuestion => 'Delete employee?';

  @override
  String get deleteEmployeePrompt =>
      'Remove this employee from the current demo session?';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageDari => 'فارسی';

  @override
  String get continueLabel => 'Continue';

  @override
  String get signIn => 'Sign In';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInHint => 'Sign in with your account to continue.';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get pleaseEnterUsername => 'Please enter your username.';

  @override
  String get pleaseEnterPassword => 'Please enter your password.';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get customers => 'Customers';

  @override
  String get orders => 'Orders';

  @override
  String get production => 'Production';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get addCustomer => 'Add Customer';

  @override
  String get addOrder => 'Add Order';

  @override
  String get searchCustomers => 'Search by name, phone, company, or email';

  @override
  String get searchOrders => 'Search order number or customer';

  @override
  String get searchProduction => 'Search order ID or product';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get pending => 'Pending';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get delayed => 'Delayed';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get close => 'Close';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get validEmail => 'Enter a valid email address.';

  @override
  String get totalCustomers => 'Total customers';

  @override
  String get activeCustomers => 'Active customers';

  @override
  String get totalOrders => 'Total orders';

  @override
  String get totalJobs => 'Total jobs';

  @override
  String get noCustomers => 'No customers yet';

  @override
  String get noOrders => 'No matching orders';

  @override
  String get noJobs => 'No matching production jobs';

  @override
  String get appName => 'GFMS Mobile';

  @override
  String get factoryName => 'Garment Factory Management System';

  @override
  String get backToDashboard => 'Back to dashboard';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get previewDashboard => 'Preview Dashboard (Demo)';

  @override
  String get backendValid =>
      'Your details are valid. Authentication will be enabled when the backend API is available.';

  @override
  String get backendPending =>
      'Authentication is not connected yet. Sign in will be enabled when the backend API is available.';

  @override
  String get manageCustomers =>
      'Manage customer contacts for your garment orders.';

  @override
  String get searchNoCustomers => 'No matching customers';

  @override
  String get searchCustomerHint =>
      'Try another name, phone number, company, or email.';

  @override
  String get addFirstCustomer => 'Add your first customer to get started.';

  @override
  String get localSessionData =>
      'Local demo data • Changes last for this app session only.';

  @override
  String get customerColumn => 'CUSTOMER';

  @override
  String get phoneColumn => 'PHONE';

  @override
  String get companyColumn => 'COMPANY';

  @override
  String get addressColumn => 'ADDRESS';

  @override
  String get emailColumn => 'EMAIL';

  @override
  String get statusColumn => 'STATUS';

  @override
  String get actionsColumn => 'ACTIONS';

  @override
  String get customerActions => 'Customer actions';

  @override
  String get viewDetails => 'View details';

  @override
  String get editCustomer => 'Edit customer';

  @override
  String get deleteCustomerQuestion => 'Delete customer?';

  @override
  String get deleteCustomerPrompt =>
      'Remove this customer from this session’s customer list?';

  @override
  String get notProvided => 'Not provided';

  @override
  String get addCustomerTitle => 'Add customer';

  @override
  String get editCustomerTitle => 'Edit customer';

  @override
  String get fullNameRequired => 'Full name *';

  @override
  String get customerNameRequired => 'Enter the customer’s full name.';

  @override
  String get phoneRequiredLabel => 'Phone number *';

  @override
  String get companyName => 'Company name';

  @override
  String get emailAddress => 'Email address';

  @override
  String get address => 'Address';

  @override
  String get ordersDescription =>
      'Track customer orders and delivery schedules.';

  @override
  String get noMatchingOrders => 'No matching orders';

  @override
  String get orderNumberColumn => 'ORDER NUMBER';

  @override
  String get orderDateColumn => 'ORDER DATE';

  @override
  String get deliveryDateColumn => 'DELIVERY DATE';

  @override
  String get totalAmountColumn => 'TOTAL AMOUNT';

  @override
  String get orderActions => 'Order actions';

  @override
  String get editOrder => 'Edit order';

  @override
  String get deleteOrderQuestion => 'Delete order?';

  @override
  String get deleteOrderPrompt =>
      'Remove this order from this session’s order list?';

  @override
  String get orderNumber => 'Order number';

  @override
  String get customerName => 'Customer name';

  @override
  String get orderDate => 'Order date';

  @override
  String get deliveryDate => 'Delivery date';

  @override
  String get totalAmount => 'Total amount';

  @override
  String get orderStatus => 'Order status';

  @override
  String get enterTotalAmount => 'Enter a total amount.';

  @override
  String get validAmount => 'Enter a valid amount.';

  @override
  String get negativeAmount => 'Amount cannot be negative.';

  @override
  String get deliveryDateError =>
      'Delivery date must be on or after the order date.';

  @override
  String get productionDescription =>
      'Track job quantities and progress through each garment stage.';

  @override
  String get productionNotLive =>
      'Local demo data · Not connected to live production.';

  @override
  String get totalProductionJobs => 'Total jobs';

  @override
  String get pendingDelayed => 'Pending / delayed';

  @override
  String get orderIdColumn => 'ORDER ID';

  @override
  String get productColumn => 'PRODUCT';

  @override
  String get plannedQuantityColumn => 'PLANNED QTY';

  @override
  String get producedQuantityColumn => 'PRODUCED QTY';

  @override
  String get stageColumn => 'STAGE';

  @override
  String get plannedQuantity => 'Planned quantity';

  @override
  String get producedQuantity => 'Produced quantity';

  @override
  String get productionStage => 'Production stage';

  @override
  String get cutting => 'Cutting';

  @override
  String get sewing => 'Sewing';

  @override
  String get finishing => 'Finishing';

  @override
  String get qualityControl => 'Quality Control';

  @override
  String get noJobsHint => 'Try another order ID, product, or status.';

  @override
  String get workspace => 'WORKSPACE';

  @override
  String get reports => 'Reports';

  @override
  String get reportsDescription =>
      'Review order, production, customer, and revenue summaries in one place.';

  @override
  String get reportsDemoNotice =>
      'These figures and charts use demo data and are not live factory reports until the backend is connected.';

  @override
  String get reportingPeriod => 'Reporting period';

  @override
  String get periodThisWeek => 'This Week';

  @override
  String get periodThisMonth => 'This Month';

  @override
  String get periodThisYear => 'This Year';

  @override
  String get reportInsights => 'Report overview';

  @override
  String get reportCategories => 'Report categories';

  @override
  String get orderReports => 'Order Reports';

  @override
  String get productionReports => 'Production Reports';

  @override
  String get customerReports => 'Customer Reports';

  @override
  String get revenueReports => 'Revenue Reports';

  @override
  String get averageOrderValue => 'Average order value';

  @override
  String get reportTrendCaption => 'Trend across six demo periods · USD';

  @override
  String get reportsRefreshed => 'Demo reports refreshed.';

  @override
  String get analytics => 'Analytics';

  @override
  String get employees => 'Employees';

  @override
  String get materials => 'Materials';

  @override
  String get qualityChecks => 'Quality Checks';

  @override
  String get finishedStock => 'Finished Stock';

  @override
  String get payroll => 'Payroll';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get returnToLogin => 'Return to login';

  @override
  String get dashboardActions => 'Dashboard actions';

  @override
  String get notificationsFuture =>
      'Notifications will be available in a future update.';

  @override
  String get profileNotImplemented =>
      'Profile settings are not implemented yet.';

  @override
  String get notImplemented => 'This section is not implemented yet.';

  @override
  String get productionOverview => 'Production overview';

  @override
  String get productionPerformance =>
      'Production overview and factory performance';

  @override
  String get demoData => 'DEMO DATA';

  @override
  String get totalOrdersMetric => 'Total Orders';

  @override
  String get productionOutput => 'Production Output';

  @override
  String get revenue => 'Revenue';

  @override
  String get overallEfficiency => 'Overall Efficiency';

  @override
  String get changeThisMonth => 'this month';

  @override
  String get monthlyProduction => 'Monthly Production';

  @override
  String get unitsThousands => 'Units produced • thousands';

  @override
  String get revenueTrend => 'Revenue Trend';

  @override
  String get revenueThousandsUsd => 'Monthly revenue • thousands USD';

  @override
  String get recentProductionInsights => 'Recent Production Insights';

  @override
  String get unitsColumn => 'UNITS';

  @override
  String get efficiencyColumn => 'EFFICIENCY';

  @override
  String get efficiencyPending => 'Efficiency pending';

  @override
  String get unitsLabel => 'units';

  @override
  String get percentEfficiency => 'efficiency';

  @override
  String get apr => 'Apr';

  @override
  String get may => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Aug';

  @override
  String get sep => 'Sep';

  @override
  String get ordersChange => '+12.8% this month';

  @override
  String get productionChange => '+8.2% this month';

  @override
  String get revenueChange => '+6.4% this month';

  @override
  String get efficiencyChange => '+2.1% this month';

  @override
  String get noOrdersHint => 'Try another order number or customer name.';

  @override
  String get uiPreview => 'GFMS • UI preview';

  @override
  String get materialsDescription =>
      'Maintain factory material master records.';

  @override
  String get refresh => 'Refresh';

  @override
  String get newMaterial => 'New material';

  @override
  String get searchMaterials => 'Search code, name, or description';

  @override
  String get materialTypeFilter => 'Material type';

  @override
  String get defaultUnitFilter => 'Default unit';

  @override
  String get reset => 'Reset';

  @override
  String get materialCodeColumn => 'MATERIAL CODE';

  @override
  String get materialNameColumn => 'MATERIAL NAME';

  @override
  String get materialTypeColumn => 'TYPE';

  @override
  String get defaultUnitColumn => 'DEFAULT UNIT';

  @override
  String get descriptionColumn => 'DESCRIPTION';

  @override
  String get materialActions => 'Material actions';

  @override
  String get viewMaterial => 'View material';

  @override
  String get editMaterial => 'Edit material';

  @override
  String get deactivateMaterial => 'Deactivate material';

  @override
  String get activateMaterial => 'Activate material';

  @override
  String get noMaterials => 'No materials yet';

  @override
  String get noMatchingMaterials => 'No matching materials';

  @override
  String get materialCode => 'Material code';

  @override
  String get materialName => 'Material name';

  @override
  String get materialTypeLabel => 'Material type';

  @override
  String get defaultUnitLabel => 'Default unit';

  @override
  String get materialDescription => 'Description';

  @override
  String get saveMaterial => 'Save material';

  @override
  String get createMaterialTitle => 'Create material';

  @override
  String get editMaterialTitle => 'Edit material';

  @override
  String get materialDialogHint =>
      'Add the details used to identify and issue this factory material.';

  @override
  String get selectMaterialType => 'Select a material type';

  @override
  String get selectDefaultUnit => 'Select a default unit';

  @override
  String get fabricRollHint =>
      'Fabric roll workflows use Meter or Kilogram. Piece is accepted by Material Master but cannot be received as fabric.';

  @override
  String get materialCodeRequired => 'Enter a material code.';

  @override
  String get materialNameRequired => 'Enter a material name.';

  @override
  String get duplicateMaterialCode => 'This material code is already in use.';

  @override
  String get deleteMaterialQuestion => 'Delete material?';

  @override
  String get deleteMaterialPrompt =>
      'Remove this material from the current demo session?';

  @override
  String get otherMaterialType => 'Other';

  @override
  String get fabricMaterialType => 'Fabric';

  @override
  String get accessoryMaterialType => 'Accessory';

  @override
  String get otherMaterialUnit => 'Other';

  @override
  String get meterUnit => 'Meter';

  @override
  String get kilogramUnit => 'Kilogram';

  @override
  String get pieceUnit => 'Piece';

  @override
  String get adminUser => 'Admin User';

  @override
  String get administratorRole => 'Administrator';

  @override
  String get logout => 'Logout';

  @override
  String get materialsDemoNotice =>
      'Local demo data • Changes last for this app session only.';

  @override
  String get cuttingDescription =>
      'Review and manage Cutting records in this local demo.';

  @override
  String get totalCuttingRecords => 'Total Cutting records';

  @override
  String get searchCuttingRecords => 'Search order reference or description';

  @override
  String get addCuttingRecord => 'Add Cutting record';

  @override
  String get editCuttingRecord => 'Edit Cutting record';

  @override
  String get cuttingDescriptionLabel => 'Description';

  @override
  String get cuttingDate => 'Date';

  @override
  String get orderReference => 'Order reference';

  @override
  String get orderReferenceRequired => 'Enter an order reference.';

  @override
  String get cuttingDescriptionRequired => 'Enter a description.';

  @override
  String get cuttingRecordActions => 'Cutting record actions';

  @override
  String get deleteCuttingRecordQuestion => 'Delete Cutting record?';

  @override
  String get deleteCuttingRecordPrompt =>
      'Remove this record from the current demo session?';

  @override
  String get noCuttingRecords => 'No Cutting records yet';

  @override
  String get noCuttingRecordsHint => 'Add a demo record to get started.';

  @override
  String get noMatchingCuttingRecords => 'No matching Cutting records';

  @override
  String get noMatchingCuttingHint =>
      'Try another order reference, description, or status.';

  @override
  String get cuttingDemoNotice =>
      'Local demo data. Changes last for this app session only.';

  @override
  String get managerRole => 'Manager';

  @override
  String get factoryOperations => 'Factory Operations';

  @override
  String get cuttingSubtitle =>
      'Monitor customer order and stock Cutting work.';

  @override
  String get searchCutting => 'Search Cutting';

  @override
  String get searchCuttingPlaceholder =>
      'Cutting, order, customer, model, or cutter...';

  @override
  String get cuttingStatusLabel => 'Status';

  @override
  String get sourceLabel => 'Source';

  @override
  String get allSources => 'All sources';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get cuttingFiltersUnavailable =>
      'Search and filters are inactive until a Cutting data source is connected.';

  @override
  String get notConnected => 'Not connected';

  @override
  String get cuttingNotConnectedExplanation =>
      'No confirmed Cutting endpoint is configured, so records cannot be loaded yet.';

  @override
  String get cuttingNoRequestSent =>
      'Retry will not contact the server until a data source is configured.';

  @override
  String get retry => 'Retry';
}

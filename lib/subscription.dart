class Subscription {
  static String selectedItem = 'Year';
  static const String currency = 'USD';
  static const String taxAmountInPercent = '10';
  static List<String> subscriptionTitleList = [
    'Free',
    'Month',
    'Year',
    'Lifetime',
  ];
  static List<String> subscriptionAmountMonthlyTextList = [
    '\$0/month',
    '\$50/month',
    '\$100/month',
    '\$5000',
  ];
  static List<String> subscriptionAmountYearlyTextList = [
    '\$0/month',
    '\$500/year',
    '\$1000/year',
    '\$5000',
  ];
  static Map<String, Map<String, String>> subscriptionPlansService = {
    'Free': {
      'Sales': '50',
      'Purchase': '50',
      'Due Collection': '50',
      'Parties': '50',
      'Products': '50',
      'Duration': '30',
    },
    'Month': {
      'Sales': 'unlimited',
      'Purchase': 'unlimited',
      'Due Collection': 'unlimited',
      'Parties': 'unlimited',
      'Products': 'unlimited',
      'Duration': '30',
    },
    'Year': {
      'Sales': 'unlimited',
      'Purchase': 'unlimited',
      'Due Collection': 'unlimited',
      'Parties': 'unlimited',
      'Products': 'unlimited',
      'Duration': '365',
    },
    'Lifetime': {
      'Sales': 'unlimited',
      'Purchase': 'unlimited',
      'Due Collection': 'unlimited',
      'Parties': 'unlimited',
      'Products': 'unlimited',
      'Duration': 'unlimited',
    },
  };
  static Map<String, Map<String, double>> subscriptionAmounts = {
    'Free': {
      'Amount': 0,
    },
    'Month': {
      'Amount': 9.99,
    },
    'Year': {
      'Amount': 99.99,
    },
    'Lifetime': {
      'Amount': 999.99,
    },
  };
}

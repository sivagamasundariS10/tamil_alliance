class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length < 10) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  static bool isEmailValid(String? value) {
    if (value == null) return false;
    final email = value.trim().toLowerCase();
    if (email.isEmpty) return false;

    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)+([a-zA-Z]{2,})$');
    if (!emailRegex.hasMatch(email)) return false;

    if (email.contains('..') || email.contains('@.') || email.contains('.@')) {
      return false;
    }

    final parts = email.split('@');
    if (parts.length != 2) return false;
    final username = parts[0];
    final domain = parts[1];

    if (username.isEmpty || domain.isEmpty) return false;

    // Reject common typos for Gmail
    if (domain.startsWith('gmail.')) {
      if (domain != 'gmail.com') return false;
    }
    if ([
      'gmaill.com',
      'gmai.com',
      'gmial.com',
      'gamil.com',
      'gmal.com',
      'gmail.ccom',
      'gmail.comm',
      'gmail.con',
      'gmail.coom'
    ].contains(domain)) {
      return false;
    }

    if (domain.startsWith('yahoo.')) {
      if (!['yahoo.com', 'yahoo.in', 'yahoo.co.in', 'yahoo.co.uk']
          .contains(domain)) {
        return false;
      }
    }

    if (domain.startsWith('hotmail.')) {
      if (!['hotmail.com', 'hotmail.in', 'hotmail.co.uk'].contains(domain)) {
        return false;
      }
    }

    if (domain.startsWith('outlook.')) {
      if (!['outlook.com', 'outlook.in'].contains(domain)) return false;
    }

    if (domain.startsWith('icloud.')) {
      if (domain != 'icloud.com') return false;
    }

    if (domain.startsWith('zoho.')) {
      if (!['zoho.com', 'zoho.in'].contains(domain)) return false;
    }

    if (domain.startsWith('rediffmail.')) {
      if (domain != 'rediffmail.com') return false;
    }

    final domainParts = domain.split('.');
    if (domainParts.length < 2) return false;
    final tld = domainParts.last;

    const validTlds = {
      'com', 'in', 'org', 'net', 'edu', 'gov', 'mil', 'co', 'io', 'ai',
      'info', 'biz', 'me', 'tech', 'online', 'dev', 'app', 'uk', 'us',
      'ca', 'au', 'sg', 'my', 'ae', 'de', 'fr', 'jp', 'cn', 'ru', 'br',
      'world', 'global', 'site', 'store', 'cloud', 'live', 'space',
      'club', 'agency', 'design', 'digital', 'center', 'email', 'pro'
    };

    if (!validTlds.contains(tld)) {
      return false;
    }

    return true;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!isEmailValid(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    if (value.trim().length != 4 && value.trim().length != 6) {
      return 'Please enter a valid OTP';
    }
    return null;
  }
}

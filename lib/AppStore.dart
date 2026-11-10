class PuniAccount {
  PuniAccount({
    required this.username,
    required this.email,
    required this.password,
  });

  String username;
  String email;
  String password;
  String phone = '';
  String address = '';
}

class AppStore {
  AppStore._();

  static final AppStore instance = AppStore._();

  final Map<String, PuniAccount> _accounts = {};
  PuniAccount? currentAccount;

  String? register({
    required String username,
    required String email,
    required String password,
  }) {
    final usernameKey = username.trim().toLowerCase();
    final emailKey = email.trim().toLowerCase();

    if (_accounts.containsKey(usernameKey)) {
      return 'That username is already taken.';
    }
    if (_accounts.values.any(
      (account) => account.email.toLowerCase() == emailKey,
    )) {
      return 'That email is already registered.';
    }

    _accounts[usernameKey] = PuniAccount(
      username: username.trim(),
      email: email.trim(),
      password: password,
    );
    return null;
  }

  bool signIn({required String username, required String password}) {
    final account = _accounts[username.trim().toLowerCase()];
    if (account == null || account.password != password) return false;
    currentAccount = account;
    return true;
  }

  String? updateProfile({
    required String username,
    required String email,
    required String phone,
    required String address,
  }) {
    final account = currentAccount;
    if (account == null) return 'Please sign in again.';

    final usernameKey = username.trim().toLowerCase();
    final emailKey = email.trim().toLowerCase();
    final otherAccount = _accounts[usernameKey];
    if (otherAccount != null && otherAccount != account) {
      return 'That username is already taken.';
    }
    if (_accounts.values.any(
      (other) => other != account && other.email.toLowerCase() == emailKey,
    )) {
      return 'That email is already registered.';
    }

    _accounts.remove(account.username.toLowerCase());
    account.username = username.trim();
    account.email = email.trim();
    account.phone = phone.trim();
    account.address = address.trim();
    _accounts[usernameKey] = account;
    return null;
  }

  bool changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    final account = currentAccount;
    if (account == null || account.password != currentPassword) return false;
    account.password = newPassword;
    return true;
  }

  void signOut() {
    currentAccount = null;
  }
}

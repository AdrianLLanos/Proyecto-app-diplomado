class AppConfig {
  const AppConfig({required this.supabaseUrl, required this.supabasePublishableKey});

  final String supabaseUrl;
  final String supabasePublishableKey;

  factory AppConfig.fromEnvironment() => const AppConfig(
        supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
        supabasePublishableKey:
            String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY'),
      );

  bool get isConfigured =>
      supabaseUrl.trim().isNotEmpty && supabasePublishableKey.trim().isNotEmpty;
}

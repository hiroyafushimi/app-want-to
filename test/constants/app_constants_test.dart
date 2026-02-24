import 'package:flutter_test/flutter_test.dart';
import 'package:want_to/constants/app_constants.dart';

void main() {
  group('SearchSite', () {
    test('buildUrl encodes query and embeds in template', () {
      const site = SearchSite(
        name: 'Test',
        urlTemplate: 'https://example.com/search?q={query}',
      );
      final url = site.buildUrl('hello world');
      expect(url, 'https://example.com/search?q=hello%20world');
    });

    test('buildUrl produces valid URI', () {
      const site = SearchSite(
        name: 'Test',
        urlTemplate: 'https://example.com/search?q={query}',
      );
      final url = site.buildUrl('日本語テスト');
      final uri = Uri.tryParse(url);
      expect(uri, isNotNull);
      expect(uri!.scheme, 'https');
    });
  });

  group('AppConstants.searchSites', () {
    test('contains exactly 3 sites', () {
      expect(AppConstants.searchSites.length, 3);
    });

    test('each site generates a valid URL with encoded query', () {
      for (final site in AppConstants.searchSites) {
        final url = site.buildUrl('test query');
        expect(url, contains('test%20query'));
        expect(Uri.tryParse(url), isNotNull);
        expect(Uri.parse(url).scheme, 'https');
      }
    });

    test('site names include Amazon, Rakuten, Yahoo', () {
      final names = AppConstants.searchSites.map((s) => s.name).toList();
      expect(names, contains('Amazon'));
      expect(names, contains('Rakuten'));
      expect(names, contains('Yahoo! Shopping'));
    });
  });
}

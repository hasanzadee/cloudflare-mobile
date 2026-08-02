import 'package:cloudflare_mobile/core/net/cf_error_codes.dart';
import 'package:cloudflare_mobile/core/net/envelope.dart';
import 'package:cloudflare_mobile/core/net/failure.dart';
import 'package:flutter_test/flutter_test.dart';

CfEnvelope _env(int status, {List<Map<String, Object?>> errors = const []}) =>
    CfEnvelope.fromBody({
      'success': false,
      'errors': errors,
      'result': null,
    }, httpStatus: status);

void main() {
  group('failureFromEnvelope', () {
    test('403 becomes a PermissionFailure naming the missing permission', () {
      // Cloudflare never says which permission group is absent, so the
      // repository supplies it; this is what turns a bare 403 into an
      // actionable "your token is missing DNS: Edit".
      final failure = failureFromEnvelope(
        _env(
          403,
          errors: [
            {'code': 10000, 'message': 'Authentication error'},
          ],
        ),
        missingPermissions: {'DNS Write'},
      );

      expect(failure, isA<PermissionFailure>());
      expect(
        (failure as PermissionFailure).missingPermissions,
        contains('DNS Write'),
      );
      expect(failure.summary, contains('DNS Write'));
    });

    test('401 becomes an AuthFailure', () {
      final failure = failureFromEnvelope(
        _env(
          401,
          errors: [
            {'code': 9109, 'message': 'Invalid access token'},
          ],
        ),
      );
      expect(failure, isA<AuthFailure>());
      expect((failure as AuthFailure).reason, AuthReason.invalid);
    });

    test('a known auth code wins even on a 200-shaped envelope', () {
      final failure = failureFromEnvelope(
        _env(
          200,
          errors: [
            {'code': 10000, 'message': 'Authentication error'},
          ],
        ),
      );
      expect(failure, isA<AuthFailure>());
    });

    test('a record-exists code becomes a ConflictFailure', () {
      final failure = failureFromEnvelope(
        _env(
          400,
          errors: [
            {'code': 81057, 'message': 'Record already exists.'},
          ],
        ),
      );
      expect(failure, isA<ConflictFailure>());
    });

    test('404 and the DNS not-found code both map to NotFoundFailure', () {
      expect(failureFromEnvelope(_env(404)), isA<NotFoundFailure>());
      expect(
        failureFromEnvelope(
          _env(
            400,
            errors: [
              {'code': 81044, 'message': 'Record does not exist.'},
            ],
          ),
        ),
        isA<NotFoundFailure>(),
      );
    });

    test('a JSON pointer produces a field-level ValidationFailure', () {
      final failure = failureFromEnvelope(
        _env(
          400,
          errors: [
            {
              'code': 1004,
              'message': 'content is invalid',
              'source': {'pointer': '/content'},
            },
          ],
        ),
      );

      expect(failure, isA<ValidationFailure>());
      final fields = (failure as ValidationFailure).fields;
      expect(fields.single.field, 'content');
      expect(fields.single.message, 'content is invalid');
    });

    test('5xx becomes a ServerFailure', () {
      expect(failureFromEnvelope(_env(503)), isA<ServerFailure>());
    });

    test('an unrecognised shape degrades to UnknownFailure', () {
      // The error-code table is empirical and incomplete on purpose; an
      // unknown code must never crash or be misclassified as auth.
      expect(
        failureFromEnvelope(
          _env(
            418,
            errors: [
              {'code': 999999, 'message': 'unheard of'},
            ],
          ),
        ),
        isA<UnknownFailure>(),
      );
    });

    test('documentation_url is surfaced for the diagnostics copy', () {
      final failure = failureFromEnvelope(
        _env(
          400,
          errors: [
            {
              'code': 1004,
              'message': 'bad',
              'documentation_url': 'https://developers.cloudflare.com/x',
            },
          ],
        ),
      );
      expect(failure.documentationUrl, 'https://developers.cloudflare.com/x');
    });
  });
}

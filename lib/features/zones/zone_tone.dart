import '../../ui/ds/tone.dart';

/// How a zone's status reads at a glance, everywhere a zone is listed.
Tone zoneTone(String? status) => switch (status) {
  'active' => Tone.success,
  'pending' || 'initializing' => Tone.warning,
  'moved' || 'deleted' || 'deactivated' => Tone.danger,
  _ => Tone.neutral,
};

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:modern_turkmen_admin/data/repositories/audio/audio_repository_remote.dart';
import 'package:modern_turkmen_admin/data/services/audio_player_service.dart';

import 'audio_repository_remote_test.mocks.dart';

@GenerateMocks([AudioPlayerService])
void main() {
  group('AudioRepositoryRemote', () {
    late MockAudioPlayerService mockAudioPlayerService;
    late AudioRepositoryRemote audioRepositoryRemote;

    setUp(() {
      mockAudioPlayerService = MockAudioPlayerService();
      audioRepositoryRemote = AudioRepositoryRemote(audioPlayerService: mockAudioPlayerService);
    });

    test('should delegate onPlayingCompleted to AudioPlayerService', () {
      const stream = Stream<void>.empty();
      when(mockAudioPlayerService.onPlayingCompleted).thenAnswer((_) => stream);

      final result = audioRepositoryRemote.onPlayingCompleted;

      expect(result, equals(stream));
      verify(mockAudioPlayerService.onPlayingCompleted).called(1);
    });

    test('should delegate setSourceUrl to AudioPlayerService', () async {
      const url = 'https://example.com/audio.mp3';
      when(mockAudioPlayerService.setSourceUrl(url)).thenAnswer((_) async => Future.value());

      await audioRepositoryRemote.setSourceUrl(url);

      verify(mockAudioPlayerService.setSourceUrl(url)).called(1);
    });

    test('should delegate pauseAudio to AudioPlayerService', () async {
      when(mockAudioPlayerService.pauseAudio()).thenAnswer((_) async {});

      await audioRepositoryRemote.pauseAudio();

      verify(mockAudioPlayerService.pauseAudio()).called(1);
    });

    test('should delegate resumeAudio to AudioPlayerService', () async {
      when(mockAudioPlayerService.resumeAudio()).thenAnswer((_) async {});

      await audioRepositoryRemote.resumeAudio();

      verify(mockAudioPlayerService.resumeAudio()).called(1);
    });

    test('should delegate onPlayingStarted to AudioPlayerService', () {
      const stream = Stream<void>.empty();
      when(mockAudioPlayerService.onPlayingStarted).thenAnswer((_) => stream);

      final result = audioRepositoryRemote.onPlayingStarted;

      expect(result, equals(stream));
      verify(mockAudioPlayerService.onPlayingStarted).called(1);
    });

    test('should delegate getPlayerStateStream to AudioPlayerService', () {
      const stream = Stream<void>.empty();
      when(mockAudioPlayerService.getPlayerStateStream()).thenAnswer((_) => stream);

      final result = audioRepositoryRemote.getPlayerStateStream();

      expect(result, equals(stream));
      verify(mockAudioPlayerService.getPlayerStateStream()).called(1);
    });
  });
}
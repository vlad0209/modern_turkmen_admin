import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:modern_turkmen_admin/data/services/audio_player_service.dart';

@GenerateNiceMocks([MockSpec<AudioPlayer>()])
import 'audio_player_service_test.mocks.dart';

void main() {
  group('AudioPlayerService', () {
    late MockAudioPlayer mockAudioPlayer;
    late AudioPlayerService service;

    setUpAll(() async {
      // Initialize Flutter binding for tests
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Setup method channel mock for AudioPlayer
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'create':
              return {'playerId': 'test_player_id'};
            case 'setGlobalAudioContext':
              return null;
            default:
              return null;
          }
        },
      );
      
      // Setup method channel mock for GlobalAudioScope
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers.global'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'setGlobalAudioContext':
              return null;
            default:
              return null;
          }
        },
      );
    });

    tearDownAll(() async {
      // Clean up method channel mocks
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers'),
        null,
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('xyz.luan/audioplayers.global'),
        null,
      );
    });

    setUp(() {
      mockAudioPlayer = MockAudioPlayer();
      service = AudioPlayerService(mockAudioPlayer);
    });

    test('onPlayingCompleted returns correct stream', () {
      const stream = Stream<void>.empty();
      when(mockAudioPlayer.onPlayerComplete).thenAnswer((_) => stream);

      expect(service.onPlayingCompleted, equals(stream));
    });

    test('onPlayingStarted filters playing state', () async {
      final controller = StreamController<PlayerState>();
      when(mockAudioPlayer.onPlayerStateChanged).thenAnswer((_) => controller.stream);

      final states = <void>[];
      service.onPlayingStarted.listen((event) => states.add(event));

      controller.add(PlayerState.paused);
      controller.add(PlayerState.playing);
      controller.add(PlayerState.stopped);
      
      await Future.delayed(const Duration(milliseconds: 10));
      expect(states.length, equals(1));
    });

    test('setSourceUrl calls audioPlayer setSourceUrl', () async {
      const url = 'https://example.com/audio.mp3';
      when(mockAudioPlayer.setSourceUrl(url)).thenAnswer((_) async {});

      await service.setSourceUrl(url);

      verify(mockAudioPlayer.setSourceUrl(url)).called(1);
    });

    test('pauseAudio calls audioPlayer pause', () async {
      when(mockAudioPlayer.pause()).thenAnswer((_) async {});

      await service.pauseAudio();

      verify(mockAudioPlayer.pause()).called(1);
    });

    test('resumeAudio calls audioPlayer resume', () async {
      when(mockAudioPlayer.resume()).thenAnswer((_) async {});

      await service.resumeAudio();

      verify(mockAudioPlayer.resume()).called(1);
    });

    test('getPlayerStateStream returns mapped stream', () {
      final controller = StreamController<PlayerState>();
      when(mockAudioPlayer.onPlayerStateChanged).thenAnswer((_) => controller.stream);

      expect(service.getPlayerStateStream(), isA<Stream<void>>());
    });
  });
}
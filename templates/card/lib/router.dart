// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/main_menu/main_menu_screen.dart';
import 'package:card/play_session/lost_game_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_internals/board_state.dart';
import 'game_internals/score.dart';
import 'login/login_screen.dart';
import 'play_session/play_session_screen.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';
import 'win_game/win_game_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(key: Key('login screen')),
      routes: [
        GoRoute(
          path: 'play',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: const ValueKey('play'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const PlaySessionScreen(
              key: Key('level selection'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'won',
              redirect: (context, state) {
                if (state.extra == null) {
                  // Trying to navigate to a win screen without any data.
                  // Possibly by using the browser's back button.
                  return '/';
                }

                // Otherwise, do not redirect.
                return null;
              },
              pageBuilder: (context, state) {
                final map = state.extra! as Map<String, dynamic>;
                final score = map['score'] as Score;
                final boardState = map['boardState'] as BoardState;
                final stopCelebration = map['stopCelebration'] as VoidCallback;

                return buildMyTransition<void>(
                  key: const ValueKey('won'),
                  color: context.watch<Palette>().backgroundPlaySession,
                  child: WinGameScreen(
                    boardState: boardState,
                    score: score,
                    stopCelebration: stopCelebration,
                    key: const Key('win game'),
                  ),
                );
              },
            ),
            GoRoute(
                path: 'lost',
                pageBuilder: (context, state) {
                  final map = state.extra! as Map<String, dynamic>;
                  final score = map['score'] as Score; // Retrieve the score
                  return buildMyTransition<void>(
                    key: const ValueKey('lost'),
                    color: context.watch<Palette>().backgroundPlaySession,
                    child: LostGameScreen(score: score) // Pass the score
                  );
                  
                },
            ),
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
        GoRoute(
          path: 'menu', // Define the menu route
          builder: (context, state) =>
              const MainMenuScreen(key: Key('menu screen')), // Navigate to MenuScreen
        ),
      ],
    ),
  ],
);

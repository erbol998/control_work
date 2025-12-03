import 'dart:math';
import 'boss.dart';
import 'heroes.dart';

class RpgGame {
  static final random = Random();
  static var roundNumber = 0;

  static void startGame() {
    final boss = Boss('Satana', 1500, 50);

    final warrior1 = Warrior('Ahiles', 280, 10);
    final warrior2 = Warrior('Lucifer', 290, 15);
    final magic = Magic('Maga', 270, 10);
    final berserk = Berserk('Viking', 260, 20);
    final doc = Medic('Aibolit', 250, 5, 15);
    final assistant = Medic('Laoma', 300, 5, 5);
    final golem = Golem('Sanya', 500, 10);
    final lucky = Lucky('1win', 170, 15);
    final witcher = Witcher('BabaYaga', 300);
    final thor = Thor('Bee', 235, 15);
    final ludoman = Ludoman('Chuvak', 150, 25 );
    

    final heroes = [
      warrior1,
      doc,
      magic,
      warrior2,
      berserk,
      assistant,
      golem,
      lucky,
      thor,
      witcher,
      ludoman
      
    ];

    _printStatistics(boss, heroes);

    while (!_isGameOver(boss, heroes)) {
      _playRound(boss, heroes);
    }
  }

  static bool _isGameOver(Boss boss, List<Hero> heroes) {
    if (!boss.isAlive()) {
      print('Heroes won!!!');
      return true;
    }

    bool allHeroesDead = true;
    for (var hero in heroes) {
      if (hero.isAlive()) {
        allHeroesDead = false;
        break;
      }
    }
    if (allHeroesDead) {
      print('Boss won!!!');
      return true;
    }

    return false;
  }

  static void _printStatistics(Boss boss, List<Hero> heroes) {
    print('------ ROUND $roundNumber ------');
    print(boss);
    for (var hero in heroes) {
      print(hero);
    }
  }

  static void _playRound(Boss boss, List<Hero> heroes) {
  roundNumber++;
  boss.chooseDefence();

  // Босс атакует героев
  if (boss.isAlive()) {
    boss.attack(heroes);
  }

  // Герои атакуют босса (кроме тех, кто не должен наносить урон)
  for (var hero in heroes) {
    if (hero.isAlive() && boss.isAlive()) {
      if (hero.ability != boss.defence) {
        hero.attack(boss);
      }
    }
  }

  // Применяем суперспособности всех героев
  for (var hero in heroes) {
    if (hero.isAlive()) {
      hero.applySuperPower(boss, heroes);
    }
  }

  // Выводим статистику один раз
  _printStatistics(boss, heroes);
}

  }
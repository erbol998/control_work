
import 'game_character.dart';
import 'super_ability.dart';
import 'boss.dart';
import 'rpg_game.dart';
import 'dart:math';

abstract class Hero extends GameCharacter {
  final int maxHealth; // сохраняем исходное здоровье
  SuperAbility ability;

  Hero(String name, int health, int damage, this.ability)
      : maxHealth = health, // присваиваем maxHealth из переданного health
        super(name, health, damage);

  void attack(Boss boss) {
    boss.health -= damage;
  }

  void applySuperPower(Boss boss, List<Hero> heroes);
}

class Warrior extends Hero {
  Warrior(String name, int health, int damage)
    : super(name, health, damage, SuperAbility.criticalDamage);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    int crit = damage * (RpgGame.random.nextInt(5) + 2);
    boss.health -= crit;
    print('Warrior $name hits critically with $crit');
  }
}

class Magic extends Hero {
  Magic(String name, int health, int damage)
      : super(name, health, damage, SuperAbility.boosting);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    if (RpgGame.roundNumber <= 4 && this.isAlive()) {
      for (var hero in heroes) {
        if (hero.isAlive() && hero != this) {
          int boost = RpgGame.random.nextInt(5) + 1;
          hero.damage += boost;
          print('Magic $name boosted ${hero.name} by $boost');
        }
      }
    }
  }

  @override
  void attack(Boss boss) {
    boss.health -= damage;
    print('$name атакует босса силой $damage');
  }
}
class Berserk extends Hero {
  int blockedDamage = 0;
  Berserk(String name, int health, int damage)
    : super(name, health, damage, SuperAbility.blockRevert);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    boss.health -= blockedDamage;
    print('Berserk $name reverted $blockedDamage');
  }
}

class Medic extends Hero {
  int _healPoints;
  Medic(String name, int health, int damage, this._healPoints)
    : super(name, health, damage, SuperAbility.heal);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    for (var hero in heroes) {
      if (hero.isAlive() && this != hero) {
        hero.health += _healPoints;
      }
    }
  }
}

class Golem extends Hero {
  Golem(String name, int health, int damage)
      : super(name, health, damage, SuperAbility.absorbDamage);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    // Голем поглощает урон от других героев при атаке босса
  }

  @override
  void attack(Boss boss) {
    boss.health -= damage;
    print('$name атакует босса силой $damage');
  }
}

class Lucky extends Hero {
  Lucky(String name, int health, int damage)
      : super(name, health, damage, SuperAbility.dodge);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    // Логика уклонения реализуется в методе Boss.attack
  }

  @override
  void attack(Boss boss) {
    boss.health -= damage;
    print('$name attacks the boss with $damage damage');
  }
}

class Witcher extends Hero {
  bool hasResurrected = false;

  Witcher(String name, int health) : super(name, health, 0, SuperAbility.resurrect);

  @override
  void attack(Boss boss) {
    print('$name does not attack the boss.');
  }

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    if (!hasResurrected && isAlive()) {
      for (var hero in heroes) {
        if (!hero.isAlive()) {
          hero.health = this.health;
          this.health = 0;
          hasResurrected = true;
          print('Witcher $name sacrificed himself to resurrect ${hero.name}');
          break;
        }
      }
    }
  }
}

class Thor extends Hero {
  Thor(String name, int health, int damage) : super(name, health, damage, SuperAbility.stun);

  @override
  void attack(Boss boss) {
    boss.health -= damage;
    print('$name attacks the boss with $damage damage');
  }

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    if (RpgGame.random.nextBool()) {
      boss.isStunned = true;
      print('Thor $name stunned the boss!');
    }
  }
}

class Ludoman extends Hero {
  
  Ludoman(String name, int health, int damage)
      : super(name, health, damage, SuperAbility.dodge);

  @override
  void applySuperPower(Boss boss, List<Hero> heroes) {
    final rnd = Random();

    int d1 = rnd.nextInt(2) + 1; 
    int d2 = rnd.nextInt(4) + 1; 

    print('$name rolls the dice: $d1 and $d2');

    if (d1 == d2) {
      int product = d1 * d2;
      boss.health -= product;
      if (boss.health < 0) boss.health = 0;

      print('Match! $product damage to the Boss. (Boss HP: ${boss.health})');
    } else {
      int sum = d1 + d2;

      List<Hero> teammates =
          heroes.where((h) => h != this && h.health > 0).toList();

      if (teammates.isEmpty) {
        print('No alive teammates.');
        return;
      }

      Hero randomHero = teammates[rnd.nextInt(teammates.length)];
      randomHero.health -= sum;
      if (randomHero.health < 0) randomHero.health = 0;

      print('No match! $sum damage to teammate ${randomHero.name}. '
            '(HP: ${randomHero.health})');
    }
  }
}

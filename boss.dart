import 'game_character.dart';
import 'super_ability.dart';
import 'rpg_game.dart';
import 'heroes.dart';

class Boss extends GameCharacter {
  SuperAbility? defence;
  bool isStunned = false; // флаг оглушения
  Boss(super.name, super.health, super.damage);

  void attack(List<Hero> heroes) {
    if (isStunned) {
      print('Boss ${name} is stunned and skips this round!');
      isStunned = false; // сбрасываем флаг
      return;
    }

    // Находим живого Голема, если он есть
    Golem? golem;
    for (var hero in heroes) {
      if (hero is Golem && hero.isAlive()) {
        golem = hero;
        break;
      }
    }

    for (var hero in heroes) {
      if (!hero.isAlive()) continue;

      // Проверка на Lucky — шанс уклониться
      if (hero is Lucky && RpgGame.random.nextInt(100) < 25) {
        print('Lucky ${hero.name} dodged the attack!');
        continue;
      }

      int finalDamage = damage;

      // Если есть Голем и герой не Голем — часть урона поглощается
      if (golem != null && hero != golem) {
        int absorb = damage ~/ 5; // 1/5 урона идёт на Голема
        finalDamage -= absorb;
        golem.health -= absorb;
        print('Golem ${golem.name} absorbed $absorb damage for ${hero.name}');
      }

      // Berserk блокирует и возвращает часть урона
      if (hero is Berserk && defence != hero.ability) {
        hero.blockedDamage = (RpgGame.random.nextInt(2) + 1) * 5; // 5 или 10
        finalDamage -= hero.blockedDamage;
        if (finalDamage < 0) finalDamage = 0;
        hero.health -= finalDamage;
        print('Berserk ${hero.name} blocked ${hero.blockedDamage}, takes $finalDamage damage');
      } else {
        hero.health -= finalDamage;
        print('${hero.name} takes $finalDamage damage');
      }
    }
  }

  void chooseDefence() {
    var abilities = SuperAbility.values;
    final randomIndex = RpgGame.random.nextInt(abilities.length);
    defence = abilities[randomIndex];
  }

  @override
  String toString() {
    return 'BOSS ${super.toString()} defence: ${defence == null ? 'No defence' : defence!.name}';
  }
}
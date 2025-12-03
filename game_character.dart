abstract class GameCharacter {
  String name;
  int _health;
  int damage;

  GameCharacter(this.name, this._health, this.damage);

  int get health => _health;

  set health(int health) {
    if (health < 0) {
      _health = 0;
    } else {
      _health = health;
    }
  }

  bool isAlive() {
    return health > 0;
  }

  @override
  String toString() {
    return '$name health: $health damage: $damage';
  }
}
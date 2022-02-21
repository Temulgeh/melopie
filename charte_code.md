# Charte du code

Voici une charte afin d'avoir un style et un structure de code communs à tous, pour un code plus cohérent et lisible

## Scènes

Chaque scène aura son propre dossier dans la racine, nommé éponymement, avec les éléments associés à l'intérieur (assets, scripts, sous-scènes...)

## Convention de nommage

- variables, fonctions, signaux: lower_snake_case
- enums: PascalCase
- constantes (y compris dans les enums): UPPER_SNAKE_CASE
- Nodes et Scènes: PascalCase

Le nom des différents éléments doit être en anglais, et décrire rapidement son utilité, avec chaque élément nommé de manière différente:

- variables booléennes: un verbe d'état + un adjectif (exemples: `is_active`, `has_been_activated`)
- autres variables: un nom (exemples: `speed`, `position`, `size`)
- fonctions: un verbe d'action (exemple: `move`, `rotate`) ou un verbe d'action + un nom (exemples: `update_position`, `play_animation`)
- fonction d'évenement: `_on_<evenement>` (exemple: `_on_Button_pressed`)

## Typage

A part si absolument nécessaire, le typage doit être fait, soit implicitement, via l'opérateur `:=`, soit explicitement, de la façon `nom_var: type` pour les variables. Pour les fonctions, le typage doit être explicite: `func ma_fonction(param: type) -> type:`.

## Commentaires

Les commentaires débutent par `#`. Après le `#`, on suivra d'un espace avant d'écrire le commentaire, qui devra être, le plus possible, clair et concis\
Ils sont, en règle générale, à proscrire, puisqu'il faut privilégier un code lisible en lui même

## Formattage du code

Pour l'indentation, on utilise des tabulations.\
On positionne les espaces:

- entre les parenthèses: avant la parenthèse ouvrante (sauf pour les déclarations et appels de fonctions) et après la parenthèse fermante
- entre les crochets: avant le crochet ouvrant (sauf pour les accès aux éléments d'une liste) et après le crochet fermant
- entre les accolades: avant et après chacune
- entre les opérateurs: avant et après chacun

Retours à la ligne:

- 2 entre chaque parties de codes (après une fonction, après la déclaration de variables similaires...)
- Entre chaque élément d'une structure groupée (liste, dictionnaire...) après la virgule, si elle est trop longue
- Entre chaque élement d'un enum
- Dans une fonction pour grouper des actions similaires
- Ne pas hésiter à les utiliser pour aérer le code et le rendre plus lisible

## Structure du code

Le code doit être structuré de la façon suivante:

1. Déclaration des signaux
2. Déclaration des variables modifiables depuis l'éditeur (variables export)
3. Déclaration des classes (si absolument nécessaire)
4. Déclaration des enums
5. Déclaration des constantes
6. Déclaration des variables `onready`
7. Déclaration des variables globales au fichier
8. Déclaration des fonctions qui réagissent à un évenement hors signal
9. Déclaration des fonctions appelées automatiquement
10. Déclaration des fonctions réagissant à un signal
11. Déclaration des fonctions locales

## Divers
Le code doit être lisible et donc ne doit pas trop être indenté. Il convient donc d'éviter de mettre des elses et des ifs imbriqués (sans nécessairement les bannir non plus), et privilégier les [guard clause](https://youtu.be/EumXak7TyQ0)\
ON PEUT METTRE DES RETURN DANS DES BOUCLE `for`, C'EST PLUS LISIBLE ET PERMET DE FAIRE MOINS D'ERREUR QUE SON EQUIVALENT EN `while`
## Exemple de code

```
extends Node2D


signal mon_signal(param: int)


export var variable_modifiable: NodePath


# Ne faites pas de classes mais si vous en faites mettez les ici


enum MonEnum {
    VALEUR_1,
    VALEUR_2
}


const CONSTANTE: int = 5
const AUTRE_CONSTANTE: int = c_constante * 2

const AUTRE_CONSTANTE_QUI_A_RIEN_A_VOIR: float = 50.2


onready var animation_player := $AnimationPlayer

var variable_membre: Vector2


# Les fonctions qui réagissent à un évènement extérieur (sauf connectées par signal)
func _input(event: type_event) -> void:
    pass


# Les fonctions appelées même sans entrée utilisateur
func _ready() -> void:
    pass


func _physics_process(delta: float) -> void:
    je_fais_quelque_chose()
    quelque_chose_d_autre()

    autre_chose_mais_autre_chose_plus_autre()
    autre_chose_plus_autre2()


# Les fonctions connectées par signal
func _on_ennemy_collision(ennemy: Ennemy) -> void:
    pass


# Les fonctions locales
func attaquer() -> void:
    pass
```

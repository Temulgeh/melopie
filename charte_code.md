# Charte du code

Voici une charte afin d'avoir un style et un structure de code communs à tous, pour un code plus cohérent et lisible

## Scènes

Chaque scène aura son propre dossier dans la racine, nommé éponymement, avec les éléments associés à l'intérieur (assets, scripts, sous-scènes...)\

## Convention de nommage

- variables, fonctions, signaux: lower_snake_case
- enums: PascalCase
- constantes (y compris dans les enums): UPPER_SNAKE_CASE
- Nodes et Scènes: PascalCase

## Typage

A part si absolument nécessaire, le typage doit être fait, soit implicitement, via l'opérateur `:=`, soit explicitement, de la façon `nom_var: type` pour les variables. Pour les fonctions, le typage doit être explicite: `func ma_fonction(param: type) -> type:`.

## Commentaires

Les commentaires débutent par `#`. Après le `#`, on suivra d'un espace avant d'écrire le commentaire, qui devra être, le plus possible, clair et concis

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
- Ne pas hésiter à les utiliser pour aérer le code et le rendre plus lisible
-

## Exemple de code

```
extends Node2D


signal mon_signal(param: int)


export var coucou_modifie_moi_uwu: NodePath


# Ne faites pas de classes mais si vous en faites nommez les en PascalCase et mettez les ici


enum MonEnum {
    VALEUR_1,
    VALEUR_2
}


const CONSTANTE: int = 5
const AUTRE_CONSTANTE: int = c_constante * 2

const c_autre_constante_qui_a_rien_a_voir: float = 50.2


onready var animation_player := $AnimationPlayer

var variable_membre: Vector2


# Les fonctions qui réagissent à un évènement extérieur (sauf connectées par signal)
func _input(event):
    pass


# Les fonctions appelées même sans entrée utilisateur
func _ready():
    pass


func _physics_process(delta):
    je_fais_quelque_chose()
    quelque_chose_d_autre()

    autre_chose_mais_autre_chose_plus_autre()
    autre_chose_plus_autre2()


# Les fonctions connectées par signal
func ce_moment_quand_collision_oh_non(ennemi):
    pass


# Les fonctions locales
func attaquer():
    pass
```

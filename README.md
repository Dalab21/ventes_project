# Projet d'analyse des ventes avec Docker et SQLite

## 1. Présentation du projet

Ce projet a pour objectif d'analyser les ventes d'une entreprise sur une période de 30 jours, en tenant compte 
des produits vendus et de leur répartition géographique.

L'architecture repose sur deux services Docker :
- **script-runner** : exécute les scripts Python chargés de récupérer, importer et analyser les données.
- **sqlite-store** : assure le stockage des données dans une base SQLite persistante.

## 2. Architecture

Les deux services communiquent à travers un volume Docker partagé.

```text
             Sources de données
                (Fichiers CSV)
                      |
                      | HTTP / HTTPS
                      v
             +------------------+
             |   script-runner  |
             |                  |
             | Scripts Python   |
             | Import et analyse|
             +------------------+
                      |
                      | Accès au fichier SQLite
                      v
             +------------------+
             |   sqlite-store   |
             |                  |
             |   Base SQLite    |
             +------------------+
                      |
                      v
             Volume Docker
               sqlite_data
```

SQLite ne fonctionne pas comme un serveur réseau classique. Le partage des données s'effectue via un volume Docker.
Pas de ports TCP exposé (différent de PostgreSQL par exemple).

## 3. Technologies utilisées

- Python 3.12 : exécution des scripts.
- SQLite : stockage des données.
- Docker : conteneurisation des services.
- Docker Compose : orchestration des conteneurs.
- Requests : récupération des fichiers depuis des URL HTTP/HTTPS.

## 4. Structure du projet

```text
projet/
├── app/
│   ├── main.py
│   ├── import_data.py
│   └── analysis.py
├── database/
│   └── schema.sql
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env
└── README.md
```

## 5. Installation et lancement

### Prérequis

- Docker
- Docker Compose

### Démarrer les services

Depuis le répertoire racine du projet :

```bash
docker compose up -d --build
```

Cette commande construit les images et démarre les services.

### Vérifier les conteneurs

```bash
docker compose ps
```

### Consulter les logs

```bash
docker compose logs -f
```

### Arrêter les services

```bash
docker compose down
```

Les données SQLite sont conservées dans le volume Docker après l'arrêt des conteneurs.

## 6. Fonctionnement du traitement

Le traitement des données suit les étapes suivantes :

1. Récupération des fichiers CSV depuis leurs URL.
2. Lecture et vérification des données.
3. Importation des produits et des magasins.
4. Importation des ventes dans la base SQLite.
5. Vérification des doublons pour éviter de réimporter les ventes déjà présentes.
6. Exécution des requêtes SQL d'analyse.
7. Enregistrement des résultats dans la table `resultats_analyses`.

## 7. Modèle de données

La base SQLite contient quatre tables principales :

| Table | Description |
|---|---|
| `produits` | Informations sur les produits |
| `magasins` | Informations sur les magasins et leur localisation |
| `ventes` | Historique des ventes |
| `resultats_analyses` | Résultats des analyses réalisées |

## 8. Analyses réalisées

Le projet permet notamment de calculer :

- Le chiffre d'affaires total.
- Le chiffre d'affaires par produit.
- Le chiffre d'affaires par région.

Les résultats sont enregistrés dans la table `resultats_analyses`, avec leur date de calcul.

## 9. Configuration

Les URL des fichiers CSV sont définies dans le fichier `.env`.

Avec flask :

```env
URL_VENTES=lien localhost/ventes.csv
URL_PRODUITS=lien localhost/produits.csv
URL_MAGASINS=lien localhost/magasins.csv
```
(Partie non terminée: avec données réelles).

## 10. Persistance des données

La base SQLite est stockée dans un volume Docker nommé `sqlite_data`.

Ce volume permet de conserver les données même lorsque les conteneurs sont arrêtés ou supprimés.

Pour supprimer également les données persistées :

```bash
docker compose down -v
```

Attention : cette commande supprime définitivement le volume et les données qu'il contient.

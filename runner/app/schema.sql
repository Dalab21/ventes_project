PRAGMA foreign_keys = ON;
 
CREATE TABLE IF NOT EXISTS produits (
    produit_id TEXT PRIMARY KEY,
    nom TEXT NOT NULL,
    categorie TEXT,
    prix_catalogue REAL
);
 
CREATE TABLE IF NOT EXISTS magasins (
    magasin_id TEXT PRIMARY KEY,
    nom TEXT NOT NULL,
    ville TEXT,
    region TEXT,
    code_postal TEXT
);
 
CREATE TABLE IF NOT EXISTS ventes (
    vente_id TEXT PRIMARY KEY,
    date_vente TEXT NOT NULL,
    produit_id TEXT NOT NULL,
    magasin_id TEXT NOT NULL,
    quantite INTEGER NOT NULL CHECK (quantite > 0),
    prix_unitaire REAL NOT NULL CHECK (prix_unitaire >= 0),
    chiffre_affaires REAL NOT NULL,
    FOREIGN KEY (produit_id) REFERENCES produits(produit_id),
    FOREIGN KEY (magasin_id) REFERENCES magasins(magasin_id)
);
 
CREATE TABLE IF NOT EXISTS resultats_analyses (
    resultat_id INTEGER PRIMARY KEY AUTOINCREMENT,
    type_analyse TEXT NOT NULL,
    periode_debut TEXT,
    periode_fin TEXT,
    dimension TEXT,
    valeur REAL NOT NULL,
    calcule_le TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
 
CREATE INDEX IF NOT EXISTS idx_ventes_date ON ventes(date_vente);
CREATE INDEX IF NOT EXISTS idx_ventes_produit ON ventes(produit_id);
CREATE INDEX IF NOT EXISTS idx_ventes_magasin ON ventes(magasin_id);

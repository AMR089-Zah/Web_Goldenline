-- Create the Role table
-- Créer la table des rôles
CREATE TABLE IF NOT EXISTS "Role" (
    id_role SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL
);
SELECT * FROM "Role";

/*
-- Insert data into the Role table
-- Insérer des données dans la table Role
INSERT INTO "Role" (nom) VALUES ('admin');
INSERT INTO "Role" (nom) VALUES ('marketing');
INSERT INTO "Role" (nom) VALUES ('client');
SELECT * FROM "Role";
 */


-- Create the User table
-- Créer la table de User
CREATE TABLE IF NOT EXISTS "User"(
    id_user                         SERIAL PRIMARY KEY,
    Nom_user                        VARCHAR(50),
    Prenom_user                     VARCHAR(255),
    Email                           VARCHAR(50),
    password                        varchar(50),
    gsm                             varchar(50),
    Nbr_enfant                      INT ,
    Class_socioprofessionnelle      VARCHAR(50),
    Ville_user                      VARCHAR(50),
    id_role                     INT NOT NULL,
    FOREIGN KEY (id_role) REFERENCES "Role" (id_role)
);
SELECT *FROM "User";


-- Create the User_Role table to associate users with roles
-- Créer la table User_Role pour associer les utilisateurs à des rôles
CREATE TABLE IF NOT EXISTS "User_Role" (
    id_Role_User SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    id_role INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES "User" (id_user),
    FOREIGN KEY (id_role) REFERENCES "Role" (id_role)
);
SELECT * FROM "User_Role";

-- Enable the trigger for inserting data into user_role
-- Activer le déclencheur pour l'insertion de données dans user_role
CREATE OR REPLACE FUNCTION insert_user_role()
RETURNS TRIGGER AS $$
BEGIN

    -- Insert the association of the user to the role based on the id_role from the "User" table
    -- Insérer l'association de l'utilisateur à la role en fonction de l'id_collecte de la table "User"
    INSERT INTO "User_Role" (id_user, id_role)
    VALUES (NEW.id_user, NEW.id_role);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger to automatically insert user-role associations
-- Créez le déclencheur pour insérer automatiquement les associations user-role
------------------------------------------1 er cas
/*
CREATE TRIGGER insert_user_role_trigger
AFTER INSERT ON "User"
FOR EACH ROW
EXECUTE FUNCTION insert_user_role();
*/
-------------------------------------------2 eme cas
-- Drop the trigger if it exists
-- Supprimez le déclencheur s'il existe
DROP TRIGGER IF EXISTS insert_user_role_trigger ON "User";
-- Create the trigger to automatically insert user-role associations
-- Créer le déclencheur pour insérer automatiquement les associations user-role
CREATE TRIGGER insert_user_role_trigger
AFTER INSERT ON "User"
FOR EACH ROW
EXECUTE FUNCTION insert_user_role();


/*
-- Insert data into the "User" table
-- Replace the following values with the appropriate data for your users
-- Insérer des données dans le tableau "Utilisateur"
-- Remplacez les valeurs suivantes par les données appropriées pour vos utilisateurs
CREATE SEQUENCE if not exists role_id_seq;
INSERT INTO "User" (Nom_user, Prenom_user, Email,password, gsm , Nbr_enfant, class_socioprofessionnelle, Ville_user,id_role)
VALUES ('Renuy', 'Gregory', 'Gregory.renuy@commande.fr','azedfgh','123654',5 , 'Ouvrier', ' Marseille',3
        /*nextval('role_id_seq')*/); -- User with id_role 1
INSERT INTO "User" (Nom_user, Prenom_user, Email,password,  gsm ,Nbr_enfant, class_socioprofessionnelle, Ville_user,id_role)
VALUES ('Dupond', 'José', 'JoséDupond@com.net','ngrgjg','1789632', 2,'Medecin' ,'Nice',3
        /*nextval('role_id_seq')*/); -- User with id_role 2
SELECT *FROM "User_Role";
 */



-- Create the Transaction table
-- Créer la table de Transaction
CREATE TABLE IF NOT EXISTS "Transaction"(
    id_transaction SERIAL PRIMARY KEY,
    Montant_achat  FLOAT NOT NULL,
    Date_passage   TIMESTAMP  NOT NULL,
    id_user        INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES "User" (id_user)
);
SELECT *FROM "Transaction";



-- Create the User_Transaction table
-- Créer la table User_Transaction
CREATE TABLE IF NOT EXISTS "User_Transaction"(
    id_user_transaction SERIAL PRIMARY KEY,
    id_user          INT NOT NULL,
    id_transaction      INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES "User" (id_user),
    FOREIGN KEY (id_transaction) REFERENCES "Transaction" (id_transaction)
);
SELECT *FROM "User_Transaction";




-- Enable the trigger for inserting data into user_transaction
-- Activer le déclencheur pour l'insertion de données dans user_transaction
CREATE OR REPLACE FUNCTION insert_user_transaction()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert the association of the user to the transaction based on the id_transaction from the "User" table
    -- Insérer l'association de l'utilisateur à la transaction en fonction de l'id_transaction de la table "User"
    INSERT INTO "User_Transaction" (id_user, id_transaction)
    VALUES (NEW.id_user, NEW.id_transaction);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger to automatically insert user_transaction associations
-- Créez le déclencheur pour insérer automatiquement les associations user_transaction
------------------------------------------1 er cas
/*
CREATE TRIGGER insert_user_transaction_trigger
AFTER INSERT ON "User"
FOR EACH ROW
EXECUTE FUNCTION insert_role_transaction();
*/
-------------------------------------------2 eme cas
-- Drop the trigger if it exists
-- Supprimez le déclencheur s'il existe
DROP TRIGGER IF EXISTS insert_user_transaction_trigger ON "Transaction";
-- Create the trigger to automatically insert user_transaction associations
-- Créer le déclencheur pour insérer automatiquement les associations user-role_transaction
CREATE TRIGGER insert_user_transaction_trigger
AFTER INSERT ON "Transaction"
FOR EACH ROW
EXECUTE FUNCTION insert_user_transaction();




/*
-- Insert data into the Transaction table
-- Insérer des données dans la table des transactions
INSERT INTO "Transaction" (montant_achat,date_passage,id_user)
VALUES ('120',CURRENT_TIMESTAMP,1 );
INSERT INTO "Transaction" (montant_achat,date_passage,id_user)
VALUES ('50',CURRENT_TIMESTAMP,2 );
SELECT *FROM "Transaction";
 */

--CREATE TABLE  Données anonymisées client
--Créer une TABLE Client Données anonymisées
CREATE TABLE IF NOT EXISTS "Données_anonymisées_client" as
SELECT u.id_user,r.nom as role,u.class_socioprofessionnelle,
       u.Nbr_enfant,u.Ville_user,
       t.montant_achat,t.Date_passage,t.id_transaction as identifiant_collecte
FROM "User" u
        JOIN "User_Transaction" uc ON uc.id_user = u.id_user
        JOIN "Transaction" t ON uc.id_transaction  = t.id_transaction
        JOIN "User_Role" ur ON ur.id_user = u.id_user
        JOIN "Role" r ON ur.id_role  = r.id_role;



--CREATE TABLE  Categorie
--CREATE TABLE Catégorie
CREATE TABLE IF NOT EXISTS "Categorie"(
    id_categorie   SERIAL PRIMARY KEY,
    Categorie_achat1 varchar(50),
    Categorie_achat2 varchar(50),
    Prix_categorie1 FLOAT,
    Prix_categorie2 FLOAT,
    id_transaction INT NOT NULL,
    FOREIGN KEY (id_transaction) REFERENCES "Transaction" (id_transaction)
);
select *FROM "Categorie";



-- Create the Categorie_Transaction table to associate categorie with transaction
-- Créer la table Categorie_Transaction pour associer la catégorie à la transaction
CREATE TABLE IF NOT EXISTS "Categorie_Transaction"(
    id_categorie_collecte SERIAL PRIMARY KEY,
    id_transaction              INT NOT NULL,
    id_categorie         INT NOT NULL,
    FOREIGN KEY (id_categorie) REFERENCES "Categorie" (id_categorie),
    FOREIGN KEY (id_transaction) REFERENCES "Transaction" (id_transaction)
);
SELECT *FROM "Categorie_Transaction";


-- Enable the trigger for inserting data into Categorie_Transaction
-- Activer le déclencheur pour l'insertion de données dans Categorie_Transaction
CREATE OR REPLACE FUNCTION insert_categorie_transaction()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert the association of the categorie to the transaction based on the id_collecte from the "Categorie" table
    -- Insérer l'association de la catégorie à la transaction en fonction de l'id_collecte de la table "Categorie"
    INSERT INTO "Categorie_Transaction" (id_categorie, id_transaction)
    VALUES (NEW.id_categorie, NEW.id_transaction);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger to automatically insert user-role associations
------------------------------------------1 er cas
/*
CREATE TRIGGER insert_user_transaction_trigger
AFTER INSERT ON "User"
FOR EACH ROW
EXECUTE FUNCTION insert_categorie_transaction();
*/
-------------------------------------------2 eme cas
-- Drop the trigger if it exists
-- Supprimez le déclencheur s'il existe
DROP TRIGGER IF EXISTS insert_categorie_Transaction_trigger ON "Categorie";

-- Create the trigger to automatically insert categorie_transaction associations
-- Créer le déclencheur pour insérer automatiquement les associations categorie_transaction
CREATE TRIGGER insert_categorie_transaction_trigger
AFTER INSERT ON "Categorie"
FOR EACH ROW
EXECUTE FUNCTION insert_categorie_transaction();

-- Insert data into the "Categorie" table
--Replace the following values with the appropriate data for your categorie
-- Insérer des données dans le tableau "Catégorie"
--Remplacez les valeurs suivantes par les données appropriées pour votre catégorie
/*
INSERT INTO "Categorie" (Categorie_achat1, Categorie_achat2,Prix_categorie1,Prix_categorie2,id_transaction)
VALUES ('Enfant','Adolescent',60,60,1 );
INSERT INTO "Categorie" (Categorie_achat1, Categorie_achat2,Prix_categorie1,Prix_categorie2,id_transaction)
VALUES ('alimentaire','multimédia',25,25,2 );

SELECT *FROM "Categorie_Transaction";
 */



--CREATE TABLE Collecte
--Créer TABLE Collecte
CREATE TABLE IF NOT EXISTS "Collecte" as
SELECT t.id_transaction as identifiant_collecte,c.Categorie_achat1,c.Categorie_achat2,
       c.Prix_categorie1,c.Prix_categorie2
FROM "Categorie" c
        JOIN "Categorie_Transaction" cc ON cc.id_categorie =c.id_categorie
        JOIN "Transaction" t ON cc.id_transaction =t.id_transaction;




--CREATE TABLE Produit
--Créer TABLE Produit
CREATE TABLE IF NOT EXISTS "Produit"(
    id_produit   SERIAL PRIMARY KEY,
    Nom_prouit   VARCHAR(50),
    Quantité     Int ,
    Prix         FLOAT NOT NULL,
    Description     VARCHAR(50)
);


--CREATE TABLE Magasins
--Créer TABLE Magasins
CREATE TABLE IF NOT EXISTS "Magasins"(
    id_magasins     SERIAL PRIMARY KEY,
    Nom_magasins    VARCHAR(50),
    Ville_magasins  VARCHAR(50)
);


--CREATE TABLE Carte_Fidelite
--Créer TABLE Carte_Fidelite
CREATE TABLE IF NOT EXISTS "Carte_Fidelite"(
    id_carte_fidelite     SERIAL PRIMARY KEY,
    Numero_carte          Varchar(50),
    Point_achat           Int,
    Date_expiration       TIMESTAMP  NOT NULL
);
--ALTER TABLE "User" ENABLE TRIGGER insert_user_role_trigger;
--------------------------------------------------------------------------------
/*
CREATE OR REPLACE FUNCTION insert_user_role()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert the association of the user to the role based on the id_role from the "User" table
    INSERT INTO "User_Role" (id_user, id_role)
    VALUES (NEW.id_user, NEW.id_role);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql; */
--------------------------------------------------------------------------------------
--ALTER TABLE "User" ENABLE TRIGGER insert_user_role_trigger;

-- Insert data into the "User" table
-- Replace the following values with the appropriate data for your users

/*
-- Manually insert data into the "User_Role" table to associate users with roles
INSERT INTO "User_Role" (id_user, id_role) VALUES (1, 1); -- User with id_user 1 gets the "admin_user" role
INSERT INTO "User_Role" (id_user, id_role) VALUES (2, 2); -- User with id_user 2 gets the "marketing_user" role
INSERT INTO "User_Role" (id_user, id_role) VALUES (3, 3); -- User with id_user 2 gets the "marketing_user" role
INSERT INTO "User_Role" (id_user, id_role) VALUES (4, 4); -- User with id_user 2 gets the "marketing_user" role
*/
/*
DELETE FROM "User_Role";
ALTER SEQUENCE "User_Role_id_role_user_seq" RESTART WITH 1;
*/

-- Continue inserting more user-role associations as needed. ------------------------------------------------------



--WHERE r.description =  'admin';
--WHERE r.description =  'client';



--SELECT * FROM "User_Collecte";
--SELECT * FROM "User";

/* Cascade Deletion: You can set up a cascade deletion rule in the foreign key constraint,
 so that when a user is deleted from the "User" table, the associated records in the
 "User_Role" table are also automatically deleted. */

/* --------------------------------- DELETE CASCADE
   ---------------------------------------Cascade Deletion: You can set up a cascade deletion rule in the foreign key
   ---------------------------------------constraint, so that when a user is deleted from the "User" table, the associated records
   ---------------------------------------in the "User_Role" table are also automatically deleted.
*/
/*
ALTER TABLE "User_Role"
DROP CONSTRAINT "User_Role_id_user_fkey",
ADD CONSTRAINT "User_Role_id_user_fkey" FOREIGN KEY (id_user) REFERENCES "User" (id_user) ON DELETE CASCADE;

ALTER TABLE "Categorie_Transaction"
DROP CONSTRAINT "Categorie_Transaction_id_categorie_fkey",
ADD CONSTRAINT "Categorie_Transaction_id_categorie_fkey" FOREIGN KEY (id_categorie) REFERENCES "Categorie" (id_categorie) ON DELETE CASCADE;
*/

/*
-- Replace 1 with the user's id you want to delete
DELETE  FROM "User" WHERE id_user =  1;
ALTER SEQUENCE "User_id_user_seq" RESTART WITH 1;
DELETE  FROM "User_Role" WHERE id_user =  1;
ALTER SEQUENCE "User_Role_id_role_user_seq" RESTART WITH 1;
DELETE  FROM "Données_anonymisées_client" WHERE id_user =  1;

--Replace 1 with the Categorie's id you want to delete
DELETE  FROM "Categorie" WHERE id_categorie =  1;
ALTER SEQUENCE "Categorie_id_categorie_seq" RESTART WITH 1;
DELETE FROM "Categorie_Transaction" WHERE id_categorie =  1;
ALTER SEQUENCE "Categorie_Transaction_id_categorie_collecte_seq" RESTART WITH 1;

--Replace 1 with the Transaction's id you want to delete
DELETE  FROM "Transaction"
ALTER SEQUENCE "Transaction_id_collecte_seq" RESTART WITH 1;
DELETE  FROM "User" WHERE id_collecte =  1;
ALTER SEQUENCE "User_id_user_seq" RESTART WITH 1;
DELETE  FROM "User_Transaction" WHERE id_collecte =  1;
ALTER SEQUENCE "User_Transaction_id_user_transaction_seq" RESTART WITH 1;
DELETE  FROM "Collecte" WHERE id_collecte =  1;
*/





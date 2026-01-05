# Génération de clients OpenVPN

## Description

Ce script Bash permet de générer automatiquement des certificats clients OpenVPN à l’aide de Easy-RSA et de créer pour chaque client un fichier `client.ovpn` prêt à l’emploi.

Pour chaque client fourni en argument, le script :
- Génère un certificat client
- Crée un répertoire dédié
- Copie les certificats et clés nécessaires
- Génère un fichier `client.ovpn` intégrant les certificats
- Met à jour la CRL
- Redémarre le service OpenVPN

---

## Prérequis

- OpenVPN installé et fonctionnel
- Easy-RSA installé dans `/etc/openvpn/easy-rsa/`
- Droits root
- Service OpenVPN : `openvpn@server`

---

## Permissions

Le script doit être rendu exécutable :

```bash
chmod u+x nom_du_fichier.bah
```


## Configuration

Avant d’exécuter le script, les variables suivantes doivent être configurées dans le fichier :

IP='ADRESSE_IP_PUBLIQUE_DU_SERVEUR'
PORT='1194'


IP : adresse IP publique ou nom DNS du serveur OpenVPN
PORT : port d’écoute du serveur OpenVPN

Vérifier également que les fichiers suivants existent :

pki/ca.crt
pki/ta.crt

## Utilisation

Le script doit être exécuté avec les droits root ou via sudo en passant un ou plusieurs noms de clients en argument :

```bash
./nom_du_fichier.bah Client_1 Client_2 Client_N
```



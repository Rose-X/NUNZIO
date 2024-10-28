#!/bin/bash



D_IOC=""
choix_sauv=""
choix_f=""





###################################################################################################################
#                                                   MENU
#####################################################################################################################

# Définition des couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # Pas de couleur

# Fonction du menu avec une meilleure présentation
menu() {
    clear
    
    #!/bin/bash

	echo " "
	echo "         _______       "
	echo "        /       \      "
	echo "       /         \     "
	echo "      |  Nunzio  |    "
	echo "       \         /     "	
	echo "        \_______/      "
	echo "          | |          "
	echo "          | |          "
	echo "          | |          "
	echo "         /   \         "
	echo "        /     \        "
	echo "       |       |       "
	echo " "

    
    
    echo -e "${GREEN}##########################################################${NC}"
    echo -e "${GREEN}#                    ${YELLOW}MENU PRINCIPAL${GREEN}                     #${NC}"
    echo -e "${GREEN}#                    ${YELLOW}By Rose_X${GREEN}                     #${NC}"

    echo -e "${GREEN}##########################################################${NC}"
    echo ""
    echo -e "${BLUE}1)${NC} ${YELLOW}Activer NUNZIO${NC}"
    echo -e "${BLUE}2)${NC} ${YELLOW}Connecter votre phone${NC}"
    echo -e "${BLUE}3)${NC} ${YELLOW}Faire une sauvegarde complète du téléphone${NC}"
    echo -e "${BLUE}4)${NC} ${YELLOW}Installer IOC${NC}"
    echo -e "${BLUE}5)${NC} ${YELLOW}Forensic IOC (PEGASUS)${NC}"
    echo -e "${BLUE}6)${NC} ${YELLOW}Analyse APK VIRUS TOTOAL (PEGASUS)${NC}"
    echo -e "${BLUE}7)${NC} ${YELLOW}Update MVT${NC}"
    echo -e "${BLUE}8)${NC} ${YELLOW}HELP${NC}"
    echo -e "${BLUE}9)${NC} ${YELLOW}LOG${NC}"
    echo -e "${BLUE}10)${NC} ${YELLOW}EXIT${NC}"
    echo ""
    echo -e "${GREEN}##########################################################${NC}"
    echo ""

    # Demande de choix à l'utilisateur
    read -p "Choisissez une option (1-10) : " choix

    # Gestion des choix
    case $choix in
        1)
            echo -e "${YELLOW}Lancement de NUNZIO...${NC}"
            InstalM
            ;;
        2)
            echo -e "${YELLOW}Connexion du téléphone en cours...${NC}"
            ConT
            ;;
        3)
            echo -e "${YELLOW}Sauvegarde complète du téléphone en cours...${NC}"
            SauvT
            ;;
        4)
            echo -e "${YELLOW}Installer IOC...${NC}"
            I_IOC
            ;;
        5)
            echo -e "${YELLOW}Analyse Forensic avec les IOC (PEGASUS) en cours...${NC}"
            Forensic_IOC
            ;;
        6)
            echo -e "${YELLOW}Analyse APK VIRUS TOTOAL...${NC}"
            apk
            ;; 
        7)
            echo -e "${YELLOW}MAJ MVT${NC}"
            MAJ
       
            ;;  
            
      
        8)
            echo -e "${YELLOW}MAJ MVT${NC}"
            HELP    
            ;;     
            
        9)
            echo -e "${YELLOW}LOG${NC}"
            LOG    
            ;;     
            
            
        10)
            echo -e "${YELLOW}EXIT${NC}"
            EXIT    
            ;;   
        *)
            echo -e "${RED}Option invalide, veuillez réessayer.${NC}"
            ;;
    esac
}

# Appel de la fonction menu


#######################################################################################################################
#                                      #INSTALLATION DE MVT ET DE  LA SESSION PYTHON !
#####################################################################################################################
InstalM() {
    echo "Installation de MVT (oui/non) "
    read avis

    oui="oui"
    non="non"

    if [ "$avis" = "$oui" ]; then
         apt install -y python3-pip python3-venv libusb-1.0-0 libudev-dev
        cd ~
        read -p "Donne le nom de ton environnement python : " nom_envi
        
        python3 -m venv "$nom_envi"
        source "$nom_envi"/bin/activate
        
        mkdir ~/mvt
        cd ~/mvt    
        pip install mvt
            
        clear 
        
        echo "Vérification que MVT fonctionne........"
        mvt-ios --help && mvt-android --help
        
         apt install -y android-tools-adb android-tools-fastboot
        cd ~/mvt		
         apt install -y android-platform-tools-base
    else 
        echo "Tu as déjà installé MVT"
    fi
    clear
    echo "SUCCESS"
    menu
}

########################################################################################################################
#                                                     CONNEXION DU TELEPHONE
######################################################################################################################
ConT() {
#Brancher le tel et tester la connexion "

echo "Connecter le telephone...."
adb devices
echo "Telephone connecter ? (oui/non) "
read aviss
ouii="oui" 
nonn="non"
if [ "$aviss" = "$ouii" ]; then
    adb devices
    adb kill-server
else
    echo"Veuillez débrancher et rebrancher le cable USB au téléphone"
fi
clear
menu
}


##########################################################################################################################
#                                            SAUVEGARDE DES DONNEES
########################################################################################################################
SauvT() {
cd ~/mvt     #Ajouter le dossier backup dans la chaine de sauvegarde
read -p "Choisissez  le de Dossier ou vous volez  sauvagarder vos données  ? " choix_sauv
mkdir -p "$choix_sauv" 
read -p "Choisissez le nom de votre fichier  .db : " choix_f
adb backup -apk -shared -all -f ~/mvt/"$choix_f"
mv ~/mvt/"$choix_f" ~/mvt/"$choix_sauv"
git clone https://github.com/nelenkov/android-backup-extractor.git
cd android-backup-extractor
 apt install -y maven
mvn package
cd target/
chmod  777 abe.jar #changer les permissions pour qqchose de plus 'restrictif'
find / -name "abe.jar" -exec mv {} ~/mvt/ \; 2>/dev/null
cd ~/mvt/"$choix_sauv"
java -jar ~/mvt/abe.jar unpack ~/mvt/"$choix_sauv"/"$choix_f"/  ~/mvt/"$choix_sauv"/info.tar

clear
read -p "Choisissez le dossier où extraire les données : " extra_d #meme commentaire, bouger dans le dossier backup dechiffrés avnt de créer le dossier user qui remonte la variable extra_d

mkdir -p ~/mvt/"$extra_d"
tar -xvf ~/mvt/"$choix_sauv"/info.tar -C ~/mvt/"$extra_d"
export choix_sauv   
export choix_f     
menu
}


###############################################################################################################################
#                                          INSTALLATION DES IOC
#############################################################################################################################3
I_IOC() {
echo "Installer les IOC"
read -p "Dossier des IOC" D_IOC   #supprimer la possibilité de recreer le dossier IOC a chaque utilisation, avoir un seul dossier déjà créé 
mkdir ~/mvt/"$D_IOC" #a supprimer 
cd ~/mvt/"$D_IOC" # a modifier enajouter le nom du dossier déjà présent 
#wget https://raw.githubusercontent.com/AmnestyTech/investigations/master/2021-07-18_nso/pegasus.stix2 && wget  wget https://raw.githubusercontent.com/AmnestyTech/investigations/master/2021-12-16_cytrox/cytrox.stix2
download-iocs  
# premiere idee, aller créer une boucle quie prend tous les fichiers finissants par .stix2 



    # Créer le dossier spécifié par l'utilisateur dans le répertoire ~/mvt
   # mkdir -p ~/mvt/"$extra_d"

    # Extraire le fichier info.tar dans le dossier spécifié
    #tar -xvf ~/mvt/"$choix_sauv"/info.tar -C ~/mvt/"$extra_d"
menu
}

###################################################################################################################################
#                                                    FORENSIC IOC 
#################################################################################################################################3
Forensic_IOC() {
    adb kill-server
    adb start-server
    adb kill-server
    
    # Utilise les variables globales exportées par SauvT

    # Assure-toi que D_IOC est défini, sinon ajoute un test
   # if [ -z "$D_IOC" ]; then
  #      echo "La variable D_IOC n'est pas définie. Assurez-vous qu'elle est définie avant de lancer le script."
 #       return
#    fi

    # Se déplacer vers le répertoire des IOC
    #cd ~/mvt/"$D_IOC"/ || { echo "Erreur: Impossible de se déplacer vers ~/mvt/$D_IOC"; return; }

    # Exécute la commande mvt-android avec le chemin correct vers les IOC
    mvt-android check-adb --iocs ~/mvt/ioc/ --output ~/mvt/

    # Demander le mot de passe de debug (backup)
    read -p "Rentre le mot de passe du debug : " mdp

    # Si tu veux utiliser le mot de passe pour une autre commande, décommente la ligne suivante :
    # mvt-android check-backup --backup-password "$mdp" --iocs /home/adm-forensics/IOC --output ~/mvt/"$choix_sauv"
    
    echo "Analyse Forensic avec MVT terminée."
menu
}







###################################################################################################################
#                                                   ANALYSE APK VIRUS-TOTAL
#####################################################################################################################

apk() {
    echo "Analyse APK automatique..."

    # Définition du dossier principal
    Info_Phone="Info_phone"
    Base_Dir=~/mvt/"$Info_Phone" 

    # Création du dossier principal si nécessaire
    mkdir -p "$Base_Dir"  #Ajouter le dossier 'Resultats' déjà existant

    # Génération d'un nom de dossier horodaté pour éviter les conflits
    nom_doc=$(date +"%Y%m%d_%H%M%S")

    # Chemin du dossier de sortie
    Output_Dir="$Base_Dir/$nom_doc"

    # Création du dossier pour les résultats
    mkdir -p "$Output_Dir"

    echo "Les données se trouvent dans $Output_Dir"

    # Téléchargement des APKs et analyse avec VirusTotal
    echo "Téléchargement des APKs et analyse avec VirusTotal en cours..."
    MVT_VT_API_KEY="3d7181e63ff474cf34dceaf40d943a74bca7b47aad946fbb8615b657cc0555c3" \
    mvt-android download-apks --output "$Output_Dir" --virustotal

    if [ $? -ne 0 ]; then
        echo "Échec du téléchargement des APKs ou de l'analyse avec VirusTotal."
        return 1
    fi

    echo "Analyse terminée. Les résultats se trouvent dans $Output_Dir/"
}

#apk() {
 #   echo "Analyse apk...."
  #  Info_Phone="Info_phone"
    
    # Crée le dossier principal si besoin
 #   mkdir -p ~/mvt/"$Info_Phone"
    
    # Demande le nom du dossier à l'utilisateur
 #   read -p "Nom Dossier Information tel: " nom_doc
    
    # Vérifie si le dossier n'existe pas encore
 #   if [ ! -e ~/mvt/"$Info_Phone"/"$nom_doc" ]; then 
  #      mkdir -p ~/mvt/"$Info_Phone"/"$nom_doc"
   #     echo "Les données se trouvent dans ~/mvt/$Info_Phone/$nom_doc"
  #  else
   #     echo "Le dossier '$nom_doc' existe déjà."
   # fi 

    # Téléchargement des APKs dans le dossier spécifié
    #echo "Téléchargement des APKs dans ~/mvt/$Info_Phone/$nom_doc/apks.json"
    #mvt-android download-apks -a --output ~/mvt/"$Info_Phone"/"$nom_doc"/apks.json 

    #if [ $? -ne 0 ]; then
     #   echo "Échec du téléchargement des APKs."
      #  return 1
    #fi

    # Analyse des APKs téléchargées avec VirusTotal en utilisant la clé API intégrée
    #echo "Analyse des APKs avec VirusTotal en cours..."
    #MVT_VT_API_KEY="3d7181e63ff474cf34dceaf40d943a74bca7b47aad946fbb8615b657cc0555c3" \
    #mvt-android -vt-upload --apk-json ~/mvt/"$Info_Phone"/"$nom_doc"/apks.json
    
   # if [ $? -ne 0 ]; then
    #    echo "Échec de l'analyse avec VirusTotal."
     #   return 1
    #fi

   # echo "Analyse terminée. Les résultats se trouvent dans ~/mvt/$Info_Phone/$nom_doc/"
#}

###################################################################################################################
#                                                   FAIRE LA MAJ MVT ANDROID
#####################################################################################################################

MAJ () {

echo  " MAJ MVT-ANDROID "
git pull
pip install .

menu
}

###################################################################################################################
#                                                  HELP
#####################################################################################################################

HELP () {
mvt-android --help
yes="oui"
read -p "menu (oui/non)" help_menu
if [ "$help_menu" = "$yes" ]; then
    menu
    
else
    mvt-android --help    
fi
}

############################################################################################################################################################################################################################

LOG () {

adb devices
adb kill-server
adb start-server

adb logcat -d 



}

EXIT () {

exit



}









# Variables pour les couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # Pas de couleur















# Introduction du programme NUNZIO avec couleurs

clear
echo " "
echo "          \     /      "
echo "         -- Nunzio -- "
echo "        /_\\ | /_\\    "
echo "           / | \\       "
echo "          /  |  \\      "
echo "         *   |   *     "
echo "            / \\        "
echo "           /   \\       "
echo "          /     \\      "
echo " "




echo -e "${GREEN}##########################################################${NC}"
echo -e "${GREEN}#${NC}                                                      ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}               ${YELLOW}Bienvenue dans ${RED}NUNZIO${NC}               ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}                                                      ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${BLUE}NUNZIO${NC} ${YELLOW}est un outil d'analyse forensique conçu${NC}  ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${YELLOW}pour l'investigation des appareils Android.${NC}         ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${YELLOW}Il vous aide à sauvegarder, extraire et analyser${NC}    ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${YELLOW}des indicateurs de compromission (IOC).${NC}             ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}                                                      ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${BLUE}- Sauvegarde des données via adb${NC}                    ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${BLUE}- Extraction et analyse des IOC${NC}                  ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${BLUE}- Utilisation d'outils spécialisés comme Android${NC} ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${BLUE}  Backup Extractor${NC}                                 ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}                                                      ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${YELLOW}NUNZIO simplifie vos investigations forensiques${NC}  ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}  ${YELLOW}en toute sécurité et efficacité.${NC}                   ${GREEN}#${NC}"
echo -e "${GREEN}#${NC}                                                      ${GREEN}#${NC}"
echo -e "${GREEN}##########################################################${NC}"
echo ""

# Pause pour laisser l'utilisateur lire
read -p "Appuyez sur Entrée pour commencer..."

menu










#Choix crée un menu Activer environnement Python"
#echo "Active ton environnement Python (2:oui/n)"
#read aviss
#ouii="2"
#non="n"
#if [ "$a~/mvtviss" = "$ouii" ]; then
#    source $nom_envi/bin/activate
#else
#    echo""
#fi



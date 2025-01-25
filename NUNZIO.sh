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
    

VERT="\e[32m"
CYAN="\e[36m"
ROUGE="\e[31m"
RESET="\e[0m"

echo -e "${VERT} ███╗   ██╗██╗   ██╗███╗   ██╗███████╗██╗ ██████╗ ██████╗ "
echo -e "${CYAN} ████╗  ██║██║   ██║████╗  ██║██╔════╝██║██╔════╝██╔═══██╗"
echo -e "${ROUGE} ██╔██╗ ██║██║   ██║██╔██╗ ██║█████╗  ██║██║     ██║   ██║"
echo -e "${VERT} ██║╚██╗██║██║   ██║██║╚██╗██║██╔══╝  ██║██║     ██║   ██║"
echo -e "${CYAN} ██║ ╚████║╚██████╔╝██║ ╚████║██║     ██║╚██████╗╚██████╔╝"
echo -e "${ROUGE} ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ ╚═════╝ "
echo -e "${RESET}"

    
    
    echo -e "${GREEN}##########################################################${NC}"
    echo -e "${GREEN}#                    ${YELLOW}MENU PRINCIPAL${GREEN}                #${NC}"
    echo -e "${GREEN}#                    ${YELLOW} By Rose_X  ${GREEN}                  #${NC}"

    echo -e "${GREEN}##########################################################${NC}"
    echo ""
    echo -e "${BLUE}1)${NC} ${YELLOW} :Activer NUNZIO${NC}"
    echo -e "${BLUE}2)${NC} ${YELLOW} :Connecter votre phone${NC}"
    echo -e "${BLUE}3)${NC} ${YELLOW} :Faire une sauvegarde complète du téléphone${NC}"
    echo -e "${BLUE}4)${NC} ${YELLOW} :Installer IOC${NC}"
    echo -e "${BLUE}5)${NC} ${YELLOW} :Forensic IOC (PEGASUS)${NC}"
    echo -e "${BLUE}6)${NC} ${YELLOW} :Analyse APK VIRUS TOTOAL (PEGASUS)${NC}"
    echo -e "${BLUE}7)${NC} ${YELLOW} :Update MVT${NC}"
    echo -e "${BLUE}8)${NC} ${YELLOW} :HELP${NC}"
    echo -e "${BLUE}9)${NC} ${YELLOW} :LOG${NC}"
    echo -e "${BLUE}10)${NC} ${YELLOW}:EXIT..${NC}"
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
read -p "Dossier des IOC" D_IOC   
mkdir ~/mvt/"$D_IOC" 
cd ~/mvt/"$D_IOC" 
wget https://raw.githubusercontent.com/AmnestyTech/investigations/master/2021-07-18_nso/pegasus.stix2 && wget  wget https://raw.githubusercontent.com/AmnestyTech/investigations/master/2021-12-16_cytrox/cytrox.stix2
download-iocs  





   # mkdir -p ~/mvt/"$extra_d"

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
    

 
    mvt-android check-adb --iocs ~/mvt/ioc/ --output ~/mvt/

    read -p "Rentre le mot de passe du debug : " mdp


    echo "Analyse Forensic avec MVT terminée."
menu
}







###################################################################################################################
#                                                   ANALYSE APK VIRUS-TOTAL
#####################################################################################################################

apk() {
    echo "Analyse APK automatique..."

    Info_Phone="Info_phone"
    Base_Dir=~/mvt/"$Info_Phone" 

    mkdir -p "$Base_Dir"  

    nom_doc=$(date +"%Y%m%d_%H%M%S")

    Output_Dir="$Base_Dir/$nom_doc"

    mkdir -p "$Output_Dir"

    echo "Les données se trouvent dans $Output_Dir"

    echo "Téléchargement des APKs et analyse avec VirusTotal en cours..."
    MVT_VT_API_KEY="" \ #Mettre votre Key virustotal
    mvt-android download-apks --output "$Output_Dir" --virustotal

    if [ $? -ne 0 ]; then
        echo "Échec du téléchargement des APKs ou de l'analyse avec VirusTotal."
        return 1
    fi

    echo "Analyse terminée. Les résultats se trouvent dans $Output_Dir/"
}



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
















clear
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' 


echo -e "${GREEN}      _     _           _       ${NC}"
echo -e "${YELLOW}     | |   (_)         | |      ${NC}"
echo -e "${BLUE}     | |__  _ _ __   __| | ___  ${NC}"
echo -e "${MAGENTA}     | '_ \| | '_ \ / _\` |/ _ \ ${NC}"
echo -e "${CYAN}     | | | | | | | | (_| | (_) |${NC}"
echo -e "${RED}     |_| |_|_|_| |_|\__,_|\___/ ${NC}"
echo -e "                                       "
echo -e "${BLUE}             1933-2024             ${NC} "
echo -e "${GREEN}           J U N G L E          ${NC}"

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



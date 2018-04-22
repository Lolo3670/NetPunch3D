import java.net.*; //Paquet réseau //<>//
import java.io.*; //2e paquet pour le réseau
import java.awt.Robot; //Pour recentrer la souris
import javax.swing.JOptionPane; //Pour les boites de dialogue

final int CONNEXION = 1; //constantes
final int PARTIE = 2;
final int STATISTIQUES = 3;

int etape; //L'étape en cours

Robot robot; //Pour la fonction Robot.mouseMove()

Socket socket; //Connection avec le serveur
DataOutputStream out; //Flux sortant de données (permet d'envoyer les infos à travers le socket)
DataInputStream in; //Flux entrant (permet de recevoir les infos)

final ArrayList<Info> infos = new ArrayList<Info>(); //Les infos des joueurs dans un tableau à taille variable

ArrayList<Influent> influents; //Entitées pouvant influencer les personnages, les faire bouger
ArrayList<Personnage> personnages; //Liste des personnages

int indexPersonnage = -1; //Index personnage relatif au client (l'indice du personnage avec lequel joue l'utilisateur) -1 => pas encore défini
int indexMeilleur = 0; //Le meilleur joueur pour le score à la fin

int tempsDebutPartie = 0; //millis() au début de la partie (pour la synchronisation avec le serveur dans les animations)

float angleCameraX = 0, angleCameraY = HALF_PI; //angles de vue dela caméra

Info info; //Les informations de personnage de cet ordi

void setup() {
  String ip = JOptionPane.showInputDialog("Adresse IP du serveur : "); //ip du serveur demandée à l'utilisateur par une boite de dialogue
  String pseudo = JOptionPane.showInputDialog("Pseudo du joueur : "); //idem avecle pseudo

  etape = CONNEXION; //Etape en cours = CONNEXION

  try //Nécessaire car Robot n'est pas une classe de processing et qu'il faut gérer les exceptions (s'il y en a une arrêt du code et on va dans le block catch)
  {
    robot = new Robot();
    throw new Exception();
  }
  catch (Exception e) //En cas d'erreur : afficher le message d'erreur dans la console
  {
    e.printStackTrace();
  }

  //size(1280, 752, P3D);
  fullScreen(P3D); //Plein écran

  try
  {
    /*Initialisation du réseau*/
    socket = new Socket(ip, 8000); //On se connecte au serveur indiqué à l'adresse ip indiquée sur le port 8000
    out = new DataOutputStream(socket.getOutputStream()); //on récupère le DataOutputStream qui correspond
    in = new DataInputStream(socket.getInputStream()); //Idem DataInputStream

    /* Envoi des infos de bases du joueur */
    out.writeUTF(pseudo); // Envoi du pseudo
    out.writeInt(0); //Le nombre correspondant au perso choisi
    info = new Info(pseudo, 0, false); //On initialise la variable info avec les infos de base (pseudo + choix de Globulix qui correspond à un 0 + n'a pas encore validé)

    /* Reçois la liste des joueurs déjà connectés*/
    int nb = in.readInt(); //Combien de joueurs ?
    for (int i = 0; i < nb; i++) //Pour chaque joueur
    {
      infos.add(new Info(in.readUTF(), in.readInt(), in.readBoolean())); //On l'ajoute au tableau en récupérant dans l'ordre leur pseudo, leur choix de perso et s'ils ont validé
    }
  }
  catch (Exception e) //En cas d'erreur
  {
    e.printStackTrace();
  }

  thread("reception"); //On lance un thread qui gérera le réseau de manière asynchrone

  influents = new ArrayList<Influent>(); //Initialiser le tableau d'influents
  personnages = new ArrayList<Personnage>(); //Idem personnages
}

int tempsRendu = 0; //Temps au moment du rendu => temps par rapport au début de la partie
int tempsCoordonnees = 0; //Temps depuisle dernier envoie des coordonnées caméra

void draw() {
  switch (etape) //Selon l'étape
  {
  case CONNEXION: //Ecran de connexion
    scale(width / 1280.0f, height / 752.0f, 1); //Remise à l'échelle du texte...etc... dans le cas où l'écran n'est pas à la bonne taille

    background(0); //Fond noir, on efface ce qui est déjà affiché pour réécrire au propre

    /* Affichage des instruction */
    fill(255); //Couleur d'écriture : blanc
    textSize(12); //Taille du texte : 12 pixel de hauteur
    text("     Appuyez sur entrée pour confirmer", 640, 376);
    text("Ejectez le plus d'adversaires hors du terrain !", 900, 525);
    text("Pour avancer ou reculer utilisez les fleches du clavier", 900, 550);
    text("Coup basique : clique gauche", 900, 575);
    text("Coup spercial : clique droit", 900, 600);
    text("Bouclier : mollette", 900, 625);

    /* Symboles en bas à droite qui indique qu'il faut patienter */
    ellipse(1220+10*cos(millis()/250.0f), 720+10*sin(millis()/250.0f), 5, 5); //millis() = temps en milliseconde depuis le début de l'exécution du programme
    ellipse(1220+10*cos(PI+millis()/250.0f), 720+10*sin(PI+millis()/250.0f), 5, 5); //cos() et sin() correspondent aux abscisses et ordonnées des points du cercle trigonométrique pour un angle donné en radian => ici nous sert à faire se déplacer les objets sur un cercler

    /* Afficher les infos de chaque joueur dans leur case */
    for (int i = 0; i < infos.size(); i++)
    {
      if (infos.get(i).aValide) //Si le joueur à validé, le rectangle est blanc sinon il est gris
        fill(255);
      else
        fill(100);
      rect(0, 0, 320, 188); // Le rectangle en question
      fill(0); //Noir pour le texte
      text(infos.get(i).pseudo, 20, 33); //Afficher le pseudo
      rect(10, 50, 128, 128); //Un rectangle noir, bientôt une icône du perso en question
      text(nomPerso(infos.get(i).type), 158, 102); //Afficher le personnage choisi selon le numéro indiqué dans le membre type de laclasse Info

      translate(0, 188); //Le rendu de la case suivante se fera en dessous
      if ((i % 4) == 3) //Lorsqu'on arrive à la 4e ligne, on avance d'un cran vers la droite et on effectue le prochain rendu en haut
        translate(320, -752);
    }
    break;

  case PARTIE:
    rectMode(CENTER); //Les rectangles sont centrés sur le point qu'on leur donne
    perspective(PI/3, float(width)/float(height), 0.1f, 10000.0f); //3D  avec perspective
    background(#B0C1C1); //Fond gris

    if (indexPersonnage != -1) //Si un perso est assigné au client
    {
      tempsRendu = millis() - tempsDebutPartie; //Tout les calculs de rendus se feront suivant cette variable : il faut qu'ils soit fait pour un instant donné, si on utilise millis(), sa valeur aura eu le temps de changer entre le début et la fin de la frame

      /*Gestion de la caméra*/
      angleCameraY += (((mouseX - 500) * 2.0 * PI) / float(width)); //On ajoute à l'angle dela caméra une valeur qui correspond au décallage en pixel de la souris depuis la dernière frame
      angleCameraX += (((mouseY - 500) * PI) / float(height));
      Vecteur position = personnages.get(indexPersonnage).equation.calculPosition(tempsRendu); //On obtient la position du perso assigné
      camera(position.x, position.y, position.z, position.x + cos(angleCameraX) * cos(angleCameraY), position.y - sin(angleCameraX), position.z - cos(angleCameraX) * sin(angleCameraY), 0, -1, 0); //Grace aux anglesde vue de la caméra, on sait vers où elle regarde, et grace à la position du joueur, on sait oùla caméra se situe
    }

    robot.mouseMove(500, 500); //On recentre la souris pour mesurer un décalage correct à la prochaine frame

    for (int i = 0; i < personnages.size(); i++)
    {
      personnages.get(i).Rendu(tempsRendu); //Afficher chaque perso
    }
    for (int i = 0; i < influents.size(); i++)
    {
      influents.get(i).Rendu(tempsRendu); //Afficher chaque influent
    }

    if ((millis() - tempsCoordonnees) > 50) //Si ça fait plus de 150 ms qu'on a envoyé les infos d'orientation, on les renvoie, on le fait pas à chaque frame pour éviter de surcharger le réseau
    {
      try
      {
        out.writeByte(105); //code 105
        out.writeFloat(angleCameraX); //suivi des angles
        out.writeFloat(angleCameraY);
      }
      catch (Exception e)
      {
        e.printStackTrace();
      }
      tempsCoordonnees = millis(); //On remet à jour tempsCoordonnees pour refaire la différence après
    }

    hint(DISABLE_DEPTH_TEST); //Désactiver le test de profondeur (permet au texte d'avoir un fond transparent et de s'afficher par dessus l'image coute que coute)

    /* Afficher les pseudos */
    fill(0); //texte noir
    textAlign(CENTER, CENTER); //Centré sur le point qu'on lui donne
    textSize(0.25); //Très petit (mais déjà suffisament grand) :)
    for (int i = 0; i < personnages.size(); i++)
    {
      if (i != indexPersonnage) //s'il ne s'agit pas du personnage assigné (pas besoin d'afficher le pseudo du joueur qui est derrière l'écran)
      {
        pushMatrix(); //On ajoute une matrice
        Vecteur position = personnages.get(i).equation.calculPosition(tempsRendu); //On obtient la position du perso en question
        translate(position.x, position.y + 1, position.z); //On se position là où il est
        rotateY(angleCameraY + HALF_PI); //on tourne le texte pour qu'il soit face à la caméra
        rotateX(PI + angleCameraX);
        text(infos.get(i).pseudo, 0, 0); //on l'affiche
        popMatrix(); //Toutes les transformations depuis le ddernier pushMatrix() sont oubliées
      }
    }

    /* Afficher l'interface utilisateur */
    camera(); //réinitialiser la caméra
    perspective(); //plus de perspective

    scale(width / 1280.0f, height / 752.0f, 1); //Remise à l'échelle du texte...etc... dans le cas où l'écran n'est pas à la bonne taille

    /* Timer */
    fill(#D3EFFF);
    stroke(#99C1D8); //couleur des bordures
    rect(0, 0, 220, 100);
    fill(0);
    textSize(25);
    text(180-(tempsRendu/1000), 30, 30);

    /* Les scores de frappes des joueurs */
    for (int i = 0; i < personnages.size(); i++)
    {
      fill(255*abs(cos(i * 0.25))+50, 255*abs(sin(i * 0.25))+50, 255*abs(cos(i * 0.25))+50);
      rect(160, 730, 140, 100);
      fill(0);
      text((personnages.get(i).scoreFrappe * 100) +"    %", 140, 733);
      translate(240, 0);
      if ((i % 4) == 3) //Lorsqu'on arrive à la 4e ligne, on avance d'un cran vers la droite et on effectue le prochain rendu en haut
        translate(-320, -720);
    }
    hint(ENABLE_DEPTH_TEST); //reactiver le test de profondeur
    break;

  case STATISTIQUES:
    scale(width / 1280.0f, height / 752.0f, 1); //Remise à l'échelle du texte...etc... dans le cas où l'écran n'est pas à la bonne taille

    rectMode(NORMAL);
    textAlign(NORMAL, NORMAL);
    background(0);
    textSize(16);
    fill(255);

    /*Affichge des scores*/
    for (int i = 0; i < infos.size(); i++)
    {
      int r = 0, b = 0;
      if (i == indexPersonnage) //Si c'est le perso assigné : fond bleu
        b = 100;

      if (personnages.get(indexMeilleur).score == personnages.get(i).score) //s'il a le meilleur score : fond rouge
        r = 100;

      fill(255 - b, 255 - r - b, 255 - r); //Fond
      rect(0, 0, 320, 188);
      fill(0);
      text(infos.get(i).pseudo, 20, 33); //Pseudo
      text(personnages.get(i).score, 168, 102); //Score du perso
      text(nomPerso(infos.get(i).type), 20, 102); //Perso choisi

      translate(0, 188);
      if ((i % 4) == 3)
        translate(320, -752);
    }
    break;

  default:
    exit();
    break;
  }
}

void reception() //Le thread du reseau
{
  byte code; //Le code (cf protocole)
  try
  {
    while (etape == CONNEXION)
    {
      code = in.readByte(); //Je récupère le code
      switch (code) //selon le code je récu^père les infos présentes et j'agis différement
      {
      case 2: //Qqun a changé de type
        synchronized(infos) //synchronized = eviter les accès concurrentiels en écriture au tableau
        {
          infos.get(in.readInt()).type = in.readInt();
        }
        break;

      case 3: //Qqun a quitté
        synchronized (infos)
        {
          infos.remove(in.readInt());
        }
        break;

      case 4: // Un perso se co
        synchronized (infos)
        {
          infos.add(new Info(in.readUTF(), in.readInt(), false)); //Je suis sur qu'il a pas validé
        }
        break;

      case 5: //Un perso valide
        synchronized (infos)
        {
          infos.get(in.readInt()).aValide = true;
        }
        break;

      case 6: //La partie démarre
        tempsDebutPartie = millis() + 1000; //je règle le début de la partie (+100 et delay pour le réseau s'initialise ainsi que le serveur)
        delay(1000);
        etape = PARTIE; //On passe en étape partie
        break;
      }
    }

    while (etape == PARTIE)
    {
      code = in.readByte();
      switch (code)
      {
      case 7: //Fin de la partie (tri du meilleur perso)
        for (int i = 0; i < personnages.size(); i++) //On garde l'index du joueur qui a eu le socre le plus élevé
        {
          if (personnages.get(i).score > personnages.get(indexMeilleur).score)
            indexMeilleur = i;
        }
        etape = STATISTIQUES; //on passe en étape afficher les cores à la fin
        break; 

      case 8 : //Entitée apparue
        {
          int type = in.readInt(); //on récupère le type de l'entitée apparue
          switch (type)
          {
          case 0 : 
            personnages.add(new Globulix(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt())); 
            break; 

          case 1 : 
            personnages.add(new Cubeman(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt())); 
            break; 

          case 2:
            personnages.add(new Plasmax(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt()));
            break;

          case 100 : 
            influents.add(new Terrain(in.readFloat(), in.readFloat(), in.readFloat())); 
            break; 

          case 200 : 
            influents.add(new ProjectileTest(in.readInt())); //ProjectileTest = un projectile invsibles
            break;

          case 201:
            influents.add(new ProjectileCompCubeman(new Vecteur(in.readFloat(), in.readFloat(), in.readFloat()), new Vecteur(in.readFloat(), in.readFloat(), in.readFloat()), in.readInt()));
            break;

          case 202:
            influents.add(new ProjectileCompPlasmax(new Vecteur(in.readFloat(), in.readFloat(), in.readFloat()), new Vecteur(in.readFloat(), in.readFloat(), in.readFloat()), in.readInt()));
            break;
          }
        }
        break; 

      case 9 : //Un perso a changé d'équation
        {
          int index = in.readInt(); //Quel perso ? son indice
          byte type = in.readByte();  //quel type d'équation ?
          switch (type)
          {
          case 0 : 
            personnages.get(index).equation = new EquationNulle(in.readFloat(), in.readFloat(), in.readFloat()); 
            break; 

          case 1 : 
            personnages.get(index).equation = new EquationLineaire(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt()); 
            break; 

          case 2 : 
            personnages.get(index).equation = new EquationGravite(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt()); 
            break; 

          case 4 : //Equation double
            Equation equation1, equation2; 

            /* Récupérer la premier partie */
            byte type2 = in.readByte(); 
            switch(type2)
            {
            case 0 : 
              equation1 = new EquationNulle(in.readFloat(), in.readFloat(), in.readFloat()); 
              break; 

            case 1 : 
              equation1 = new EquationLineaire(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt()); 
              break; 

            case 2 : 
              equation1 = new EquationGravite(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt()); 
              break; 

            default :  //Equation double dans equation double interdite
              throw new Exception("pas bon type equation1 " + type2); //on largue un erreur
            }

            /* Récupérer la 2e partie */
            type2 = in.readByte(); 
            switch(type2)
            {
            case 0 : 
              equation2 = new EquationNulle(in.readFloat(), in.readFloat(), in.readFloat()); 
              break; 

            case 1 : 
              equation2 = new EquationLineaire(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt()); 
              break; 

            case 2 : 
              equation2 = new EquationGravite(in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readFloat(), in.readInt()); 
              break; 

            default :  //Equation double dans equation double interdite
              throw new Exception("pas bon type equation1 " + type2); //on largue un erreur
            }

            personnages.get(index).equation = new EquationDouble(equation1, equation2); 
            break;
          }
        }
        break; 

      case 10 : //Influent supprimé
        influents.remove(in.readInt()); 
        break; 

      case 11 : //perso effectuant animation
        {
          int index = in.readInt(); 
          personnages.get(index).nbAnimation = in.readByte(); 
          personnages.get(index).tempsDebutAnim = in.readInt();
        }
        break; 

      case 12 : //Assigne un index de personnage au client
        indexPersonnage = in.readInt();
        personnages.get(indexPersonnage).lieAuClient = false;
        break; 

      case 13 : //changement du bouclier du perso
        personnages.get(in.readInt()).bouclier = in.readBoolean(); 
        break; 

      case 14 : //changement score perso
        personnages.get(in.readInt()).score = in.readInt(); 
        break; 

      case 15 : //changement score de frappe
        personnages.get(in.readInt()).scoreFrappe = in.readFloat(); 
        break; 

      case 16 : //Changement rotation (nt pour ceux qui sont différents du perso assigné)
        int index = in.readInt(); 
        personnages.get(index).angleX = in.readFloat(); 
        personnages.get(index).angleY = in.readFloat();
      }
    }
  }
  catch (Exception e)
  {
    e.printStackTrace();
  }
}

void mouseWheel(MouseEvent event) //si la molette bouge
{
  switch (etape)
  {
  case CONNEXION :  // dans l'écran de connexion, permet de choisir son perso : incrémente ou décrémente type
    try
    {
      if (event.getAmount() > 0)
      {
        if (info.type > 0) //limite pour pas dépasser
          info.type--; 

        out.writeByte(101); 
        out.writeInt(info.type); //On prévient le serveur
      } else if (event.getAmount() < 0)
      {
        if (info.type < 2) //limite
          info.type++; 

        out.writeByte(101); 
        out.writeInt(info.type); //On prévient le serveur
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    break; 

  case PARTIE : 
    break; 

  default : 
    break;
  }
}

void mousePressed() //En cas d'appui sur la souris on prévient le serveur pour chaque bouton appuyé
{
  if (etape == PARTIE)
  {
    try
    {
      switch (mouseButton)
      {
      case LEFT : 
        out.writeByte(103); 
        out.writeByte(5); 
        out.writeBoolean(true); 
        break; 

      case CENTER : 
        out.writeByte(103); 
        out.writeByte(7); 
        out.writeBoolean(true); 
        break; 

      case RIGHT : 
        out.writeByte(103); 
        out.writeByte(6); 
        out.writeBoolean(true); 
        break;
      }
    }
    catch(Exception e)
    {
      println(e.toString());
    }
  }
}

void mouseReleased() //Idem pour lorsque l'on relache un bouton
{
  try
  {
    if (etape == PARTIE)
    {
      switch (mouseButton)
      {
      case LEFT : //At de base
        out.writeByte(103); 
        out.writeByte(5); 
        out.writeBoolean(false); 
        break; 

      case CENTER : //comp
        out.writeByte(103); 
        out.writeByte(7); 
        out.writeBoolean(false); 
        break; 

      case RIGHT : //boubou
        out.writeByte(103); 
        out.writeByte(6); 
        out.writeBoolean(false); 
        break;
      }
    }
  }
  catch(Exception e)
  {
    println(e.toString());
  }
}

void keyPressed() //Appui sur une touche du clavier
{
  switch (etape)
  {
  case CONNEXION : 
    /* Valider si appuie sur entrée*/
    if (key == ENTER)
    {
      try
      {
        out.writeByte(102);
      }
      catch(Exception e)
      {
        println(e.toString());
      }
    }
    break; 

  case PARTIE : 
    /* On renseigne pour les flèches du clavier*/
    try
    {
      switch (key)
      {
      case 32: //Barre d'espace = équivalent milieu de la souris pour les ordis portables
        out.writeByte(103); 
        out.writeByte(7); 
        out.writeBoolean(true); 
        break;

      case CODED:
        switch(keyCode)
        {
        case DOWN : 
          out.writeByte(103); 
          out.writeByte(1); 
          out.writeBoolean(true); 
          break; 

        case UP : 
          out.writeByte(103); 
          out.writeByte(2); 
          out.writeBoolean(true); 
          break; 

        case RIGHT : 
          out.writeByte(103); 
          out.writeByte(3); 
          out.writeBoolean(true); 
          break; 

        case LEFT : 
          out.writeByte(103); 
          out.writeByte(4); 
          out.writeBoolean(true); 
          break;
        }
        break;
      }
    }   
    catch(Exception e)
    {
      println(e.toString());
    }
    break;
  }
}

void keyReleased() //Quand une touche est relachée
{
  switch (etape)
  {
  case CONNEXION : 
    break; 

  case PARTIE : 
    /* On renseigne le serveur pour les flèches du clavier*/
    try
    {
      switch (key)
      {
      case 32: //Barre d'espace = équivalent milieu de la souris pour les ordis portables
        out.writeByte(103); 
        out.writeByte(7); 
        out.writeBoolean(false); 
        break;

      case CODED:
        switch(keyCode)
        {
        case DOWN : 
          out.writeByte(103); 
          out.writeByte(1); 
          out.writeBoolean(false); 
          break; 

        case UP : 
          out.writeByte(103); 
          out.writeByte(2); 
          out.writeBoolean(false); 
          break; 

        case RIGHT : 
          out.writeByte(103); 
          out.writeByte(3); 
          out.writeBoolean(false); 
          break; 

        case LEFT : 
          out.writeByte(103); 
          out.writeByte(4); 
          out.writeBoolean(false); 
          break;
        }
        break;
      }
    }   
    catch(Exception e)
    {
      println(e.toString());
    }
    break;
  }
}

class Info //Structure contenant les infos d'un perso : pseudo, type de perso et si a validé
{
  public String pseudo; 
  public int type; 
  public boolean aValide; 

  Info(String m_pseudo, int m_type, boolean m_aValide)
  {
    pseudo = m_pseudo; 
    type = m_type; 
    aValide = m_aValide;
  }
}

String nomPerso(int nb) //Renvoie un string dépendant du type de perso donnée en argument
{
  switch( nb)
  {
  case 0 : 
    return "Globulix"; 
  case 1 : 
    return "Cubeman"; 
  case 2:
    return "Plasmax";
  default : 
    return "Error";
  }
}
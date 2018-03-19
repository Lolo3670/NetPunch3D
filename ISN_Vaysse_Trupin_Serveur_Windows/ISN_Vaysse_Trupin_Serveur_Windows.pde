import java.net.*; //<>// //<>//
import java.io.*;

final int CONNEXION = 1;
final int PARTIE = 2;
final int STATISTIQUES = 3;

int etape;

final ArrayList<Socket> sockets = new ArrayList<Socket>();
final ArrayList<DataOutputStream> outs = new ArrayList<DataOutputStream>();
final ArrayList<DataInputStream> ins = new ArrayList<DataInputStream>();

final ArrayList<Thread> threads = new ArrayList<Thread>();

final ArrayList<Info> infos = new ArrayList<Info>();
final ArrayList<Controle> controles = new ArrayList<Controle>();

ArrayList<Influent> influents;
ArrayList<Personnage> personnages; 

int tempsDebutPartie = 0;

void setup()
{
  etape = CONNEXION;

  size(1280, 752, P3D); //Créer un serveur
  ServeurThread serveurThread = new ServeurThread();
  serveurThread.start();
  threads.add(serveurThread);

  influents = new ArrayList<Influent>();
  personnages = new ArrayList<Personnage>();
}

int tempsRendu;

void draw()
{
  switch (etape)
  {
  case CONNEXION:
    scale(width / 1280, height / 752);

    background(0);

    textSize(12);
        textSize(12);
    text("     Serveur", width/2, height/2); 
    text("Appuyez sur entrée pour lancer la partie !", 900, 525);

    ellipse(1220+10*cos(millis()/250.0f), 720+10*sin(millis()/250.0f), 5, 5);
    ellipse(1220+10*cos(PI+millis()/250.0f), 720+10*sin(PI+millis()/250.0f), 5, 5);

    synchronized (infos)
    {
      for (int i = 0; i < infos.size(); i++)
      {
        if (infos.get(i).aValide)
          fill(255);
        else
          fill(100);
        rect(0, 0, 320, 188);
        fill(0);
        text(infos.get(i).pseudo, 20, 33);
        rect(10, 50, 128, 128);
        text(nomPerso(infos.get(i).type), 158, 102);

        translate(0, 188);
        if ((i % 4) == 3)
          translate(320, -752);
      }
    }
    break;

  case PARTIE:
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    perspective(PI/3, float(width)/float(height), 0.1f, 10000.0f);
    background(#B0C1C1);
    camera(15, 10, 0, 0, 0, 0, 0, -1, 0); 

    tempsRendu = millis() - tempsDebutPartie;
    for (int i = 0; i < personnages.size(); i++)
    {
      personnages.get(i).Rendu(tempsRendu);
    }
    for (int i = 0; i < influents.size(); i++)
    {
      influents.get(i).Rendu(tempsRendu);
    }

    hint(DISABLE_DEPTH_TEST);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(1);
    for (int i = 0; i < personnages.size(); i++)
    {
      pushMatrix();
      Vecteur position = personnages.get(i).equation.calculPosition(tempsRendu);
      translate(position.x, position.y + 2, position.z);
      rotateY(-HALF_PI);
      rotateX(PI);
      text(infos.get(i).pseudo, 0, 0);
      popMatrix();
    }
    hint(ENABLE_DEPTH_TEST);
    break;

  default:
    exit();
    break;
  }
}

void gameLogic()
{
  int tempsLogic, tempsLogicLast = tempsDebutPartie;
  Personnage perso;  
  while (etape == PARTIE)
  {
    tempsLogic = millis() - tempsDebutPartie;
    if (tempsLogic > 30000) //Plus de 3 minutes de partie
      etape = STATISTIQUES;

    for (int i = 0; i < personnages.size(); i++) //Fait effectuer les action selon les touches appuyées aux personnages
    {
      Controle controle = controles.get(i);
      personnages.get(i).action(controle.up, controle.down, controle.left, controle.right, controle.A, controle.E, controle.R, tempsLogicLast);
    }
    for (int i = 0; i < personnages.size(); i++) //on calcule les collisions pour avoir la position des persos
    {
      perso = personnages.get(i);
      perso.actualiserPosition(influents, personnages, tempsLogicLast, tempsLogic);
      if (perso.equationToSend) //Si l'équation a changé, on prévient
      {
        synchronized(sockets)
        {
          for (int j = 0; j < outs.size(); j++) // On prévient les autres
          {
            try
            {
              outs.get(j).writeByte(9);
              outs.get(j).writeInt(i);
              perso.equation.toNet(outs.get(j));
            }
            catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
            {
              println("Erreur pour l'nevoie des équations : " + e2.toString());
            }
          }
        }
        perso.equationToSend = false;
      }

      if (perso.animationChanged) //on notifie si l'animation a changé
      {
        synchronized(sockets)
        {
          for (int j = 0; j < outs.size(); j++) // On prévient les autres
          {
            try
            {
              outs.get(j).writeByte(11);
              outs.get(j).writeInt(i);
              outs.get(j).writeByte(perso.nbAnimation);
              outs.get(j).writeInt(perso.tempsDebutAnim);
            }
            catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
            {
              println("Erreur pour l'nevoie des animations : " + e2.toString());
            }
          }
        }
        perso.animationChanged = false;
      }
    }

    int i = 0;
    while (i < influents.size ()) //supprime les influents marqués comme devant l'etre
    {
      if (influents.get(i).toRemove)
      {
        synchronized(sockets)
        {
          for (int j = 0; j < outs.size(); j++) // On prévient les autres
          {
            try
            {
              outs.get(j).writeByte(10);
              outs.get(j).writeInt(i);
            }
            catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
            {
              println("Erreur pour la suppression d'influent : " + e2.toString());
            }
          }
        }
        influents.remove(i);
      } else
        i++;
    }
    tempsLogicLast = tempsLogic;

    delay(10);
  }

  synchronized(sockets)
  {
    for (int i = 0; i < outs.size(); i++) // On prévient les autres de la fin de la partie
    {
      try
      {
        outs.get(i).writeByte(7);
      }
      catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
      {
        println("Erreur pour le passage à la partie : " + e2.toString());
      }
    }
  }
}

void keyPressed()
{
  switch (etape)
  {
  case CONNEXION:
    if (key == ENTER) //Le serveur valide
    {
      etape = PARTIE;
      synchronized(sockets)
      {
        tempsDebutPartie = millis() + 1000;
        for (int i = 0; i < outs.size(); i++) // On prévient les autres
        {
          try
          {
            outs.get(i).writeByte(6);
          }
          catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
          {
            println("Erreur pour le passage à la partie : " + e2.toString());
          }
        }
        thread("gameLogic");
      }

      //Tcréer les personnages, les Terrains
      synchronized(sockets)
      {
        int temps = millis() - tempsDebutPartie;
        for (int j = 0; j < outs.size(); j++) // On prévient les autres
        {
          try
          {
            /*Envoie du terrain*/
            outs.get(j).writeByte(8);
            outs.get(j).writeInt(100);
            outs.get(j).writeFloat(0);
            outs.get(j).writeFloat(0);
            outs.get(j).writeFloat(0);

            synchronized (infos)
            {
              for (int i = 0; i < infos.size(); i++) //renseigne de la liste de tous les persos
              {
                outs.get(j).writeByte(8);
                outs.get(j).writeInt(infos.get(i).type);
                outs.get(j).writeFloat(i);
                outs.get(j).writeFloat(7);
                outs.get(j).writeFloat(0);
                outs.get(j).writeFloat(0);
                outs.get(j).writeFloat(0);
                outs.get(j).writeFloat(0);
                outs.get(j).writeInt(temps);
              }
            }

            outs.get(j).writeByte(12); //Assigne un perso au client
            outs.get(j).writeInt(j);
            
            switch (infos.get(j).type) //crée le perso pour le serveur
            {
            case 0:
              personnages.add(new Globulix(j, 7, 0, 0, 0, 0, temps));
              break;

            default:
              personnages.add(new Cubeman(j, 7, 0, 0, 0, 0, temps));
              break;
            }
          }
          catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
          {
            println(e2.toString());
          }
        }

        influents.add(new Terrain(0, 0, 0));
      }
    }
    break;

  case PARTIE:
    break;

  default:
    break;
  }
}

class Info
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

class Controle //retient les touches appuyées par un perso
{
  boolean up = false, down = false, left = false, right = false;
  boolean A = false, E = false, R = false;
}

class ServeurThread extends Thread
{
  ServeurThread()
  {
    super();
  }

  void run()
  {
    try
    {
      ServerSocket server = new ServerSocket(8000);
      while (etape == CONNEXION) //Après on accepte plus les connexions...
      {
        Socket socket = server.accept(); //chaque fois qu'un client se co
        if (socket != null)
        {
          DataOutputStream out = new DataOutputStream(socket.getOutputStream());
          DataInputStream in = new DataInputStream(socket.getInputStream());

          Info info = new Info(in.readUTF(), in.readInt(), false); // Reception des infos
          synchronized (infos)
          {
            out.writeInt(infos.size()); // Envoi du nombre de joueurs deja co + leurs infos
            for (int i = 0; i < infos.size(); i++)
            {
              out.writeUTF(infos.get(i).pseudo);
              out.writeInt(infos.get(i).type);
              out.writeBoolean(infos.get(i).aValide);
            }

            synchronized (sockets)
            {
              sockets.add(socket);
              outs.add(out);
              ins.add(in);

              for (int i = 0; i < outs.size(); i++) // Envoie des infos DU joueur a tout le monde y compris a lui
              {
                try
                {
                  outs.get(i).writeByte(4);
                  outs.get(i).writeUTF(info.pseudo);
                  outs.get(i).writeInt(info.type);
                }
                catch (Exception e) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
                {
                  println("Erreur serveur pour le code 4 : " + e.toString());
                }
              }
            }

            infos.add(info);
            controles.add(new Controle());
          }

          ReceptionThread receptionThread = new ReceptionThread(in);
          receptionThread.start();
          threads.add(receptionThread);
        }
      }
      server.close();
    }
    catch (Exception e)
    {
      println("Erreur serveur : " + e.toString());
    }
  }
}


class ReceptionThread extends Thread //s'occupe de recevoir lesinfos de la part d'UN client (un recpeitonThread par client)
{
  public DataInputStream in;

  ReceptionThread(DataInputStream m_in)
  {
    in = m_in;
  }

  void run()
  {
    int code;
    while (etape != STATISTIQUES) //sinon on arrete le client
    {
      try
      {
        code = in.readByte();

        switch(etape)
        {
        case CONNEXION:
          switch(code)
          {
          case 101: //Changement de type
            synchronized (sockets)
            {
              int index = ins.indexOf(in); //on récupère son indice
              synchronized(infos)
              {
                infos.get(index).type = in.readInt();
                for (int i = 0; i < outs.size(); i++) // On prévient les autres
                {
                  try
                  {
                    outs.get(i).writeByte(2);
                    outs.get(i).writeInt(index);
                    outs.get(i).writeInt(infos.get(index).type);
                  }
                  catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
                  {
                    println("Erreur pour le code 101 : " + e2.toString());
                  }
                }
              }
            }
            break;

          case 102: //Je valide
            synchronized (sockets)
            {
              int index = ins.indexOf(in);
              synchronized(infos)
              {
                for (int i = 0; i < outs.size(); i++) // On prévient les autres
                {
                  try
                  {
                    outs.get(i).writeByte(5);
                    outs.get(i).writeInt(index);
                  }
                  catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
                  {
                    println("Erreur pour le code 102 : " + e2.toString());
                  }
                }

                infos.get(index).aValide = true;
              }
            }
            break;

          default:
            throw new Exception("Mauvais code : " + code);
          }
          break;

        case PARTIE:
          int index = ins.indexOf(in);
          switch(code)
          {
          case 103:  //Les controles du perso
            {
              byte type = in.readByte();
              switch(type)
              {
              case 1:
                controles.get(index).down = in.readBoolean();
                break;

              case 2:
                controles.get(index).up = in.readBoolean();
                break;

              case 3:
                controles.get(index).right = in.readBoolean();
                break;

              case 4:
                controles.get(index).left = in.readBoolean();
                break;

              case 5: //Attaque de base
                controles.get(index).A = in.readBoolean();
                break;

              case 6: //Competence
                controles.get(index).R = in.readBoolean();
                break;

              case 7: //Bouclier
                controles.get(index).E = in.readBoolean();
                break;
              }
            }
            break;
          case 105: //les rotations
            personnages.get(index).angleX = in.readFloat();
            personnages.get(index).angleY = in.readFloat();

            synchronized (sockets)
            {
              for (int j = 0; j < outs.size(); j++) // On prévient les autres
              {
                try
                {
                  outs.get(j).writeByte(16);
                  outs.get(j).writeInt(index);
                  outs.get(j).writeFloat(personnages.get(index).angleX);
                  outs.get(j).writeFloat(personnages.get(index).angleY);
                }
                catch (Exception e)
                {
                  println(e);
                }
              }
            }
            break;
          }
          break;
        }
        delay(10);
      }
      catch (Exception e) //Exception == déconnexion
      {
        print(e);
        synchronized (sockets)
        {
          int index = ins.indexOf(in);
          ins.remove(index);
          outs.remove(index);
          sockets.remove(index);
          personnages.remove(index);

          synchronized(infos)
          {
            for (int i = 0; i < outs.size(); i++) // On prévient les autres
            {
              try
              {
                outs.get(i).writeByte(3);
                outs.get(i).writeInt(index);
              }
              catch (Exception e2) //Erreur pas trop grave : le client s'est déco (géré par le receptionThread)
              {
                println("Erreur pour le code 3 : " + e2.toString());
              }
            }

            infos.remove(index);
            controles.remove(index);
          }
        }

        return;
      }
    }
  }
}

String nomPerso(int nb)
{
  switch( nb)
  {
  case 0: 
    return "Globulix";
  case 1: 
    return "Cubeman";
  default : 
    return "Error";
  }
}
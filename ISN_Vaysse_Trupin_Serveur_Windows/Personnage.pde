abstract class Personnage extends Acteur //<>// //<>// //<>//
{
  Personnage(Equation m_equation, float rotationX, float rotationY, float rotationZ)
  {
    super(m_equation, rotationX, rotationY, rotationZ);
    zoneMarche = null;
    lastA = false;
    lastR = false;
    bouclier = false;
  }
  
  protected boolean lieAuClient = true;

  protected float masse; //en kilo
  protected float rapidite; //en m/s
  protected float hauteurSaut; // en m/s

  protected Vecteur AABB_negatif;
  protected Vecteur AABB_positif;

  protected float scoreFrappe = 1;
  protected int score = 0;
  protected Personnage tueur = null;

  protected ZoneMarche zoneMarche;

  protected boolean bouclier = false;

  protected float angleY = 0, angleX = 0;

  public final Vecteur getAABB_negatif() { 
    return AABB_negatif;
  }
  public final Vecteur getAABB_positif() { 
    return AABB_positif;
  }

  public void actualiserPosition(ArrayList<Influent> influents, ArrayList<Personnage> personnages, int tempsDebut, int tempsFin)
  {
    int indexMeilleur = -1;
    int temps = 0, tempsMeilleur = -1;

    for (int i = 0; i < influents.size(); i++)
    {
      temps = influents.get(i).collisionAvecPersonnage(this, tempsDebut, tempsFin);
      if (temps != -1) //Si j'ai un temps (sinon pas de modif =)
      {
        indexMeilleur = ((temps < tempsMeilleur) || (tempsMeilleur == -1)) ? i : indexMeilleur;
        tempsMeilleur = ((temps < tempsMeilleur) || (tempsMeilleur == -1)) ? temps : tempsMeilleur;
      }
    }

    if (zoneMarche != null)
    {
      temps = zoneMarche.collisionAvecPersonnage(this, tempsDebut, tempsFin);
      if (((temps < tempsMeilleur) || (tempsMeilleur == -1)) && (temps != -1))
      {
        zoneMarche.nouvelleEquation(this, influents, personnages, tempsDebut, temps);
        actualiserPosition(influents, personnages, temps, tempsFin);
        tempsMeilleur = -1;
      }
    }

    if ((indexMeilleur != -1) && (tempsMeilleur <= tempsFin) && (tempsMeilleur != -1))
    {
      influents.get(indexMeilleur).nouvelleEquation(this, influents, personnages, tempsDebut, tempsMeilleur);
      actualiserPosition(influents, personnages, tempsMeilleur, tempsFin);
    }

    if (equation.calculPosition(tempsFin).y < -5)
    {
      setEquation(new EquationGravite(0, 0, 0, 0, 5, 0, tempsFin));
      zoneMarche = null;
      if (tueur != null)
        tueur.score++;
      score--;

      scoreFrappe = 1.0f;
      bouclier = false;

      synchronized (sockets)
      {
        for (int j = 0; j < outs.size(); j++)
        {
          try
          {
            outs.get(j).writeByte(14);
            outs.get(j).writeInt(personnages.indexOf(this));
            outs.get(j).writeInt(score);

            if (tueur != null)
            {
              outs.get(j).writeByte(14);
              outs.get(j).writeInt(personnages.indexOf(tueur));
              outs.get(j).writeInt(tueur.score);
            }

            outs.get(j).writeByte(15);
            outs.get(j).writeInt(personnages.indexOf(this));
            outs.get(j).writeFloat(1);

            outs.get(j).writeByte(13);
            outs.get(j).writeInt(personnages.indexOf(this));
            outs.get(j).writeBoolean(false);
          }
          catch (Exception e)
          {
            println(e);
          }
        }
      }
    }
  }

  public boolean equationToSend = false;

  public void setEquation(Equation m_equation)
  {
    equation = m_equation;
    equationToSend = true;
  }

  public boolean lastA = false, lastE = false, lastR = false;

  public void action(boolean avance, boolean recule, boolean gauche, boolean droite, boolean A, boolean E, boolean R, int temps) //Que fait le perso
  {
    if (zoneMarche != null)
    {
      Vecteur position = equation.calculPosition(temps).add(zoneMarche.equation.calculPosition(temps).mult(-1));
      Vecteur versOu = new Vecteur(cos(-angleY), 0, sin(-angleY));
      Vecteur vitesse = new Vecteur(0, 0, 0);
      if (avance)
        vitesse = versOu.mult(rapidite);
      if (recule)
        vitesse = versOu.add(versOu.mult(-rapidite));
      if (gauche)
        vitesse = new Vecteur(sin(-angleY), 0, cos(-angleY)).mult(rapidite);
      if (droite)
        vitesse = new Vecteur(-sin(-angleY), 0, -cos(-angleY)).mult(rapidite);
      equation = new EquationDouble(zoneMarche.equation, new EquationLineaire(vitesse.x, vitesse.y, vitesse.z, position.x, position.y, position.z, temps, avance));
      this.equationToSend = true;
    }


    if (E)
    {
      chargerBouclier(temps);
    } else if (lastE)
      attaqueBouclier(temps);

    if (R)
    {
      if (chargerCompetence(temps))
      {
        if (avance || recule)
          changeAnimation(byte(1), temps);
        else
          changeAnimation(byte(0), temps);
      }
    } else if (lastR)
      attaqueCompetence(temps);
    else if (A)
    {
      chargerAttaqueDeBase(temps);
      changeAnimation(byte(2), temps);
    } else if (lastA)
      attaqueAttaqueDeBase(temps);
    else if (avance || recule)
      changeAnimation(byte(1), temps);
    else
      changeAnimation(byte(0), temps);

    if (bouclier)
      rechargeBouclier = temps;

    lastA = A;
    lastR = R;
    lastE = E;
  }

  public void ejecter(float Vx, float Vy, float Vz, int temps, Personnage m_tueur, float m_scoreFrappe)
  {
    tueur = m_tueur;
    if (bouclier)
    {
      bouclier = false;
      synchronized (sockets)
      {
        for (int j = 0; j < outs.size(); j++)
        {
          try
          {
            outs.get(j).writeByte(13);
            outs.get(j).writeInt(personnages.indexOf(this));
            outs.get(j).writeBoolean(false);
          }
          catch (Exception e)
          {
            println(e);
          }
        }
      }
    } else
    {
      Vecteur newPosition = equation.calculPosition(temps); 
      Vecteur vitesseInitiale = equation.calculVitesse(temps);
      float coef = scoreFrappe / masse;
      this.equation = new EquationGravite(vitesseInitiale.x + (Vx * coef), vitesseInitiale.y + (Vy * coef), vitesseInitiale.z + (Vz * coef), newPosition.x, newPosition.y, newPosition.z, temps);
      this.equationToSend = true;
      zoneMarche = null;

      scoreFrappe += m_scoreFrappe;
      synchronized (sockets)
      {
        for (int j = 0; j < outs.size(); j++)
        {
          try
          {
            outs.get(j).writeByte(15);
            outs.get(j).writeInt(personnages.indexOf(this));
            outs.get(j).writeFloat(scoreFrappe);
          }
          catch (Exception e)
          {
            println(e);
          }
        }
      }
    }
  }

  @Override
    public void Rendu(int temps)
  {
    pushMatrix();
    Vecteur position = equation.calculPosition(temps);
    translate(position.x, position.y, position.z);
    rotateX(orientation.x);
    rotateY(orientation.y + angleY);
    rotateZ(orientation.z);
    renduInterne(temps - tempsDebutAnim);
    popMatrix();
  }

  /*Competences*/
  protected int rechargeBouclier = -1;
  abstract public void chargerBouclier(int temps);
  abstract public void attaqueBouclier(int temps);

  protected int rechargeAttaqueDeBase = -1;
  abstract public void chargerAttaqueDeBase(int temps);
  abstract public void attaqueAttaqueDeBase(int temps);

  protected int rechargeCompetence = -1;
  abstract public boolean chargerCompetence(int temps);
  abstract public void attaqueCompetence(int temps);
}

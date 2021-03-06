abstract class Personnage extends Acteur //<>// //<>// //<>//
{
  Personnage(Equation m_equation, float rotationX, float rotationY, float rotationZ)
  {
    super(m_equation, rotationX, rotationY, rotationZ);
    zoneMarche = null;
    bouclier = false;
  }

  protected boolean lieAuClient = true;

  protected float masse; //en kilo
  protected float rapidite; //en m/s
  protected float hauteurSaut; // en m/s

  protected Vecteur AABB_negatif; //Bounding box pour les équations
  protected Vecteur AABB_positif;

  protected float scoreFrappe = 1;
  protected int score = 0;
  protected Personnage tueur = null;

  protected ZoneMarche zoneMarche; //zone surlaquelle est le joueur

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
      temps = influents.get(i).collisionAvecPersonnage(this, tempsDebut, tempsFin); //Test de collision avec tous les influents
      if (temps != -1) //Si j'ai un temps (sinon pas de modif =)
      {
        indexMeilleur = ((temps < tempsMeilleur) || (tempsMeilleur == -1)) ? i : indexMeilleur; //Si on a un meilleur temps on change l'index
        tempsMeilleur = ((temps < tempsMeilleur) || (tempsMeilleur == -1)) ? temps : tempsMeilleur; //Si on obtient un meilleur temps ou si il n'y a pas de meilleur temps.... on prend sinon on jette
      }
    }

    /*Test de la zone de marche => Si meilleur résultat on utilise son équation*/    //On cherche à savoir s'il sort de la zone de marche avant
    if (zoneMarche != null)
    {
      temps = zoneMarche.collisionAvecPersonnage(this, tempsDebut, tempsFin);
      if (((temps < tempsMeilleur) || (tempsMeilleur == -1)) && (temps != -1)) //S'il la quitte avant
      {
        zoneMarche.nouvelleEquation(this, influents, personnages, tempsDebut, temps);
        actualiserPosition(influents, personnages, temps, tempsFin); //On relance le calcul pour d'autres collisions
        tempsMeilleur = -1;
      }
    }

    if ((indexMeilleur != -1) && (tempsMeilleur <= tempsFin) && (tempsMeilleur != -1)) //Si je trouve une solution et qui rentre dans les rangs va falloir changer l'équation.
    {
      influents.get(indexMeilleur).nouvelleEquation(this, influents, personnages, tempsDebut, tempsMeilleur);
      actualiserPosition(influents, personnages, tempsMeilleur, tempsFin); //On relance le calcul pour d'autres collisions
    }

    if (equation.calculPosition(tempsFin).y < -5) //si le perso va trop bas il meurt
    {
      setEquation(new EquationGravite(0, 0, 0, 0, 5, 0, tempsFin)); //on le remet au début
      zoneMarche = null;
      if (tueur != null)
        tueur.score++;
      score--;

      scoreFrappe = 1;
      bouclier = false;
    }
  }

  public boolean equationToSend = false;

  public void setEquation(Equation m_equation) //change l'équation
  {
    equation = m_equation;
    equationToSend = true;
  }

  public void ejecter(float Vx, float Vy, float Vz, int temps, Personnage m_tueur, float m_scoreFrappe)
  {
    tueur = m_tueur;
    if (bouclier) //s'il  un bouclier je l'enlève
    {
      bouclier = false;
    } else  //sinon changellent de l'équation => Equation gravité
    {
      Vecteur newPosition = equation.calculPosition(temps); 
      Vecteur vitesseInitiale = equation.calculVitesse(temps).mult(scoreFrappe);
      this.equation = new EquationGravite(vitesseInitiale.x + Vx, vitesseInitiale.y + Vy, vitesseInitiale.z + Vz, newPosition.x, newPosition.y, newPosition.z, temps);
      this.equationToSend = true;
      zoneMarche = null;

      scoreFrappe += m_scoreFrappe;
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
}
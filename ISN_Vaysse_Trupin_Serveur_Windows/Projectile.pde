abstract class Projectile extends Influent
{
  Projectile(Equation equation)
  {
    super(equation, 0, 0, 0);
  }  

  @Override
    public void Rendu(int temps)
  {
    pushMatrix();
    Vecteur position = equation.calculPosition(temps);
    translate(position.x, position.y, position.z);
    orientation = equation.calculOrientation(temps);
    rotateX(orientation.x);
    rotateY(orientation.y);
    rotateZ(orientation.z);
    renduInterne(temps - tempsDebutAnim);
    popMatrix();
  }

  public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin)
  {
    if (!toRemove)
    {
      return perso.equation.collision(perso.getAABB_negatif(), perso.getAABB_positif(), new Vecteur(0, 0, 0), new Vecteur(0, 0, 0), equation, tempsDebut, tempsFin, false);
    }
    return -1;
  }

  public void nouvelleEquation(Personnage perso, ArrayList<Influent> influents, ArrayList<Personnage> personnages, int tempsDebut, int tempsFin)
  {
    if (!toRemove)
    {
      int tempsCalcul = 0, tempsMeilleur = -1, indexMeilleur = -1;
      for (int i = 0; i < personnages.size(); i++)
      {
        tempsCalcul = this.collisionAvecPersonnage(personnages.get(i), tempsDebut, tempsFin + 1);
        tempsMeilleur = ((tempsMeilleur == -1) || ((tempsCalcul != -1) && (tempsCalcul < tempsMeilleur))) ? tempsCalcul : tempsMeilleur;
        indexMeilleur = ((tempsMeilleur == -1) || ((tempsCalcul != -1) && (tempsCalcul < tempsMeilleur))) ? i : indexMeilleur;
      }

      if (tempsMeilleur == tempsFin)
      {
        effetSurPersonnage(perso, tempsFin);
        toRemove = true;
      } else
      {
        if (indexMeilleur != -1)
        {
          personnages.get(indexMeilleur).actualiserPosition(influents, personnages, tempsDebut, tempsMeilleur);
        }
      }
    }
  }

  abstract protected void effetSurPersonnage(Personnage perso, int temps);
}

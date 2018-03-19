class Terrain extends Influent //Terrain plat : pas de détection sur les côtés //<>// //<>//
{
  TerrainZoneMarche zoneMarche;
  
  Terrain(float x, float y, float z)
  {
    super(new EquationNulle(x, y, z), 0, 0, 0);
    zoneMarche = new TerrainZoneMarche(x, y, z);
  }

  protected void renduInterne(int temps)
  {
    stroke(0);
    rotateX(-PI/2);
    fill(100);
    stroke(0);
    rect(0, 0, 30, -30);
  }

  public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin)
  {
    /* 1er test la tête se cogne au plafond */
    int temps = perso.equation.collisionYPositif(perso.getAABB_negatif(), perso.getAABB_positif(), new Vecteur(-15, 0, -15), new Vecteur(15, 0, 15), equation, tempsDebut, tempsFin, false);
    if (temps != -1)
    {
      return temps;
    }
    /* 2e test les pieds touchent le sol */
    temps = perso.equation.collisionYNegatif(perso.getAABB_negatif(), perso.getAABB_positif(), new Vecteur(-15, 0, -15), new Vecteur(15, 0, 15), equation, tempsDebut, tempsFin, false);
    if (temps != -1)
    {
      return temps;
    }
    return -1;
  }

  public void nouvelleEquation(Personnage perso, ArrayList<Influent> influents, ArrayList<Personnage> personnages, int tempsDebut, int tempsFin)
  {
    Vecteur calcul = perso.equation.calculVitesse(tempsFin);
    if (calcul.y < 0)
    {
      Vecteur newPosition = perso.equation.calculPosition(tempsFin);
      perso.setEquation(new EquationNulle(newPosition.x, newPosition.y, newPosition.z));
      perso.zoneMarche = zoneMarche;
    } else
    {
      Vecteur newPosition = perso.equation.calculPosition(tempsFin);
      perso.setEquation(new EquationGravite(calcul.x, 0, calcul.z, newPosition.x, newPosition.y, newPosition.z, tempsFin));
    }
  }
}

class TerrainZoneMarche extends ZoneMarche
{
  TerrainZoneMarche(float x, float y, float z)
  {
    super(new EquationNulle(x, y, z));
  }

  public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin)
  {
    return perso.equation.collision(perso.getAABB_negatif(), perso.getAABB_positif(), new Vecteur(-15, -1000, -15), new Vecteur(15, 1000, 15), equation, tempsDebut, tempsFin, true); //<>// //<>//
  }

  public void nouvelleEquation(Personnage perso, ArrayList<Influent> influents, ArrayList<Personnage> personnages, int tempsDebut, int tempsFin)
  {
    Vecteur vitesseInitiale = perso.equation.calculVitesse(tempsFin);
    Vecteur position = perso.equation.calculPosition(tempsFin);
    perso.zoneMarche = null;
    perso.setEquation(new EquationGravite(vitesseInitiale.x, vitesseInitiale.y, vitesseInitiale.z, position.x, position.y, position.z, tempsFin));
  }
}
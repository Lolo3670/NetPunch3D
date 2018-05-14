abstract class Influent extends Acteur //Ce qui peut changer l'équation du perso => Projectile ou terrain
{
  Influent(Equation equation, float rotationX, float rotationY, float rotationZ)
  {
    super(equation, rotationX, rotationY, rotationZ);
    toRemove = false;
  }

  abstract public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin);
  
  abstract public void nouvelleEquation(Personnage perso, ArrayList<Influent> influents, ArrayList<Personnage> personnages, int tempsDebut, int tempsFin);

  boolean toRemove = false;
}

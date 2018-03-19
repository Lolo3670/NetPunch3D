class ProjectileTest extends Projectile //garder comme projectile invisble
{
  ProjectileTest(int tempsDebut) //temps relatif au début de la partie
  {
    super(new EquationGravite(0, 7, 10, 0, 0, 0, tempsDebut));
  }

  protected void renduInterne(int temps)
  {
  }
  
  protected void effetSurPersonnage(Personnage perso, int temps)
  {
    perso.ejecter(0, 30f, 0f, temps, null, 0);
    perso.setAnimation(byte(1), temps);
  }
}
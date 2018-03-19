abstract class Acteur //Ce qui peut être affiché
{
  Acteur(Equation m_equation, float rotationX, float rotationY, float rotationZ)
  {
    tempsDebutAnim = 0;
    nbAnimation = 0;
    orientation = new Vecteur(rotationX, rotationY, rotationZ);
    equation = m_equation;
  }

  protected int tempsDebutAnim; //temps au moment du début de l'animation
  protected byte nbAnimation; //Type d'aniamtion
  public boolean animationChanged = false; //Si l'animation a changé ou non

  public void setAnimation(byte nbAnim, int temps) //Change forcement l'anim
  {
    tempsDebutAnim = temps;
    nbAnimation = nbAnim;
    animationChanged = true;
  }

  public void changeAnimation(byte nbAnim, int temps) //Vérifie si l'animation n'est pas déjà en cours et change dans ce cas
  {
    if (nbAnimation != nbAnim)
      setAnimation(nbAnim, temps);
  }

  protected Vecteur orientation; //Orientation de l'objet (rotation)

  protected Equation equation; //equation qui indique la position du personnage (renvoie la posiiton quand on lui donne un temps)

  public void Rendu(int temps) //affichage de l'acteur
  {
    pushMatrix(); //ajout d'une matrice
    Vecteur position = equation.calculPosition(temps); //calcul de sa position
    translate(position.x, position.y, position.z);
    rotateX(orientation.x);
    rotateY(orientation.y);
    rotateZ(orientation.z);
    renduInterne(temps - tempsDebutAnim); //Le rendu interne correspond à l'affichage de l'objet en lui, il ne ce soucis pas d'où c'est déjà fait
    popMatrix(); //Enlève la matrice
  }

  protected abstract void renduInterne(int temps); //Temps depuis le début de l'anim : méthode abstraite seulement dispo dans les calsses qui héritent de Acteur
}
abstract class Acteur
{
  Acteur(Equation m_equation, float rotationX, float rotationY, float rotationZ)
  {
    tempsDebutAnim = 0;
    nbAnimation = 0;
    orientation = new Vecteur(rotationX, rotationY, rotationZ);
    equation = m_equation;
  }

  protected int tempsDebutAnim;
  protected byte nbAnimation;
  public boolean animationChanged = false;

  public void setAnimation(byte nbAnim, int temps)
  {
    tempsDebutAnim = temps;
    nbAnimation = nbAnim;
    animationChanged = true;
  }

  public void changeAnimation(byte nbAnim, int temps)
  {
    if (nbAnimation != nbAnim)
      setAnimation(nbAnim, temps);
  }

  protected Vecteur orientation;

  protected Equation equation;

  public void Rendu(int temps)
  {
    pushMatrix();
    Vecteur position = equation.calculPosition(temps);
    translate(position.x, position.y, position.z);
    rotateX(orientation.x);
    rotateY(orientation.y);
    rotateZ(orientation.z);
    renduInterne(temps - tempsDebutAnim);
    popMatrix();
  }

  protected abstract void renduInterne(int temps);
}

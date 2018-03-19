class EquationLineaire extends Equation
{
  public final Vecteur direction;
  public boolean avance;

  EquationLineaire(float dirX, float dirY, float dirZ, float x, float y, float z, int tempsDebut)
  {
    super(x, y, z, tempsDebut);
    direction = new Vecteur(dirX, dirY, dirZ);
    avance = true;
  }

  EquationLineaire(float dirX, float dirY, float dirZ, float x, float y, float z, int tempsDebut, boolean m_avance)
  {
    super(x, y, z, tempsDebut);
    direction = new Vecteur(dirX, dirY, dirZ);
    avance = m_avance;
  }

  protected Vecteur calculInterne(float temps)
  {
    return direction.mult(temps);
  }

  protected Vecteur calculInterneOrientation(float temps)
  {
    return direction.axisToEulerAngles();
  }

  protected Vecteur calculInterneVitesse(float temps)
  {
    return new Vecteur(direction.x, direction.y, direction.z);
  }

  public void toNet(DataOutputStream out) throws Exception
  {
    out.writeByte(1);
    out.writeFloat(direction.x);
    out.writeFloat(direction.y);
    out.writeFloat(direction.z);
    out.writeFloat(origine.x);
    out.writeFloat(origine.y);
    out.writeFloat(origine.z);
    out.writeInt(m_tempsDebut);
  }
}
class EquationGravite extends Equation
{
  public final Vecteur vitesse;

  EquationGravite(float Vx, float Vy, float Vz, float x, float y, float z, int tempsDebut)
  {
    super(x, y, z, tempsDebut);
    vitesse = new Vecteur(Vx, Vy, Vz);
  }

  protected Vecteur calculInterne(float temps)
  {
    return new Vecteur(0, DEMIG*temps*temps, 0).add(vitesse.mult(temps)); //-0.5gt^2 + v*t
  }

  protected Vecteur calculInterneOrientation(float temps)
  {
    return new Vecteur(0, DEMIG * temps, 0).add(vitesse).axisToEulerAngles();
  }

  protected Vecteur calculInterneVitesse(float temps)
  {
    return new Vecteur(0, -G * temps, 0).add(vitesse);
  }

  public void toNet(DataOutputStream out) throws Exception
  {
    out.writeByte(2);
    out.writeFloat(vitesse.x);
    out.writeFloat(vitesse.y);
    out.writeFloat(vitesse.z);
    out.writeFloat(origine.x);
    out.writeFloat(origine.y);
    out.writeFloat(origine.z);
    out.writeInt(m_tempsDebut);
  }
}
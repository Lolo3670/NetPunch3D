class EquationNulle extends Equation
{
  EquationNulle(float x, float y, float z)
  {
    super(x, y, z, 0);
  }

  protected Vecteur calculInterne(float temps)
  {
    return new Vecteur(0, 0, 0);
  }


  public Vecteur calculInterneOrientation(float temps)
  {
    return new Vecteur(0, 0, 0);
  }

  public Vecteur calculInterneVitesse(float temps)
  {
    return new Vecteur(0, 0, 0);
  }

  public void toNet(DataOutputStream out) throws Exception
  {
    out.writeByte(0);
    out.writeFloat(origine.x);
    out.writeFloat(origine.y);
    out.writeFloat(origine.z);
  }
}
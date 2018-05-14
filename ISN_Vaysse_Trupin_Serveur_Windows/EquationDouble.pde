class EquationDouble extends Equation
{
  protected Equation equation1, equation2;

  EquationDouble()
  {
    super(0, 0, 0, 0);
  }

  EquationDouble(Equation m_equation1, Equation m_equation2)
  {
    super(0, 0, 0, 0);
    equation1 = m_equation1;
    equation2 = m_equation2;
  }

  @Override
    public Vecteur calculPosition(float temps)
  {
    return equation1.calculPosition(temps).add(equation2.calculPosition(temps));
  }

  protected Vecteur calculInterne(float temps)
  {
    return new Vecteur(-1, -1, -1);
  }

  @Override
    public Vecteur calculOrientation(float temps)
  {
    return equation1.calculVitesse(temps).add(equation2.calculVitesse(temps)).axisToEulerAngles(); //Vitesse sous forme d'angle d'Euler
  }

  protected Vecteur calculInterneOrientation(float temps)
  {
    return new Vecteur(-1, -1, -1);
  }

  @Override  
    public Vecteur calculVitesse(float temps)
  {
    return equation1.calculVitesse(temps).add(equation2.calculVitesse(temps));
  }

  protected Vecteur calculInterneVitesse(float temps)
  {
    return new Vecteur(-1, -1, -1);
  }

  public void toNet(DataOutputStream out) throws Exception
  {
    out.writeByte(4);
    equation1.toNet(out);
    equation2.toNet(out);
  }
}

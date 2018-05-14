abstract class ZoneMarche  
{
  public final Equation equation;
  
  ZoneMarche(Equation m_equation)
  {
    equation = m_equation;
  }
  
  abstract public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin);
  //Quand est-ce que le personnage sort de la zone 
  
  abstract public void nouvelleEquation(Personnage perso, ArrayList<Influent> influents, ArrayList<Personnage> personnages, int tempsDebut, int tempsFin);
}

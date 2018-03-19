abstract class ZoneMarche //possède les mêmes méthodes qu'un influent mais n'en est pas un volontairement //Permet de faire bouger un peros avec le terrain sur lequel il est 
{
  public final Equation equation;
  
  ZoneMarche(Equation m_equation)
  {
    equation = m_equation;
  }
  
  abstract public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin); //Quand est-ce que le personnage sort de la zone ?
  
  abstract public void nouvelleEquation(Personnage perso, ArrayList<Influent> influents, ArrayList<Personnage> personnages, int tempsDebut, int tempsFin); //Que faire quand il sort ?
}
final float DEMIG = -4.903325f;
final float G = 9.80665f;

abstract class Equation
{
  public final int m_tempsDebut;
  public Vecteur origine;

  Equation(float x, float y, float z, int tempsDebut)
  {
    m_tempsDebut = tempsDebut;
    origine = new Vecteur(x, y, z);
  }

  public Vecteur calculPosition(float temps)
  {
    return calculInterne((temps - m_tempsDebut) / 1000.0f).add(origine);
  }

  public Vecteur calculOrientation(float temps)
  {
    return calculInterneOrientation((temps - m_tempsDebut) / 1000.0f);
  }

  public Vecteur calculVitesse(float temps)
  {
    return calculInterneVitesse((temps - m_tempsDebut) / 1000.0f);
  }

  abstract protected Vecteur calculInterne(float temps);
  abstract protected Vecteur calculInterneOrientation(float temps);
  abstract protected Vecteur calculInterneVitesse(float temps);
  
  public int collisionXPositif(final Vecteur AABB1_negatif, final Vecteur AABB1_positif, final Vecteur AABB2_negatif, final Vecteur AABB2_positif, final Equation equationPlan, final int debutCalcul, final int finCalcul, final boolean interieur)
  {
    float a = debutCalcul - 1, b = finCalcul + 1;

    if (((calculPosition(debutCalcul).x + AABB1_positif.x - equationPlan.calculPosition(debutCalcul).x - AABB2_negatif.x) * (calculPosition(finCalcul).x + AABB1_positif.x - equationPlan.calculPosition(finCalcul).x - AABB2_negatif.x)) > 0) 
    {
      return -1;
    }

    float m;
    while ( (b - a) > 0.1)
    {
      m = (a + b) /2;
      if (((calculPosition(a).x + AABB1_positif.x - equationPlan.calculPosition(a).x - AABB2_negatif.x) * (calculPosition(m).x + AABB1_positif.x - equationPlan.calculPosition(m).x - AABB2_negatif.x)) <= 0)
      {
        b = m;
      } else
      {
        a = m;
      }
    }    
    int result = int(a);
    Vecteur newPosition = calculPosition(result);
    Vecteur newLimits = equationPlan.calculPosition(result);
    if ((!(((newPosition.y + AABB1_negatif.y) > (newLimits.y + AABB2_positif.y)) || ((newPosition.y + AABB1_positif.y) < (newLimits.y + AABB2_negatif.y)) || ((newPosition.z + AABB1_negatif.z) > (newLimits.z + AABB2_positif.z)) || ((newPosition.z + AABB1_positif.z) < (newLimits.z + AABB2_negatif.z)))) && !interieur)
      return result;
    if (interieur)
      return result;
    return -1;
  }

  public int collisionXNegatif(final Vecteur AABB1_negatif, final Vecteur AABB1_positif, final Vecteur AABB2_negatif, final Vecteur AABB2_positif, final Equation equationPlan, final int debutCalcul, final int finCalcul, final boolean interieur)
  {
    float a = debutCalcul - 1, b = finCalcul + 1;

    if (((calculPosition(debutCalcul).x + AABB1_negatif.x - equationPlan.calculPosition(debutCalcul).x - AABB2_positif.x) * (calculPosition(finCalcul).x + AABB1_negatif.x - equationPlan.calculPosition(finCalcul).x - AABB2_positif.x)) > 0) 
    {
      return -1;
    }

    float m;
    while ( (b - a) > 0.1)
    {
      m = (a + b) /2;
      if (((calculPosition(a).x + AABB1_negatif.x - equationPlan.calculPosition(a).x - AABB2_positif.x) * (calculPosition(m).x + AABB1_negatif.x - equationPlan.calculPosition(m).x - AABB2_positif.x)) <= 0)
      {
        b = m;
      } else
      {
        a = m;
      }
    }
    int result = int(a);
    Vecteur newPosition = calculPosition(result);
    Vecteur newLimits = equationPlan.calculPosition(result);
    if ((!(((newPosition.y + AABB1_negatif.y) > (newLimits.y + AABB2_positif.y)) || ((newPosition.y + AABB1_positif.y) < (newLimits.y + AABB2_negatif.y)) || ((newPosition.z + AABB1_negatif.z) > (newLimits.z + AABB2_positif.z)) || ((newPosition.z + AABB1_positif.z) < (newLimits.z + AABB2_negatif.z)))) && !interieur)
      return result;
    if (interieur)
      return result;
    return -1;
  }

  public int collisionYPositif(final Vecteur AABB1_negatif, final Vecteur AABB1_positif, final Vecteur AABB2_negatif, final Vecteur AABB2_positif, final Equation equationPlan, final int debutCalcul, final int finCalcul, final boolean interieur)
  {
    float a = debutCalcul - 1, b = finCalcul + 1;

    if (((calculPosition(debutCalcul).y + AABB1_positif.y - equationPlan.calculPosition(debutCalcul).y - AABB2_negatif.y) * (calculPosition(finCalcul).y + AABB1_positif.y - equationPlan.calculPosition(finCalcul).y - AABB2_negatif.y)) > 0) 
    {
      return -1;
    }

    float m;
    while ( (b - a) > 0.1)
    {
      m = (a + b) /2;
      if (((calculPosition(a).y + AABB1_positif.y - equationPlan.calculPosition(a).y - AABB2_negatif.y) * (calculPosition(m).y + AABB1_positif.y - equationPlan.calculPosition(m).y - AABB2_negatif.y)) <= 0)
      {
        b = m;
      } else
      {
        a = m;
      }
    }
    int result = int(a);
    Vecteur newPosition = calculPosition(result);
    Vecteur newLimits = equationPlan.calculPosition(result);
    if ((!(((newPosition.x + AABB1_negatif.x) > (newLimits.x + AABB2_positif.x)) || ((newPosition.x + AABB1_positif.x) < (newLimits.x + AABB2_negatif.x)) || ((newPosition.z + AABB1_negatif.z) > (newLimits.z + AABB2_positif.z)) || ((newPosition.z + AABB1_positif.z) < (newLimits.z + AABB2_negatif.z)))) && !interieur)
      return result;
    if (interieur)
      return result;
    return -1;
  }

  public int collisionYNegatif(final Vecteur AABB1_negatif, final Vecteur AABB1_positif, final Vecteur AABB2_negatif, final Vecteur AABB2_positif, final Equation equationPlan, final int debutCalcul, final int finCalcul, final boolean interieur)
  {
    float a = debutCalcul - 1, b = finCalcul + 1;

    if (((calculPosition(debutCalcul).y + AABB1_negatif.y - equationPlan.calculPosition(debutCalcul).y - AABB2_positif.y) * (calculPosition(finCalcul).y + AABB1_negatif.y - equationPlan.calculPosition(finCalcul).y - AABB2_positif.y)) > 0) 
    {
      return -1;
    }

    float m;
    while ( (b - a) > 0.1)
    {
      m = (a + b) /2;
      if (((calculPosition(a).y + AABB1_negatif.y - equationPlan.calculPosition(a).y - AABB2_positif.y) * (calculPosition(m).y + AABB1_negatif.y - equationPlan.calculPosition(m).y - AABB2_positif.y)) <= 0)
      {
        b = m;
      } else
      {
        a = m;
      }
    }
    int result = int(a);
    Vecteur newPosition = calculPosition(result);
    Vecteur newLimits = equationPlan.calculPosition(result);
    if ((!(((newPosition.x + AABB1_negatif.x) > (newLimits.x + AABB2_positif.x)) || ((newPosition.x + AABB1_positif.x) < (newLimits.x + AABB2_negatif.x)) || ((newPosition.z + AABB1_negatif.z) > (newLimits.z + AABB2_positif.z)) || ((newPosition.z + AABB1_positif.z) < (newLimits.z + AABB2_negatif.z)))) && !interieur)
      return result;
    if (interieur)
      return result;
    return -1;
  }

  public int collisionZPositif(final Vecteur AABB1_negatif, final Vecteur AABB1_positif, final Vecteur AABB2_negatif, final Vecteur AABB2_positif, final Equation equationPlan, final int debutCalcul, final int finCalcul, final boolean interieur)
  {
    float a = debutCalcul - 1, b = finCalcul + 1;

    if (((calculPosition(debutCalcul).z + AABB1_positif.z - equationPlan.calculPosition(debutCalcul).z - AABB2_negatif.z) * (calculPosition(finCalcul).z + AABB1_positif.z - equationPlan.calculPosition(finCalcul).z - AABB2_negatif.z)) > 0) 
    {
      return -1;
    }

    float m;
    while ( (b - a) > 0.1)
    {
      m = (a + b) /2;
      if (((calculPosition(a).z + AABB1_positif.z - equationPlan.calculPosition(a).z - AABB2_negatif.z) * (calculPosition(m).z + AABB1_positif.z - equationPlan.calculPosition(m).z - AABB2_negatif.z)) <= 0)
      {
        b = m;
      } else
      {
        a = m;
      }
    }
    int result = int(a);
    Vecteur newPosition = calculPosition(result);
    Vecteur newLimits = equationPlan.calculPosition(result);
    if ((!(((newPosition.x + AABB1_negatif.x) > (newLimits.x + AABB2_positif.x)) || ((newPosition.x + AABB1_positif.x) < (newLimits.x + AABB2_negatif.x)) || ((newPosition.y + AABB1_negatif.y) > (newLimits.y + AABB2_positif.y)) || ((newPosition.y + AABB1_positif.y) < (newLimits.y + AABB2_negatif.y)))) && !interieur)
      return result;
    if (interieur)
      return result;
    return -1;
  }

  public int collisionZNegatif(final Vecteur AABB1_negatif, final Vecteur AABB1_positif, final Vecteur AABB2_negatif, final Vecteur AABB2_positif, final Equation equationPlan, final int debutCalcul, final int finCalcul, final boolean interieur)
  {
    float a = debutCalcul - 1, b = finCalcul + 1;

    if (((calculPosition(debutCalcul).z + AABB1_negatif.z - equationPlan.calculPosition(debutCalcul).z - AABB2_positif.z) * (calculPosition(finCalcul).z + AABB1_negatif.z - equationPlan.calculPosition(finCalcul).z - AABB2_positif.z)) > 0) 
    {
      return -1;
    }

    float m;
    while ( (b - a) > 0.1)
    {
      m = (a + b) /2;
      if (((calculPosition(a).z + AABB1_negatif.z - equationPlan.calculPosition(a).z - AABB2_positif.z) * (calculPosition(m).z + AABB1_negatif.z - equationPlan.calculPosition(m).z - AABB2_positif.z)) <= 0)
      {
        b = m;
      } else
      {
        a = m;
      }
    }
    int result = int(a);
    Vecteur newPosition = calculPosition(result);
    Vecteur newLimits = equationPlan.calculPosition(result);
    if ((!(((newPosition.x + AABB1_negatif.x) > (newLimits.x + AABB2_positif.x)) || ((newPosition.x + AABB1_positif.x) < (newLimits.x + AABB2_negatif.x)) || ((newPosition.y + AABB1_negatif.y) > (newLimits.y + AABB2_positif.y)) || ((newPosition.y + AABB1_positif.y) < (newLimits.y + AABB2_negatif.y)))) && !interieur)
      return result;
    if (interieur)
      return result;
    return -1;
  }

  public int collision(final Vecteur AABB1_negatif, final Vecteur AABB1_positif, final Vecteur AABB2_negatif, final Vecteur AABB2_positif, final Equation equationPlan, final int debutCalcul, final int finCalcul, final boolean interieur)
  {
    int temps;
    int tempsMeilleur = -1;

    temps = collisionXPositif(AABB1_negatif, AABB1_positif, AABB2_negatif, AABB2_positif, equationPlan, debutCalcul, finCalcul, interieur);
    tempsMeilleur = (((temps != -1) && (temps < tempsMeilleur)) || (tempsMeilleur == -1)) ? temps : tempsMeilleur;

    temps = collisionXNegatif(AABB1_negatif, AABB1_positif, AABB2_negatif, AABB2_positif, equationPlan, debutCalcul, finCalcul, interieur);
    tempsMeilleur = (((temps != -1) && (temps < tempsMeilleur)) || (tempsMeilleur == -1)) ? temps : tempsMeilleur;

    temps = collisionYPositif(AABB1_negatif, AABB1_positif, AABB2_negatif, AABB2_positif, equationPlan, debutCalcul, finCalcul, interieur);
    tempsMeilleur = (((temps != -1) && (temps < tempsMeilleur)) || (tempsMeilleur == -1)) ? temps : tempsMeilleur;

    temps = collisionYNegatif(AABB1_negatif, AABB1_positif, AABB2_negatif, AABB2_positif, equationPlan, debutCalcul, finCalcul, interieur);
    tempsMeilleur = (((temps != -1) && (temps < tempsMeilleur)) || (tempsMeilleur == -1)) ? temps : tempsMeilleur;

    temps = collisionZPositif(AABB1_negatif, AABB1_positif, AABB2_negatif, AABB2_positif, equationPlan, debutCalcul, finCalcul, interieur);
    tempsMeilleur = (((temps != -1) && (temps < tempsMeilleur)) || (tempsMeilleur == -1)) ? temps : tempsMeilleur;

    temps = collisionZNegatif(AABB1_negatif, AABB1_positif, AABB2_negatif, AABB2_positif, equationPlan, debutCalcul, finCalcul, interieur);
    tempsMeilleur = (((temps != -1) && (temps < tempsMeilleur)) || (tempsMeilleur == -1)) ? temps : tempsMeilleur;

    return tempsMeilleur;
  }

   abstract public void toNet(DataOutputStream out) throws Exception;
}

final int XPositif = 1;
final int XNegatif = 2;
final int YPositif = 3;
final int YNegatif = 4;
final int ZPositif = 5;
final int ZNegatif = 6;
final int Aucun = 0;

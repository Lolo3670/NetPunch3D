class Vecteur
{
  public float x, y, z;

  Vecteur()
  {
    x = 0;
    y = 0;
    z = 0;
  }

  Vecteur(float m_x, float m_y, float m_z)
  {
    x = m_x;
    y = m_y;
    z = m_z;
  }

  Vecteur mult(float scalar)
  {
    return new Vecteur(x * scalar, y * scalar, z * scalar);
  }

  Vecteur mult(float m_x, float m_y, float m_z)
  {
    return new Vecteur(x * m_x, y * m_y, z * m_z);
  }

  Vecteur add(Vecteur vecteur)
  {
    return new Vecteur(x + vecteur.x, y + vecteur.y, z + vecteur.z);
  }

  Vecteur add(float scalar)
  {
    return new Vecteur(x + scalar, y + scalar, z + scalar);
  }

  Vecteur add(float m_x, float m_y, float m_z)
  {
    return new Vecteur(x + m_x, y + m_y, z + m_z);
  }

  Vecteur axisToEulerAngles()
  {
    if ((x == 0) && (z == 0) && (y == 0))
      return new Vecteur(0, 0, 0);

    return new Vecteur(0, -atan2(z, x), asin(y / sqrt((x * x) + (y * y) + (z * z))));
  }
  
  Vecteur normaliser()
  {
    float norme = sqrt(x * x + y*y + z*z);
    return new Vecteur(x / norme, y / norme, z / norme);
  }
  
  float norme()
  {
    return sqrt(x * x + y*y + z*z);
  }
  
  float scalaire(Vecteur vecteur)
  {
    return vecteur.x * x + vecteur.y * y + vecteur.z * z;
  }
  
  @Override
    String toString()
  {
    return new String(x + ", " + y + ", " + z);
  }
}

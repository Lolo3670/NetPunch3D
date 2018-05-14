final float tX = 15, tY = 15;
PShape shape = null;

class Plasmax extends Personnage
{
  Plasmax(float x, float y, float z, float rotationX, float rotationY, float rotationZ, int temps) //Temps depuis le debut de la partie
  {
    super(new EquationGravite(0, 0, 0, x, y, z, temps), rotationX, rotationY, rotationZ);
    //super(new EquationRotation(0, 5, 0, temps, 1, 0, true), rotationX, rotationY, rotationZ);
    AABB_negatif = new Vecteur(-0.75, -1.25, -0.75);
    AABB_positif = new Vecteur(0.75, 1.25, 0.75);

    masse = 1.5f;
    rapidite = 7f;
    hauteurSaut = 2;
  }

  protected void renduInterne(int temps)
  {
    rotateY(PI/2);
    switch(nbAnimation)
    {
    case 2:
      {
        float temps2 = temps / 100.0f;
        shape = createShape();
        shape.beginShape(TRIANGLE);

        for (int i = 0; i < tX; i++)
        {
          for (int j = 0; j < tY; j++)
          {
            shape.fill( cos(4 * PI * i / tX) * 128 + 127, cos(4 * PI * j / tY) * 128 + 127, -cos(4 * PI * j / tY) * 128);

            float demiSini = sin((i+0.5)*PI/tX);
            float sinDeuxj = sin(j*2*PI/tY);
            float cosDeuxi = cos((i+1)*PI/tX);
            float demiCosi = cos((i+0.5)*PI/tX);
            float cosDeuxj = cos(j*2*PI/tY);
            float sini = sin(i*PI/tX);
            float sinDeuxi = sin((i+1)*PI/tX);
            float sinDemij = sin((j+0.5)*2*PI/tY);
            float cosDemij = cos((j+0.5)*2*PI/tY);

            float addCosDeuxi = cos(10*cosDeuxi+temps2) / 10;
            float addDemiCosi = cos(10*demiCosi+temps2) / 10;

            shape.vertex(sinDeuxj*sini + cos(10*cos(i*PI/tX)+temps2) / 10, cos(i*PI/tX), cosDeuxj*sini);
            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);

            shape.vertex(sinDeuxj*sini + cos(10*cos(i*PI/tX)+temps2) / 10, cos(i*PI/tX), cosDeuxj*sini);
            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sin((j-0.5)*2*PI/tY)*demiSini + addDemiCosi, demiCosi, cos((j-0.5)*2*PI/tY)*demiSini);

            shape.vertex(sin((j+1)*2*PI/tY)*sinDeuxi + addCosDeuxi, cosDeuxi, cos((j+1)*2*PI/tY)*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);
            shape.vertex(sinDemij*sin((i+1.5)*PI/tX) + cos(10*cos((i+1.5)*PI/tX)+temps2) / 10, cos((i+1.5)*PI/tX), cosDemij*sin((i+1.5)*PI/tX));

            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);
            shape.vertex(sinDemij*sin((i+1.5)*PI/tX) + cos(10*cos((i+1.5)*PI/tX)+temps2) / 10, cos((i+1.5)*PI/tX), cosDemij*sin((i+1.5)*PI/tX));
          }
        }

        shape.endShape();

        pushMatrix();
        translate(0, 0.5, 0);
        rotateX(sin(temps2) - 1);
        pushMatrix();
        translate(-0.75, -0.5, 0);
        rotateZ(-PI/6);
        scale(0.125, 1.25, 0.125);
        shape(shape);
        popMatrix();
        popMatrix();

        pushMatrix();
        translate(0, 0.5, 0);
        rotateX(cos(temps2) - 1);
        pushMatrix();
        translate(0.75, -0.5, 0);
        rotateZ(PI/6);
        scale(0.125, 1.25, 0.125);
        shape(shape);
        popMatrix();
        popMatrix();

        if (lieAuClient)
        {
          pushMatrix();
          scale(0.75, 1.5, 0.75);
          shape(shape);
          popMatrix();

          pushMatrix();
          translate(-0.25, 0.75 + sin(temps2) * 0.125, 0.6);
          fill(255);
          sphere(0.125);
          popMatrix();

          pushMatrix();
          translate(0.25, 0.75 + cos(temps2) * 0.125, 0.6);
          fill(255);
          sphere(0.125);
          popMatrix();
        }
      }
      break;

    case 1:
    case 3:
      {
        float temps2 = temps / 100.0f;
        shape = createShape();
        shape.beginShape(TRIANGLE);

        for (int i = 0; i < tX; i++)
        {
          for (int j = 0; j < tY; j++)
          {
            shape.fill( cos(4 * PI * i / tX) * 128 + 127, cos(4 * PI * j / tY) * 128 + 127, -cos(4 * PI * j / tY) * 128);

            float demiSini = sin((i+0.5)*PI/tX);
            float sinDeuxj = sin(j*2*PI/tY);
            float cosDeuxi = cos((i+1)*PI/tX);
            float demiCosi = cos((i+0.5)*PI/tX);
            float cosDeuxj = cos(j*2*PI/tY);
            float sini = sin(i*PI/tX);
            float sinDeuxi = sin((i+1)*PI/tX);
            float sinDemij = sin((j+0.5)*2*PI/tY);
            float cosDemij = cos((j+0.5)*2*PI/tY);

            float addCosDeuxi = cos(10*cosDeuxi+temps2) / 10;
            float addDemiCosi = cos(10*demiCosi+temps2) / 10;

            shape.vertex(sinDeuxj*sini + cos(10*cos(i*PI/tX)+temps2) / 10, cos(i*PI/tX), cosDeuxj*sini);
            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);

            shape.vertex(sinDeuxj*sini + cos(10*cos(i*PI/tX)+temps2) / 10, cos(i*PI/tX), cosDeuxj*sini);
            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sin((j-0.5)*2*PI/tY)*demiSini + addDemiCosi, demiCosi, cos((j-0.5)*2*PI/tY)*demiSini);

            shape.vertex(sin((j+1)*2*PI/tY)*sinDeuxi + addCosDeuxi, cosDeuxi, cos((j+1)*2*PI/tY)*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);
            shape.vertex(sinDemij*sin((i+1.5)*PI/tX) + cos(10*cos((i+1.5)*PI/tX)+temps2) / 10, cos((i+1.5)*PI/tX), cosDemij*sin((i+1.5)*PI/tX));

            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);
            shape.vertex(sinDemij*sin((i+1.5)*PI/tX) + cos(10*cos((i+1.5)*PI/tX)+temps2) / 10, cos((i+1.5)*PI/tX), cosDemij*sin((i+1.5)*PI/tX));
          }
        }

        shape.endShape();

        pushMatrix();
        translate(-0.75, 0, 0);
        rotateZ(-PI/6);
        scale(0.125, 1.25, 0.125);
        shape(shape);
        popMatrix();

        pushMatrix();
        translate(0.75, 0, 0);
        rotateZ(PI/6);
        scale(0.125, 1.25, 0.125);
        shape(shape);
        popMatrix();
        if (lieAuClient)
        {
          pushMatrix();
          scale(0.75, 1.5, 0.75);
          shape(shape);
          popMatrix();

          pushMatrix();
          translate(-0.25, 0.75 + sin(temps2) * 0.125, 0.6);
          fill(255);
          sphere(0.125);
          popMatrix();

          pushMatrix();
          translate(0.25, 0.75 + cos(temps2) * 0.125, 0.6);
          fill(255);
          sphere(0.125);
          popMatrix();
        }
      }
      break;

    default:
      {
        float temps2 = temps / 500.0f;
        shape = createShape();
        shape.beginShape(TRIANGLE);

        for (int i = 0; i < tX; i++)
        {
          for (int j = 0; j < tY; j++)
          {
            shape.fill( cos(4 * PI * i / tX) * 128 + 127, cos(4 * PI * j / tY) * 128 + 127, -cos(4 * PI * j / tY) * 128);

            float demiSini = sin((i+0.5)*PI/tX);
            float sinDeuxj = sin(j*2*PI/tY);
            float cosDeuxi = cos((i+1)*PI/tX);
            float demiCosi = cos((i+0.5)*PI/tX);
            float cosDeuxj = cos(j*2*PI/tY);
            float sini = sin(i*PI/tX);
            float sinDeuxi = sin((i+1)*PI/tX);
            float sinDemij = sin((j+0.5)*2*PI/tY);
            float cosDemij = cos((j+0.5)*2*PI/tY);

            float addCosDeuxi = cos(10*cosDeuxi+temps2) / 10;
            float addDemiCosi = cos(10*demiCosi+temps2) / 10;

            shape.vertex(sinDeuxj*sini + cos(10*cos(i*PI/tX)+temps2) / 10, cos(i*PI/tX), cosDeuxj*sini);
            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);

            shape.vertex(sinDeuxj*sini + cos(10*cos(i*PI/tX)+temps2) / 10, cos(i*PI/tX), cosDeuxj*sini);
            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sin((j-0.5)*2*PI/tY)*demiSini + addDemiCosi, demiCosi, cos((j-0.5)*2*PI/tY)*demiSini);

            shape.vertex(sin((j+1)*2*PI/tY)*sinDeuxi + addCosDeuxi, cosDeuxi, cos((j+1)*2*PI/tY)*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);
            shape.vertex(sinDemij*sin((i+1.5)*PI/tX) + cos(10*cos((i+1.5)*PI/tX)+temps2) / 10, cos((i+1.5)*PI/tX), cosDemij*sin((i+1.5)*PI/tX));

            shape.vertex(sinDeuxj*sinDeuxi + addCosDeuxi, cosDeuxi, cosDeuxj*sinDeuxi);
            shape.vertex(sinDemij*demiSini + addDemiCosi, demiCosi, cosDemij*demiSini);
            shape.vertex(sinDemij*sin((i+1.5)*PI/tX) + cos(10*cos((i+1.5)*PI/tX)+temps2) / 10, cos((i+1.5)*PI/tX), cosDemij*sin((i+1.5)*PI/tX));
          }
        }

        shape.endShape();

        pushMatrix();
        translate(-0.75, 0, 0);
        rotateZ(-PI/6);
        scale(0.125, 1.25, 0.125);
        shape(shape);
        popMatrix();

        pushMatrix();
        translate(0.75, 0, 0);
        rotateZ(PI/6);
        scale(0.125, 1.25, 0.125);
        shape(shape);
        popMatrix();
        if (lieAuClient)
        {
          pushMatrix();
          scale(0.75, 1.5, 0.75);
          shape(shape);
          popMatrix();

          pushMatrix();
          translate(-0.25, 0.75 + sin(temps2) * 0.125, 0.6);
          fill(255);
          sphere(0.125);
          popMatrix();

          pushMatrix();
          translate(0.25, 0.75 + cos(temps2) * 0.125, 0.6);
          fill(255);
          sphere(0.125);
          popMatrix();
        }
      }
    }
  }

  public void chargerBouclier(int temps)
  {
    if ((rechargeBouclier == -1) || (temps - rechargeBouclier > 20000))
    {
      bouclier = true;
      synchronized (sockets)
      {
        for (int j = 0; j < outs.size(); j++)
        {
          try
          {
            /* On prévient les autres */
            outs.get(j).writeByte(13);
            outs.get(j).writeInt(personnages.indexOf(this));
            outs.get(j).writeBoolean(true);
          }
          catch (Exception e)
          {
            println(e);
          }
        }
      }
    }
  }

  public void chargerAttaqueDeBase(int temps)
  {
    if ((rechargeAttaqueDeBase == -1) || ((temps - rechargeAttaqueDeBase) > 250))
    {
      for (int i = 0; i < personnages.size(); i++)
      {
        Personnage perso = personnages.get(i);
        if (perso != this)
        {
          Vecteur vecteur = perso.equation.calculPosition(temps).add(equation.calculPosition(temps).mult(-1));
          if (vecteur.norme() < 3)
          {
            Vecteur visee = new Vecteur(cos(angleX) * cos(angleY), -sin(angleX), -cos(angleX) * sin(angleY));
            float cosAngle = vecteur.scalaire(visee) / (vecteur.norme() * visee.norme());
            if (cosAngle > 0.8f)
              perso.ejecter(vecteur.x, vecteur.y + 5, vecteur.z, temps, this, 0.5);
          }
        }
      }

      rechargeAttaqueDeBase = temps;
    }
  }

  public void attaqueBouclier(int temps) {
  }

  public void attaqueAttaqueDeBase(int temps) {
  }

  public boolean chargerCompetence(int temps) {
    return true;
  }
  public void attaqueCompetence(int temps) {
    if ((rechargeCompetence == -1) || ((temps - rechargeCompetence) > 2000))
    {
      Vecteur visee = new Vecteur(cos(angleX) * cos(angleY), -sin(angleX), -cos(angleX) *  sin(angleY)).mult(8);
      Vecteur position = equation.calculPosition(temps);
      influents.add(new ProjectileCompPlasmax(visee, position, this, temps));

      synchronized (sockets)
      {
        for (int j = 0; j < outs.size(); j++)
        {
          try
          {
            /* Envoie du projectile test */
            outs.get(j).writeByte(8);
            outs.get(j).writeInt(202);
            outs.get(j).writeFloat(visee.x);
            outs.get(j).writeFloat(visee.y);
            outs.get(j).writeFloat(visee.z);
            outs.get(j).writeFloat(position.x);
            outs.get(j).writeFloat(position.y);
            outs.get(j).writeFloat(position.z);
            outs.get(j).writeInt(temps);
          }
          catch (Exception e)
          {
            println(e);
          }
        }
      }


      rechargeCompetence = temps;
    }
  }
}

class ProjectileCompPlasmax extends Projectile
{ 
  Plasmax plasmax;

  ProjectileCompPlasmax(Vecteur direction, Vecteur position, Plasmax perso, int temps)
  {
    super(new EquationLineaire(direction.x, direction.y, direction.z, position.x, position.y, position.z, temps));
    plasmax = perso;
  }

  ProjectileCompPlasmax(Vecteur direction, Vecteur position, int temps)
  {
    super(new EquationLineaire(direction.x, direction.y, direction.z, position.x, position.y, position.z, temps));
    plasmax = null;
  }

  protected void renduInterne(int temps)
  {
    rotateZ(PI/2);
    scale(0.25, 1, 0.25);
    shape(shape);
  }

  protected void effetSurPersonnage(Personnage perso, int temps)
  {
    Vecteur vecteur = equation.calculVitesse(temps);
    perso.ejecter(vecteur.x, vecteur.y + 5, vecteur.z, temps, plasmax, 0.5);
  }

  @Override
    public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin)
  {
        if ((tempsFin - equation.m_tempsDebut) > 2000)
    {
      this.toRemove = true;
      return -1;
    }
    if (perso == plasmax)
    {
      return -1;
    }
    if (!toRemove)
    {
      int result = perso.equation.collision(perso.getAABB_negatif(), perso.getAABB_positif(), new Vecteur(-2, -2, -2), new Vecteur(2, 2, 2), equation, tempsDebut, tempsFin, false);
      return result;
    }
    return -1;
  }
}

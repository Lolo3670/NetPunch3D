class Globulix extends Personnage
{
  Globulix(float x, float y, float z, float rotationX, float rotationY, float rotationZ, int temps) //Temps depuis le debut de la partie
  {
    super(new EquationGravite(0, 0, 0, x, y, z, temps), rotationX, rotationY, rotationZ);
    //super(new EquationRotation(0, 5, 0, temps, 1, 0, true), rotationX, rotationY, rotationZ);
    AABB_negatif = new Vecteur(-0.25, -0.75, -0.25);
    AABB_positif = new Vecteur(0.25, 0.5, 0.25);

    masse = 10;
    rapidite = 10f;
    hauteurSaut = 2;
  }

  protected void renduInterne(int temps)
  {
    scale(0.5, 0.5, 0.5); 
    rotateY(PI);
    rotateX(PI);

    float bras=0.30;
    float pieds=0.40;
    float tete=0.30;
    float corps=0.6;

    switch(nbAnimation)
    {
    case 1:
      if (bouclier)
      {
        rotateX(PI);
        noStroke();

        if (lieAuClient)
        {
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
          pushMatrix();
          rotateZ(-PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(#EAEAE3);
          translate(-0.15, 0.4, 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
          translate(-0.40, 0.4, 0);
          sphere(0.1);
          popMatrix();


          pushMatrix();
          rotateX(PI/5);
          rotateY(PI/10);
          translate(0.2, -0.2, -0.6);
          rotateZ(-temps/100.0f);
          scale(1, 1, 2);
          box(bras);
          popMatrix();
          pushMatrix();
          rotateX(-PI/5);
          rotateY(-PI/10);
          translate(0.2, -0.2, 0.6);
          rotateZ(-temps/100.0f);
          scale(1, 1, 2);
          box(bras);
          popMatrix();

          pushMatrix();
          rotateX(-PI/9);
          translate(-0.2, -1.1, 0.05);
          translate(0.2*cos(millis()/40.0f), 0, 0);
          rotateY(millis()/100.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
          pushMatrix();
          rotateX(PI/9);
          translate(-0.2, -1.1, -0.05);
          translate(-0.2*cos(millis()/40.0f), 0, 0);
          rotateY(-millis()/100.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
        }
      } else
      {
        noStroke();

        if (lieAuClient)
        {
          fill(#C1B0B0);
          pushMatrix();
          rotateZ(PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(#EAEAE3);
          translate(-0.15, -0.4, 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(30);
          translate(-0.40, -0.4, 0);
          sphere(0.1);
          popMatrix();


          fill(57+100*abs(cos(temps/80.0f)), 53+100*abs(cos(temps/80.0f)), 41);
          pushMatrix();
          rotateX(-PI/5);
          rotateY(PI/10);
          translate(0.2, 0.2, -0.6);
          rotateZ(-temps/100.0f);
          scale(1, 1, 2);
          box(bras);
          popMatrix();
          pushMatrix();
          rotateX(PI/5);
          rotateY(-PI/10);
          translate(0.2, 0.2, 0.6);
          rotateZ(-temps/100.0f);
          scale(1, 1, 2);
          box(bras);
          popMatrix();

          fill(57+30*abs(cos(temps/80.0f)), 53+30*abs(cos(temps/80.0f)), 41+15*abs(cos(temps/80.0f)));
          pushMatrix();
          rotateX(-PI/9);
          translate(-0.2, 1, -0.10);
          translate(0.2*cos(millis()/40.0f), 0, 0);
          rotateY(millis()/100.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
          pushMatrix();
          rotateX(PI/9);
          translate(-0.2, 1, 0.10);
          translate(-0.2*cos(millis()/40.0f), 0, 0);
          rotateY(-millis()/100.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
        }
      }
      break;

    case 2:
      if (bouclier)
      {
        noStroke();
        if (lieAuClient) {
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
          pushMatrix();
          rotateZ(PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(#EAEAE3);
          translate(-0.15, -0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
          translate(-0.40, -0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(0.1);
          popMatrix();
        }
        fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
        pushMatrix();
        translate(-1.4+2*cos(PI+temps/80.0f), -0.1, -0.6);
        scale(2, 1, 1);
        box(bras);
        popMatrix();
        pushMatrix();
        translate(-1.4+2*cos(temps/80.0f), -0.1, 0.6);
        scale(2, 1, 1);
        box(bras);
        popMatrix();

        pushMatrix(); 
        translate(-0.7, 0.7+0.05*sin(temps/100), -0.4);
        rotateZ(PI/3);
        rotateY(millis()/50.0f);
        scale(1, 0.3, 1);
        box(pieds);
        popMatrix();
        pushMatrix();
        translate(-0.7, 0.7+0.05*cos(temps/100), 0.4);
        rotateZ(PI/3);
        rotateY(-millis()/50.0f);
        scale(1, 0.3, 1);
        box(pieds);
        popMatrix();
      } else
      {
        noStroke();
        if (lieAuClient) {
          fill(#C1B0B0);
          pushMatrix();
          rotateZ(PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(#EAEAE3);
          translate(-0.15, -0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(#A5140F);
          translate(-0.40, -0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(0.1);
          popMatrix();
        }
        fill(57+100*abs(cos(temps/80.0f)), 53+100*abs(cos(temps/80.0f)), 41);
        pushMatrix();
        translate(-1.4+2*cos(PI+temps/80.0f), -0.1, -0.6);
        scale(2, 1, 1);
        box(bras);
        popMatrix();
        fill(57+100*abs(cos(PI+temps/80.0f)), 53+100*abs(cos(PI+temps/80.0f)), 41);
        pushMatrix();
        translate(-1.4+2*cos(temps/80.0f), -0.1, 0.6);
        scale(2, 1, 1);
        box(bras);
        popMatrix();

        fill(57+50*abs(cos(temps/80.0f)), 53+50*abs(cos(temps/80.0f)), 41);
        pushMatrix(); 
        translate(-0.7, 0.7+0.05*sin(temps/100), -0.4);
        rotateZ(PI/3);
        rotateY(millis()/50.0f);
        scale(1, 0.3, 1);
        box(pieds);
        popMatrix();
        pushMatrix();
        translate(-0.7, 0.7+0.05*cos(temps/100), 0.4);
        rotateZ(PI/3);
        rotateY(-millis()/50.0f);
        scale(1, 0.3, 1);
        box(pieds);
        popMatrix();
      }
      break;

    case 3:
      rotateX(PI);
      if (!bouclier)
      {
        noStroke();
        if (lieAuClient) {
          fill(#C1B0B0);
          pushMatrix();
          rotateZ(PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(#EAEAE3);
          translate(-0.2, 0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(#A5140F);
          translate(-0.45, 0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(0.1);
          popMatrix();
        }
        fill(57+100*abs(cos(temps/120.0f)), 53+100*abs(cos(temps/120.0f)), 41);
        pushMatrix();
        translate(2*cos(temps/120.0f), sin(PI+temps/120.0f), 2*sin(temps/120.0f));
        box(bras);
        popMatrix();
        pushMatrix();
        translate(-2*cos(PI+temps/100.0f), sin(temps/120.0f), 2*sin(PI+temps/100.0f));
        box(bras);
        popMatrix();

        fill(57+50*abs(cos(temps/80.0f)), 53+50*abs(cos(temps/80.0f)), 41);
        pushMatrix(); 
        translate(2*cos(temps/120.0f), -0.3+2*sin(temps/120.0f), 0);
        box(pieds);
        popMatrix();
        pushMatrix(); 
        translate(2*cos((PI/2)*temps/120.0f), -0.3-2*sin((PI/2)*temps/120.0f), 0);
        box(pieds);
        popMatrix();
        pushMatrix();
        translate(2*cos(temps/80.0f), 0, 2*sin(temps/80.0f));
        box(pieds);
        popMatrix();
        pushMatrix();
        translate(2*cos(PI+temps/100.0f), 0, -2*sin(temps/100.0f));
        box(pieds);
        popMatrix();
      } else
      {
        noStroke();
        if (lieAuClient) {
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
          pushMatrix();
          rotateZ(PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(#EAEAE3);
          translate(-0.2, 0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(#A5140F);
          translate(-0.45, 0.4, 0);
          translate(0, 0.02*cos(temps/10.0f), 0);
          sphere(0.1);
          popMatrix();
        }
        fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
        pushMatrix();
        translate(2*cos(temps/120.0f), sin(PI+temps/120.0f), 2*sin(temps/120.0f));
        box(bras);
        popMatrix();
        pushMatrix();
        translate(-2*cos(PI+temps/100.0f), sin(temps/120.0f), 2*sin(PI+temps/100.0f));
        box(bras);
        popMatrix();

        pushMatrix(); 
        translate(2*cos(temps/120.0f), -0.3+2*sin(temps/120.0f), 0);
        box(pieds);
        popMatrix();
        pushMatrix(); 
        translate(2*cos((PI/2)*temps/120.0f), -0.3-2*sin((PI/2)*temps/120.0f), 0);
        box(pieds);
        popMatrix();
        pushMatrix();
        translate(2*cos(temps/80.0f), 0, 2*sin(temps/80.0f));
        box(pieds);
        popMatrix();
        pushMatrix();
        translate(2*cos(PI+temps/100.0f), 0, -2*sin(temps/100.0f));
        box(pieds);
        popMatrix();
      }
      break;


    default:
      if (bouclier)
      {
        noStroke();
        if (lieAuClient) {
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
          pushMatrix();
          rotateZ(PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(200);
          translate(-0.15, -0.4, 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
          translate(-0.40, -0.4, 0);
          sphere(0.1);
          popMatrix();

          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
          pushMatrix();
          rotateX(-PI/7);
          rotateY(PI/10);
          translate(0.2, 0.2, -0.6);
          scale(1, 1, 2);
          box(bras);
          popMatrix();
          pushMatrix();
          rotateX(PI/7);
          rotateY(-PI/10);
          translate(0.2, 0.2, 0.6);
          scale(1, 1, 2);
          box(bras);
          popMatrix();

          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
          pushMatrix();
          rotateX(-PI/9);
          translate(0, 1.1+0.05*sin(temps/500.0f), -0.15);
          rotateY(millis()/500.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
          pushMatrix();
          rotateX(PI/9);
          translate(0, 1.1+0.05*cos(temps/500.0f), 0.15);
          rotateY(-millis()/500.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
        }
      } else
      {
        noStroke();
        if (lieAuClient) {
          fill(#C1B0B0);
          pushMatrix();
          rotateZ(PI/50);
          scale(1.2, 2.5, 1);
          translate(0.1, 0, 0);
          box(corps);
          popMatrix();

          pushMatrix();
          fill(#EAEAE3);
          translate(-0.15, -0.4, 0);
          sphere(tete);
          popMatrix();
          pushMatrix();
          fill(20);
          translate(-0.40, -0.4, 0);
          sphere(0.1);
          popMatrix();

          fill(#393529);
          pushMatrix();
          rotateX(-PI/7);
          rotateY(PI/10);
          translate(0.2, 0.2, -0.6);
          scale(1, 1, 2);
          box(bras);
          popMatrix();
          pushMatrix();
          rotateX(PI/7);
          rotateY(-PI/10);
          translate(0.2, 0.2, 0.6);
          scale(1, 1, 2);
          box(bras);
          popMatrix();

          fill(#393529);
          pushMatrix();
          rotateX(-PI/9);
          translate(0, 1.1+0.05*sin(temps/500.0f), -0.15);
          rotateY(millis()/500.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
          pushMatrix();
          rotateX(PI/9);
          translate(0, 1.1+0.05*cos(temps/500.0f), 0.15);
          rotateY(-millis()/500.0f);
          scale(1, 0.3, 1);
          box(pieds);
          popMatrix();
        }
      }
      break;
    }
  }

  public void chargerBouclier(int temps) //même fonctionnement que cubeman
  {
    if ((rechargeBouclier == -1) || (temps - rechargeBouclier > 20000))
    {
      bouclier = true;
      synchronized (sockets)
      {
        for (int j = 0; j < outs.size(); j++) // On prévient les autres
        {
          try
          {
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

  public void chargerAttaqueDeBase(int temps) //pareile que chez cubeman
  {
    if ((rechargeAttaqueDeBase == -1) || ((temps - rechargeAttaqueDeBase) > 250))
    {
      influents.add(new ProjectileGlobulix(new Vecteur(cos(angleX) * cos(angleY), -sin(angleX), -cos(angleX) *  sin(angleY)).mult(8), equation.calculPosition(temps), this, temps));

      synchronized (sockets)
      {
        for (int j = 0; j < outs.size(); j++) // On prévient les autres
        {
          try
          {
            /* Envoie du projectile test */
            outs.get(j).writeByte(8);
            outs.get(j).writeInt(200);
            outs.get(j).writeInt(0);
          }
          catch (Exception e)
          {
            println(e);
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

  private int timerAttaqueSpeciale = 0;
  public boolean chargerCompetence(int temps) { //Recharge pareil que chez cubeman, mais éjecte tout autour de lui
    if ((rechargeCompetence == -1) || ((temps - rechargeCompetence) > 10000))
    {
      rechargeCompetence = temps;
    }
    if ((temps - rechargeCompetence) < 4000)
    {
      changeAnimation(byte(3), temps);
      if ((temps - timerAttaqueSpeciale) > 250)
      {
        for (int i = 0; i < personnages.size(); i++)
        {
          Personnage perso = personnages.get(i);
          if (perso != this)
          {
            Vecteur vecteur = perso.equation.calculPosition(temps).add(equation.calculPosition(temps).mult(-1));
            if (vecteur.norme() < 3)
            {
              vecteur = vecteur.normaliser().mult(4);
              perso.ejecter(vecteur.x, vecteur.y + 5, vecteur.z, temps, this, 0.5);
            }
          }
        }
        timerAttaqueSpeciale = temps;
      }
    } else
      return true;
    return false;
  }
  public void attaqueCompetence(int temps) {
  }
}

class ProjectileGlobulix extends Projectile
{ 
  Personnage globulix;

  ProjectileGlobulix(Vecteur direction, Vecteur position, Personnage perso, int temps) //temps relatif au début de la partie
  {
    super(new EquationLineaire(direction.x, direction.y, direction.z, position.x, position.y, position.z, temps));
    globulix = perso;
  }

  protected void renduInterne(int temps)
  {
    fill(255, 255, 255);
    box(0.3, 0.1, 0.1);
  }

  protected void effetSurPersonnage(Personnage perso, int temps)
  {
    Vecteur vitesse = equation.calculVitesse(temps).normaliser();
    perso.ejecter(vitesse.x * 5, 5f, vitesse.y * 5, temps, globulix, 0.50);
  }

  @Override
    public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin)
  {
    if ((tempsFin - equation.m_tempsDebut) > 250)
    {
      this.toRemove = true;
      return -1;
    }
    if (perso == globulix)
    {
      return -1;
    }
    if (!toRemove)
    {
      int result = perso.equation.collision(perso.getAABB_negatif(), perso.getAABB_positif(), new Vecteur(0, 0, 0), new Vecteur(0, 0, 0), equation, tempsDebut, tempsFin, false);
      return result;
    }
    return -1;
  }
}
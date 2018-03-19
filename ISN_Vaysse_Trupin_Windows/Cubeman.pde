class Cubeman extends Personnage
{
  Cubeman(float x, float y, float z, float rotationX, float rotationY, float rotationZ, int temps) //Temps depuis le debut de la partie
  {
    super(new EquationGravite(0, 0, 0, x, y, z, temps), rotationX, rotationY, rotationZ);
    //super(new EquationRotation(0, 5, 0, temps, 1, 0, true), rotationX, rotationY, rotationZ);
    AABB_negatif = new Vecteur(-0.75, -1.25, -0.75);
    AABB_positif = new Vecteur(0.75, 1.25, 0.75);

    masse = 20;
    rapidite = 7f;
    hauteurSaut = 2;
  }



  protected void renduInterne(int temps)
  {
    float corps=1.5;
    float tete=0.5;
    float bras=0.5;
    float pieds=0.5;

    switch(nbAnimation)
    {
    case 1:
      if (lieAuClient) {
        if (bouclier)
        {

          noStroke();
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);        
          pushMatrix();
          box(corps);
          popMatrix();

          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);        
          pushMatrix();
          translate(0, 0, -1);
          rotateZ(-temps / 100.0f);
          box(bras);
          popMatrix();
          pushMatrix();
          translate(0, 0, 1);
          rotateZ(-temps / 100.0f);
          box(bras);
          popMatrix();

          pushMatrix();
          translate(0.50*cos(temps/80.0f), -0.5, 0);
          translate(0, -0.50, -0.30);
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(-0.50*cos(temps/80.0f), -0.5, 0);
          translate(0, -0.50, 0.30);
          box(pieds);
          popMatrix();

          pushMatrix();
          translate(0, 1, 0);
          box(tete);
          popMatrix();
        } else
        {
          noStroke();
          fill(#3C72DB);
          pushMatrix();
          box(corps);
          popMatrix();

          fill(#5CE3DB);
          pushMatrix();
          translate(0, 0, -1);
          rotateZ(-temps / 100.0f);
          box(bras);
          popMatrix();
          pushMatrix();
          translate(0, 0, 1);
          rotateZ(-temps / 100.0f);
          box(bras);
          popMatrix();

          fill(#3494C6);
          pushMatrix();
          translate(0.50*cos(temps/80.0f), -0.5, 0);
          translate(0, -0.50, -0.30);
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(-0.50*cos(temps/80.0f), -0.5, 0);
          translate(0, -0.50, 0.30);
          box(pieds);
          popMatrix();

          pushMatrix();
          fill(0.50);
          translate(0, 1, 0);
          box(tete);
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
          box(corps);
          popMatrix();
          pushMatrix();
          translate(0, 1+0.1*cos(PI+temps/50.0f), 0);
          box(tete);
          popMatrix();
          pushMatrix();
          translate(0, -1, -0.30);
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1, 0.30);
          box(pieds);
          popMatrix();
        }
        fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
        pushMatrix();
        translate(1.7+2.5*cos(PI+temps/100.0f), 0.1, 0);
        translate(0, 0, -1);
        box(bras);
        popMatrix();
        pushMatrix();
        translate(0, 0, 1);
        translate(1.7+2.5*cos(temps/100.0f), 0.1, 0);
        box(bras);
        popMatrix();
      } else
      {
        noStroke();
        if (lieAuClient) {
          fill(#3C72DB);
          pushMatrix();
          box(corps);
          popMatrix();
          fill(#3494C6);
          pushMatrix();
          translate(0, -1, -0.30);
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1, 0.30);
          box(pieds);
          popMatrix();

          pushMatrix();
          fill(0.50);
          translate(0, 1+0.1*cos(PI+temps/50.0f), 0);
          box(tete);
          popMatrix();
        }
        fill(#5CE3DB);
        pushMatrix();
        translate(1.7+2.5*cos(PI+temps/100.0f), 0.1, 0);
        translate(0, 0, -1);
        box(bras);
        popMatrix();
        pushMatrix();
        translate(0, 0, 1);
        translate(1.7+2.5*cos(temps/100.0f), 0.1, 0);
        box(bras);
        popMatrix();
      }
      break;

    case 3:
      if (bouclier)
      {
        rotateZ(-angleX);

        noStroke();
        if (lieAuClient) {
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
          pushMatrix();
          box(corps);
          popMatrix();
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
          pushMatrix();
          translate(0, -1.5*sin((PI/3)+temps/300.0f), 1.5*cos((PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin((2*PI/3)+temps/300.0f), 1.5*cos((2*PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin((4*PI/3)+temps/300.0f), 1.5*cos((4*PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin((5*PI/3)+temps/300.0f), 1.5*cos((5*PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();

          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
          pushMatrix();
          translate(0, -1.5*sin(temps/300.0f), 1.5*cos(temps/300.0f));
          box(bras);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin(PI+temps/300.0f), 1.5*cos(PI+temps/300.0f));
          box(bras);
          popMatrix();
          pushMatrix();
          fill(0.50);
          translate(2*sin(PI+temps/80.0f)+1.5, 0, 0);
          box(tete);
          popMatrix();
        }
      } else
      {
        rotateZ(-angleX);

        noStroke();
        if (lieAuClient) {
          fill(#3C72DB);
          pushMatrix();
          box(corps);
          popMatrix();
          fill(#3494C6);
          pushMatrix();
          translate(0, -1.5*sin((PI/3)+temps/300.0f), 1.5*cos((PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin((2*PI/3)+temps/300.0f), 1.5*cos((2*PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin((4*PI/3)+temps/300.0f), 1.5*cos((4*PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin((5*PI/3)+temps/300.0f), 1.5*cos((5*PI/3)+temps/300.0f));
          box(pieds);
          popMatrix();

          fill(#5CE3DB);
          pushMatrix();
          translate(0, -1.5*sin(temps/300.0f), 1.5*cos(temps/300.0f));
          box(bras);
          popMatrix();
          pushMatrix();
          translate(0, -1.5*sin(PI+temps/300.0f), 1.5*cos(PI+temps/300.0f));
          box(bras);
          popMatrix();
        }
        pushMatrix();
        fill(0.50);
        translate(2*sin(PI+temps/80.0f)+1.5, 0, 0);
        box(tete);
        popMatrix();
      }
      break;

    case 4:
      noStroke();
      fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
      pushMatrix();
      box(corps);
      popMatrix();

      fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
      pushMatrix();
      translate(1.7+2.5*cos(PI+temps/100.0f), 0.1, 0);
      translate(0, 0, -1);
      box(bras);
      popMatrix();
      pushMatrix();
      translate(0, 0, 1);
      translate(1.7+2.5*cos(temps/100.0f), 0.1, 0);
      box(bras);
      popMatrix();

      pushMatrix();
      translate(0, -1, -0.30);
      box(pieds);
      popMatrix();
      pushMatrix();
      translate(0, -1, 0.30);
      box(pieds);
      popMatrix();

      pushMatrix();
      translate(0, 1+0.1*cos(PI+temps/50.0f), 0);
      box(tete);
      popMatrix();
      break;


    default:
      if (lieAuClient) {
        if (bouclier)
        {
          noStroke();
          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+127, 0.67*sin(temps/33.0f)*128+127);
          pushMatrix();
          box(corps);
          popMatrix();

          fill(-0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.58*cos(temps/33.0f)*128-0.33*sin(temps/33.0f)*128+50, 0.67*sin(temps/33.0f)*128+50);
          pushMatrix();
          translate(0, 0, -1);
          box(bras);
          popMatrix();
          pushMatrix();
          translate(0, 0, 1);
          box(bras);
          popMatrix();

          pushMatrix();
          translate(0, -1, -0.30);
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1, 0.30);
          box(pieds);
          popMatrix();

          pushMatrix();
          translate(0, 1, 0);
          box(tete);
          popMatrix();
        } else
        {
          noStroke();
          fill(#3C72DB);
          pushMatrix();
          box(corps);
          popMatrix();

          fill(#5CE3DB);
          pushMatrix();
          translate(0, 0, -1);
          box(bras);
          popMatrix();
          pushMatrix();
          translate(0, 0, 1);
          box(bras);
          popMatrix();

          fill(#3494C6);
          pushMatrix();
          translate(0, -1, -0.30);
          box(pieds);
          popMatrix();
          pushMatrix();
          translate(0, -1, 0.30);
          box(pieds);
          popMatrix();

          pushMatrix();
          fill(0.50);
          translate(0, 1, 0);
          box(tete);
          popMatrix();
        }
      }
      break;
    }
  }

  public void chargerBouclier(int temps)
  {
    if ((rechargeBouclier == -1) || (temps - rechargeBouclier > 20000)) //si le bouclier na jamais été lancé lancé ou si cela fait plus de 20 secondes
    {
      bouclier = true;
    }
  }

  public void chargerAttaqueDeBase(int temps)
  {
    if ((rechargeAttaqueDeBase == -1) || ((temps - rechargeAttaqueDeBase) > 250)) //Tous les quarts de secondes un projectile est envoyé dans la direction de visée
    {
      influents.add(new ProjectileCubeman(new Vecteur(cos(angleX) * cos(angleY), -sin(angleX), -cos(angleX) *  sin(angleY)).mult(8), equation.calculPosition(temps), this, temps));

      rechargeAttaqueDeBase = temps;
    }
  }

  public void attaqueBouclier(int temps) {
  }

  public void attaqueAttaqueDeBase(int temps) {
  }

  private int timerAttaqueSpeciale = 0;
  public boolean chargerCompetence(int temps) {
    if ((rechargeCompetence == -1) || ((temps - rechargeCompetence) > 10000)) //temps de rehcarge 10 sec
    {
      rechargeCompetence = temps;
    }

    if ((temps - rechargeCompetence) < 4000) //L'attaque dure 4 sec
    {
      changeAnimation(byte(3), temps);
      if ((temps - timerAttaqueSpeciale) > 1000) //Toutes les secondes durant, on balance un missile
      {
        influents.add(new ProjectileCompCubeman(new Vecteur(cos(angleX) * cos(angleY), -sin(angleX), -cos(angleX) *  sin(angleY)).mult(8), equation.calculPosition(temps), this, temps));

        timerAttaqueSpeciale = temps;
      }
    } else
      return true;

    return false;
  }
  public void attaqueCompetence(int temps) {
  }
}


class ProjectileCubeman extends Projectile
{ 
  Cubeman cubeman;

  ProjectileCubeman(Vecteur direction, Vecteur position, Cubeman perso, int temps) //temps relatif au début de la partie
  {
    super(new EquationLineaire(direction.x, direction.y, direction.z, position.x, position.y, position.z, temps));
    cubeman = perso;
  }

  protected void renduInterne(int temps) //que sur le serveur, debug
  {
    fill(255, 255, 255);
    box(0.3, 0.1, 0.1);
  }

  protected void effetSurPersonnage(Personnage perso, int temps)
  {
    Vecteur vitesse = equation.calculVitesse(temps).normaliser();
    perso.ejecter(vitesse.x * 5, 5f, vitesse.y * 5, temps, cubeman, 1);
  }

  @Override
    public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin)
  {
    if ((tempsFin - equation.m_tempsDebut) > 500)
    {
      this.toRemove = true;
      return -1;
    }
    if (perso == cubeman)
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


class ProjectileCompCubeman extends Projectile
{ 
  Cubeman cubeman;

  ProjectileCompCubeman(Vecteur direction, Vecteur position, Cubeman perso, int temps) //temps relatif au début de la partie
  {
    super(new EquationLineaire(direction.x, direction.y, direction.z, position.x, position.y, position.z, temps));
    cubeman = perso;
  }

  protected void renduInterne(int temps)
  {
    fill(255, 255, 255);
    box(2, 2, 2);
  }

  protected void effetSurPersonnage(Personnage perso, int temps) //ejecte tous les persos de la zone, comme la compétence de globulix
  {
    for (int i = 0; i < personnages.size(); i++)
    {
      Personnage perso2 = personnages.get(i);
      if (perso2 != cubeman)
      {
        Vecteur vecteur = perso2.equation.calculPosition(temps).add(equation.calculPosition(temps).mult(-1));
        if (vecteur.norme() < 3)
        {
          vecteur = vecteur.normaliser().mult(8);
          perso2.ejecter(vecteur.x, 10.0f, vecteur.z, temps, cubeman, 0.5);
        }
      }
    }
  }

  @Override
    public int collisionAvecPersonnage(Personnage perso, int tempsDebut, int tempsFin)
  {
    if ((equation.calculPosition(tempsDebut).y < -10) || (equation.calculPosition(tempsDebut).y > 10))
    {
      this.toRemove = true;
      return -1;
    }
    if (perso == cubeman)
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
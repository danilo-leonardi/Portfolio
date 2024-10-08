class Jogo extends GuiComponente
{
  public float escala = 1f;
  public Coord translacao = new Coord();
  public float rotacao = 0f;

  public final int MODO_CORRIDA_CONTRA_O_TEMPO = 0;
  public final int MODO_LIVRE = 1;
  public int modoDeJogo = MODO_CORRIDA_CONTRA_O_TEMPO;

  public boolean pausa = false;
  public float tempo = 0f;
  public float melhorTempo = Float.POSITIVE_INFINITY;
  public boolean novoRecorde = false;
  public boolean corridaContraTempoFalhou = false;

  private Bola bolas[] = new Bola[16];
  
  private boolean semMovimento = true;
  
  private boolean tacadaPreparando = false;
  private final float tacadaVelMax = 190.0f;
  private float tacadaPotencia = 0.0f;
  public boolean tacadaTrajetoria = true;
  public boolean tacadaTrajetoriaColisaoBola = true;
  
  public int posicionandoBola = -1;
  private boolean posicionandoBolaValido = false;
  
  private final int FERRAMENTA_JOGAR = 0;
  private final int FERRAMENTA_MOVER = 1;
  private int ferramenta = FERRAMENTA_JOGAR;
  private boolean ferramentaMoverMovendo = false;
  private Coord ferramentaMoverClique = new Coord();
  private Coord ferramentaMoverTransAntiga = new Coord();

  Mesa mesa = new Mesa(new Coord(254.0f, 127.0f), 3.7f, 20.0f);

  Jogo()
  {
    for (int i = 0; i < bolas.length; i++) bolas[i] = new Bola();
    reiniciar();
  }

  Matriz matriz()
  {
    return 
      matrizIdentidade()
      .mult(matrizTranslacao(translacao))
      .mult(matrizEscala(new Coord(escala, escala)))
      .mult(matrizRotacao(rotacao))
      ;
  }

  Coord telaParaMundo(Coord coordTela)
  {
    return matriz().inversa().mult(coordTela);
  }
  
  Coord mundoParaTela(Coord coordMundo)
  {
    return matriz().mult(coordMundo);
  }

  Coord mouseParaMundo()
  {
    return telaParaMundo(new Coord(mouseX, mouseY));
  }
  
  void aplicarMatriz()
  {
    translate(translacao.x, translacao.y);
    scale(escala);
    rotate(rotacao);
  }
  
  @Override
  public GuiComponente contemMouse()
  {
    return this;
  }
  @Override
  public void aoMoverMouse()
  {
    if (ferramenta == FERRAMENTA_JOGAR)
    {
      if (semMovimento && posicionandoBola != -1)
      {
        checarPosicaoBolaValida();
      }
    }
    else if (ferramenta == FERRAMENTA_MOVER)
    {
      if (ferramentaMoverMovendo)
      {
        translacao.def(
          ferramentaMoverTransAntiga
          .soma(mouse())
          .sub(ferramentaMoverClique)
        );
      }
    }
  }
  @Override
  public void aoClicarMouse()
  {
    if (ferramenta == FERRAMENTA_JOGAR && mouseButton == LEFT)
    {
      if (posicionandoBola != -1)
      {
        if (posicionandoBolaValido)
        {
          bolas[posicionandoBola].estaEmJogo = true;
          bolas[posicionandoBola].vel.def(0f, 0f);
          posicionandoBola = -1;
        }
      }
      else if (semMovimento)
      {
        Coord mouse = mouseParaMundo();
        if (mouse.sub(bolas[0].pos).mag() < Bola.raio)
        {
          tacadaPreparando = !tacadaPreparando;
        }
        else if (tacadaPreparando)
        {
          tacadaPreparando = false;
          Coord direcao = mouse.sub(bolas[0].pos).unidade();
          bolas[0].vel = direcao.mult(map(tacadaPotencia, 0f, 1f, 0f, tacadaVelMax));
        }
      }
    }
    else if ((ferramenta == FERRAMENTA_MOVER && mouseButton == LEFT) || mouseButton == RIGHT)
    {
      ferramentaMoverMovendo = !ferramentaMoverMovendo;
      if (ferramentaMoverMovendo)
      {
        ferramenta = FERRAMENTA_MOVER;
        ferramentaMoverClique.def(mouseX, mouseY);
        ferramentaMoverTransAntiga.def(translacao);
      }
      else
      {
        ferramenta = FERRAMENTA_JOGAR;
      }
    }
  }
  @Override
  public void aoRolarRodaMouse(MouseEvent evento)
  {
    if (ferramenta == FERRAMENTA_MOVER)
    {
      Coord mouseTela = new Coord(mouseX, mouseY);
      Coord mouseMundoAntigo = telaParaMundo(mouseTela);
      
      if (evento.getCount() > 0)
          escala *= 1.2f;
      else
          escala /= 1.2f;
    
      Coord mouseMundoNovo = telaParaMundo(mouseTela);
      
      translacao.def(mundoParaTela(mouseMundoNovo.sub(mouseMundoAntigo)));
      ferramentaMoverClique.def(mouseX, mouseY);
      ferramentaMoverTransAntiga.def(translacao);
    }
    else //if (ferramenta == FERRAMENTA_JOGAR)
    {
      tacadaPotencia = max(min(tacadaPotencia + (float)evento.getCount() * 0.05f, 1f), 0f);
    }
  }
  @Override
  public void aoPressionarTecla()
  {
    if (key == 'r')
    {
      reiniciar();
    }
    else if (key == 'j')
    {
      ferramenta = FERRAMENTA_JOGAR;
    }
    else if (key == 'm')
    {
      ferramenta = FERRAMENTA_MOVER;
    }
    else if (key == 'x' || key == 'z')
    {
      Coord mouseTela = new Coord(mouseX, mouseY);
      Coord mouseMundoAntigo = telaParaMundo(mouseTela);
      
      rotacao += (key == 'x' ? 1f : -1f) * PI / 180f;
    
      Coord mouseMundoNovo = telaParaMundo(mouseTela);
      
      translacao.def(mundoParaTela(mouseMundoNovo.sub(mouseMundoAntigo)));      
    }
    else if (key == 'f')
    {
      for (int i = 1; i < bolas.length; i++)
        bolas[i].estaEmJogo = false;
    }
  }
  
  private void checarPosicaoBolaValida()
  {
    posicionandoBolaValido = true;
    Bola nBola = new Bola();
    nBola.pos.def(mouseParaMundo());
    
    // colisão com mesa
    if (mesa.colideComEsq(nBola))
        nBola.pos.x = -mesa.tamanho.x / 2 + Bola.raio;
    else if (mesa.colideComDir(nBola))
        nBola.pos.x = mesa.tamanho.x / 2 - Bola.raio;
    
    if (mesa.colideComSup(nBola))
        nBola.pos.y = -mesa.tamanho.y / 2 + Bola.raio;
    else if (mesa.colideComInf(nBola))
        nBola.pos.y = mesa.tamanho.y / 2 - Bola.raio;    
        
    //colisão com caçapa
    for (int j = 0; j < 6; j++)
    {
      Coord vCB = nBola.pos.sub(mesa.cacapas[j]);
      float magCB = vCB.mag();
      Coord unCB = vCB.div(magCB);
      if (magCB < mesa.cacapaRaio)
      {
        nBola.pos = nBola.pos.soma(unCB.mult(mesa.cacapaRaio - magCB));
        break;
      }
    }
    
    //colisao nBola x bola
    for (int i = 0; i < bolas.length; i++)
    {
      if (bolas[i].estaEmJogo)
      {
        Coord vIB = nBola.pos.sub(bolas[i].pos);
        if (vIB.mag() < Bola.raio * 2)
        {
          posicionandoBolaValido = false;
          break;
        }
      }
    }
    
    bolas[posicionandoBola].pos.def(nBola.pos);
  }

  void reiniciar()
  {
    posicionandoBola = -1;
    posicionandoBolaValido = false;
    novoRecorde = false;
    corridaContraTempoFalhou = false;
    
    tempo = 0f;
    bolas[0].pos.x = -mesa.tamanho.x / 4;
    bolas[0].pos.y = 0.0f;
    
    ArrayList<Coord> posicoes = new ArrayList();
    float x = mesa.tamanho.x / 4;
    float y = 0.0f;
    for (int i = 0; i < 5; i++)
    {
      float yj = y;
      for (int j = 0; j < i + 1; j++)
      {
        posicoes.add(new Coord(x, yj));
        yj += Bola.raio * 2;
      }
      x += cos(PI / 6) * Bola.raio * 2;
      y -= sin(PI / 6) * Bola.raio * 2;
    }
    
    bolas[8].pos = posicoes.get(4);
    posicoes.remove(4);
    
    bolas[1].pos = posicoes.get(0);
    posicoes.remove(0);

    for (int i = 2; i < 8; i++)
    {
      int j = (int)random(posicoes.size() - 0.1);
      bolas[i].pos = posicoes.get(j);
      posicoes.remove(j);
    }
    for (int i = 9; i < 16; i++)
    {
      int j = (int)random(posicoes.size() - 0.1);
      bolas[i].pos = posicoes.get(j);
      posicoes.remove(j);
    }
    for (int i = 0; i < 16; i++)
    {
      bolas[i].vel.def(0.0f, 0.0f);
      bolas[i].estaEmJogo = true;
    }
  }

  @Override
  void atualizar(float dt)
  {
    if (pausa) return;
    tempo += dt;
    dt /= 100;
    for (int passo = 0; passo < 100; passo++)
    {
      boolean semMovimentoTmp = true;
      //atualizar pos com vel e colisao bola x mesa
      for (int i = 0; i < bolas.length; i++)
      {
        if (bolas[i].estaEmJogo && bolas[i].vel.mag() != 0.0f)
        {
          semMovimentoTmp = false;
  
          // atualizar posição e velocidade
          bolas[i].pos = bolas[i].pos.soma(bolas[i].vel.mult(dt));
          bolas[i].vel = bolas[i].vel.unidade().mult(max(0.0f, bolas[i].vel.mag() - mesa.atritoAcel * dt));
          
          // colisão com mesa
          if (mesa.colideComEsq(bolas[i]))
          {
            bolas[i].pos.x = -mesa.tamanho.x / 2 + Bola.raio;
            bolas[i].vel.x = -bolas[i].vel.x;
          }
          else if (mesa.colideComDir(bolas[i]))
          {
            bolas[i].pos.x = mesa.tamanho.x / 2 - Bola.raio;
            bolas[i].vel.x = -bolas[i].vel.x;
          }
          
          if (mesa.colideComSup(bolas[i]))
          {
            bolas[i].pos.y = -mesa.tamanho.y / 2 + Bola.raio;
            bolas[i].vel.y = -bolas[i].vel.y;
          }
          else if (mesa.colideComInf(bolas[i]))
          {
            bolas[i].pos.y = mesa.tamanho.y / 2 - Bola.raio;
            bolas[i].vel.y = -bolas[i].vel.y;
          }
          
          //colisão com caçapa
          for (int j = 0; j < 6; j++)
          {
            if (bolas[i].pos.sub(mesa.cacapas[j]).mag() < mesa.cacapaRaio)
            {
              bolas[i].vel.def(0f, 0f);
              if (i == 0 && modoDeJogo == MODO_CORRIDA_CONTRA_O_TEMPO)
              {
                corridaContraTempoFalhou = true;
                pausa = true;
                aplicacao.abrirPopUp(paginaFimDeJogo);
              }
              bolas[i].estaEmJogo = false;
            }
          }
        }
      }
      
      semMovimento = semMovimentoTmp;
      if (semMovimento)
        break;
      
      //resolver colisao estatica bola x bola
      ArrayList<Integer> colisoes1 = new ArrayList<>();
      ArrayList<Integer> colisoes2 = new ArrayList<>();
      for (int i = 0; i < bolas.length; i++)
      {
        if (bolas[i].estaEmJogo)
        {
          for (int j = i + 1; j < bolas.length; j++)
          {
            if (bolas[j].estaEmJogo)
            {
              Coord ji = bolas[i].pos.sub(bolas[j].pos);
              float jiMag = ji.mag();
              if (jiMag < Bola.raio * 2)
              {
                Coord jiUn = ji.div(jiMag); 
                float corrMag = (Bola.raio - jiMag / 2);
                Coord corr = jiUn.mult(corrMag);
    
                bolas[i].pos = bolas[i].pos.soma(corr);
                bolas[j].pos = bolas[j].pos.sub(corr);
                
                colisoes1.add(i);
                colisoes2.add(j);
              }
            }
          }
        }
      }
      
      //resolver colisoes dinamicas bola x bola
      for (int i = 0; i < colisoes1.size(); i++)
      {
        Bola b1 = bolas[colisoes1.get(i)];
        Bola b2 = bolas[colisoes2.get(i)];
        Coord b1b2Un = b2.pos.sub(b1.pos).unidade();
        float velRelativa = b1.vel.ponto(b1b2Un) - b2.vel.ponto(b1b2Un);
        if (velRelativa > 0f)
        {
          Coord q = b1b2Un.mult(velRelativa);
          b1.vel = b1.vel.sub(q);
          b2.vel = b2.vel.soma(q);
        }
      }
    }
    
    if (modoDeJogo == MODO_CORRIDA_CONTRA_O_TEMPO)
    {
      boolean fimDeJogo = true;
      for (int i = 1; i < bolas.length; i++)
      {
        if (bolas[i].estaEmJogo)
        {
          fimDeJogo = false;
          break;
        }
      }
      if (fimDeJogo)
      {
        pausa = true;
        if (melhorTempo > tempo)
        {
          melhorTempo = tempo;
          novoRecorde = true;
        }
        aplicacao.abrirPopUp(paginaFimDeJogo);
      }
    }
  }
  
  @Override
  void desenhar() {
    background(40,40,40);

    pushMatrix();
    aplicarMatriz();
    
    mesa.desenhar();
  
    //dessenhar bolas
    for (int i = 0; i < bolas.length; i++)
      if (bolas[i].estaEmJogo)
        bolas[i].desenhar(i);
        
    if (ferramenta == FERRAMENTA_JOGAR)
    {
      if (posicionandoBola != -1 && semMovimento)
      {
        bolas[posicionandoBola].desenhar(posicionandoBola, posicionandoBolaValido);
      }
          
      //desenhar tacada
      if (tacadaPreparando)
      {
        Coord mouse = mouseParaMundo();
        Coord bolaMouse = mouse.sub(bolas[0].pos);
        float distBolaMouse = bolaMouse.mag();
        Coord direcao = bolaMouse.div(distBolaMouse);
        
        if (tacadaTrajetoria)
        {
          Coord intercepcao = null;
          Coord trajPosColisaoBolaBranca = null;
          Coord trajPosColisaoBolaX = null;
          Coord bolaX = new Coord();
          
          //calular colisao com bolas
          if (tacadaTrajetoriaColisaoBola)
          {
            float distIntercepcao2 = 0f;

            for (int i = 1; i < bolas.length; i++)
            {
              if (bolas[i].estaEmJogo)
              {
                Coord intercepcaoBolaBola = new Coord();
                if (intercepcaoTrajetoriaBolaBola(direcao, bolas[0].pos, bolas[i].pos, Bola.raio, intercepcaoBolaBola)
                    && (distIntercepcao2 == 0f || intercepcaoBolaBola.sub(bolas[0].pos).mag2() < distIntercepcao2))
                {
                  intercepcao = intercepcaoBolaBola;
                  distIntercepcao2 = intercepcao.sub(bolas[0].pos).mag2();
                  bolaX.def(bolas[i].pos);
                }
              }
            }
            if (intercepcao != null)
            {
              Coord A = bolas[0].pos;
              Coord B = bolaX;
              Coord C = intercepcao;
              Coord uBC = B.sub(C).unidade();
              Coord uAC = C.sub(A).unidade();
              
              trajPosColisaoBolaBranca = uAC.sub(uBC.mult(2f * uAC.ponto(uBC)));
              
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////continuar
            }
          }

          
          //intercepcao com paredes da mesa
          if (intercepcao == null)
          {
            Coord intercepcaoMesa = new Coord();
            
            float[] abc = new float[3];
            abc[0] = direcao.y;
            abc[1] = -direcao.x;
            abc[2] = -abc[0]*bolas[0].pos.x -abc[1]*bolas[0].pos.y;
            
            Coord A = mesa.cantoSupEsq().soma(Bola.raio, Bola.raio);
            Coord B = mesa.cantoSupDir().soma(-Bola.raio, Bola.raio);
            Coord C = mesa.cantoInfDir().soma(-Bola.raio, -Bola.raio);
            Coord D = mesa.cantoInfEsq().soma(Bola.raio, -Bola.raio);
            
            if (
              (intercepcaoRetaReta(abc, pontoPontoRetaABC(A, B), -1, intercepcaoMesa) && intercepcaoMesa.x > A.x && intercepcaoMesa.x < B.x) ||
              (intercepcaoRetaReta(abc, pontoPontoRetaABC(B, C), -1, intercepcaoMesa) && intercepcaoMesa.y > B.y && intercepcaoMesa.y < C.y) ||
              (intercepcaoRetaReta(abc, pontoPontoRetaABC(C, D), -1, intercepcaoMesa) && intercepcaoMesa.x > A.x && intercepcaoMesa.x < B.x) ||
              (intercepcaoRetaReta(abc, pontoPontoRetaABC(D, A), -1, intercepcaoMesa) && intercepcaoMesa.y > B.y && intercepcaoMesa.y < C.y))
            {
              intercepcao = intercepcaoMesa;
            }
          }
          
          //desenhar
          if (intercepcao != null)
          {
            
            stroke(255,255,255,150);
            strokeWeight(0.8);
            noFill();
            circle(intercepcao.x, intercepcao.y, Bola.raio * 2f - 0.8f);
            line(bolas[0].pos.x, bolas[0].pos.y, intercepcao.x, intercepcao.y);
          }
        }
      }
    }
  
    popMatrix();
    
  }
}

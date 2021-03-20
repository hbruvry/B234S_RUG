CellularAutomata   CA, CAFront;
ReactionDiffusion  RD;
MarchingSquare     MS;
boolean            isStarted = true;
int                iteration = 0;
int                iterationStart = 26;

void  init()
{
  PVector caSize;

  caSize = new PVector(1080.f, 540.f);
  CA = new CellularAutomata(30, caSize, "B234/S", color(255, 0, 0), color(0), color(255, 128, 0), color(255, 0));
  RD = new ReactionDiffusion(2, color(255)); 
  MS = new MarchingSquare(2, color(192));
  while (iteration < 26)
  {
    CA.update();
    iteration++;
  }
  RD.updateFromCA(CA);
  return ;
}

void  setup()
{ 
  size(1280, 720);
  init();
  return ;
}

void  draw()
{
  surface.setTitle("PresianRug - Gen" + iteration);
  background(0);
  for (int i = 0; i < 4; i++)
  {
   RD.update();
   RD.swap();
  }
  pushMatrix();
  fill(128);
  translate((width - 1080) / 2, (height - 540) / 2);
  rect(0, 0, 1080, 540);
  popMatrix();
  MS.update(RD);
  MS.display();
  CA.display();
  return ;
}

void keyPressed()
{
  if (key == ' ')
  {
    CA.update();
    RD.updateFromCA(CA);
    iteration++;
  }
  else if (key == ENTER)
    isStarted = !isStarted;
  else if (key == DELETE)
    init();
  return ;
}

CellularAutomata   CARug, CALife;
ReactionDiffusion  RD;
MarchingSquare     MS;
boolean            isStarted = true;
int                iteration = 0;
int                iterationStart = 32;

void  init()
{
  PVector caSize;

  caSize = new PVector(1080.f, 540.f);
  CARug = new CellularAutomata(15, caSize, "B234/S", color(240, 160, 0), color(1, 0), color(204, 128, 0), color(1, 0));
  RD = new ReactionDiffusion(1, color(255)); 
  MS = new MarchingSquare(5, color(16));
  while (iteration < iterationStart)
  {
    CARug.update();
    iteration++;
  }
  RD.updateFromCA(CARug);
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
  surface.setTitle("PresianRug - " + (int)frameRate + "fps");
  background(240);
  for (int i = 0; i < 4; i++)
  {
    RD.update();
    RD.swap();
  }
  CARug.display();
  MS.update(RD);
  MS.display();
  return ;
}

void keyPressed()
{
  if (key == ' ')
  {
    CARug.update();
    RD.updateFromCA(CARug);
    iteration++;
  }
  else if (key == ENTER)
    isStarted = !isStarted;
  else if (key == DELETE)
    init();
  return ;
}

CellularAutomata   CARug, CALife;
ReactionDiffusion  RD;
MarchingSquare     MS;
boolean            isStarted = true;
int                iteration = 0;
int                iterationStart = 32;

void  init()
{
  PVector caSize;

  caSize = new PVector(1920.f, 960.f);
  CARug = new CellularAutomata(30, caSize, "B234/S", color(192), color(1, 0), color(128), color(1, 0));
  RD = new ReactionDiffusion(2, color(255)); 
  MS = new MarchingSquare(2, color(255, 0, 0));
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
  size(1920, 960);
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
  CARug.display();
//  RD.display();
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

CellularAutomata   CA, CAFront;
ReactionDiffusion  RD;
MarchingSquare     MS;
boolean            isStarted = true;
boolean            isFront = false;
int                iteration = 0;
int                iterationStart = 26;

void  init()
{
  PVector caSize;

  caSize = new PVector(1080.f, 540.f);
  CA = new CellularAutomata(30, caSize, "B234/S", color(192), color(0), color(128), color(255, 128, 0));
  CAFront = new CellularAutomata(30, caSize, "B234/S", color(192, 0), color(255), color(255, 0, 0), color(128, 0));
  RD = new ReactionDiffusion(2, color(255)); 
  MS = new MarchingSquare(2, color(255, 0, 0));
  while (iteration < 26)
  {
    CA.update();
    CAFront.update();
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
  CA.display();
  MS.update(RD);
  MS.display();
  if (isFront)
    CAFront.display();
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

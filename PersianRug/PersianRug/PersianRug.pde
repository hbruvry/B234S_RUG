import processing.svg.*;

CellularAutomata   CARug, CALife;
ReactionDiffusion  RD;
MarchingSquare     MS;
boolean            isStarted = true;
boolean            isRecorded = false;
int                iteration = 0;
int                iterationStart = 74;

void  init()
{
  PVector caSize;

  caSize = new PVector(1280.f, 640.f);
  CARug = new CellularAutomata(32, caSize, "B234/S", color(192), color(1, 0), color(128), color(1, 0));
  RD = new ReactionDiffusion(2, color(0, 255, 0)); 
  MS = new MarchingSquare(4, color(255, 0, 0));
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
  size(1280, 640);
  init();
  return ;
}

void  draw()
{
  surface.setTitle("PresianRug - Generation " + iteration + "(" + (int)frameRate + "fps" + ")");
  background(0);

  for (int i = 0; i < 4; i++)
  { 
     RD.swap();
     RD.update();
  }
  if (frameCount == 232)
    isRecorded = true;
  if (isRecorded)
    beginRecord(SVG, "frame-####.svg");
  CARug.display();
  //MS.update(RD);
  //MS.display();
  if (isRecorded)
  {
    endRecord();
    println("svg saved");
    isRecorded = false;
  }
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
  else if (key == 's')
    isRecorded = true;
  else if (key == ENTER)
    isStarted = !isStarted;
  else if (key == DELETE)
    init();
  return ;
}

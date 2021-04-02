import controlP5.*;
import processing.svg.*;

CellularAutomata   CARug, CALife;
ReactionDiffusion  RD;
MarchingSquare     MS;
ControlP5          CP5;
boolean            isStarted = true;
boolean            isRecorded = false;
int                generation = -1;
int                generationStart = 19;
int                iteration = 0;

float      diffusionA = 1.f;
float      diffusionB = 0.5f;
int        iterations = 10;
Slider2D   feed;
Slider2D   kill;

void  setGUI()
{
  int  size = 16;
  
  CP5.addSlider("diffusionA", 0.0f, 2.0f, 1.0f, 16, size, 128, size - 2);
  CP5.addSlider("diffusionB", 0.0f, 2.0f, 0.5f, 16, 2 * size, 128, size - 2);
  CP5.addRange("feed").setPosition(16, 3 * size).setSize(128, size - 2)
  .setRange(0.0f, 1.0f).setRangeValues(0.0f, 1.0f);
  CP5.addRange("kill").setPosition(16, 4 * size).setSize(128, size - 2)
  .setRange(0.0f, 1.0f).setRangeValues(0.0f, 1.0f);
  CP5.addSlider("dt", 0.0, 2.0, 1.0, 16, 5 * size, 128, size - 2);
  CP5.addSlider("iterations", 1, 20, 5, 16, 6 * size, 128, size - 2);
}

void  init()
{
  PVector caSize;

  caSize = new PVector(1380.f, 660.f);
  CARug = new CellularAutomata(30, caSize, "B234/S", color(192), color(1, 0), color(128), color(1, 0));
  RD = new ReactionDiffusion(2, color(0, 255, 0)); 
  MS = new MarchingSquare(4, color(255, 0, 0));
  while (++generation < generationStart)
    CARug.update();
  RD.updateFromCA(CARug);
  setGUI();
  CP5.show();
  return ;
}

void  setup()
{ 
  size(1440, 720);
  CP5 = new ControlP5(this);
  init();
  return ;
}

void  draw()
{
  surface.setTitle("B234/S - GEN" + generation + "ITER" + iteration + "(" + (int)frameRate + "fps" + ")");
  background(0);

  for (int i = 0; i < iterations; i++)
  {
    RD.update();
    RD.swap();
  }
  if (isRecorded)
    beginRecord(SVG, "frame-####.svg");
  CARug.display();
  //RD.display();
  //MS.update(RD);
  //MS.display();
  if (isRecorded)
  {
    endRecord();
    println("SVG saved");
    isRecorded = false;
  }
  iteration++;
  return ;
}

void keyPressed()
{
  if (key == ' ')
  {
    CARug.update();
    RD.updateFromCA(CARug);
    generation++;
  }
  else if (key == 's')
    isRecorded = true;
  else if (key == ENTER)
    isStarted = !isStarted;
  else if (key == DELETE)
  {
    generation = 0;
    iteration = 0;
    init();
  }
  return ;
}

CellularAutomata   CA;
ReactionDiffusion  RD;
MarchingSquare     MS;

void  setup()
{
  size(1280, 720);
  CA = new CellularAutomata(30, "B234/S", 1080, 540);
  for (int i = 0; i < 40; i++)
    CA.update();
  RD = new ReactionDiffusion(2, CA);
  MS = new MarchingSquare(2);
  return ;
}

void  draw()
{
  surface.setTitle("PresianRug - " + (int)frameRate + "fps");
  background(192);
  for (int i = 0; i < 4; i++)
  {
   RD.update();
   RD.swap();
  }
  CA.display();
  RD.display();
  MS.update(RD);
  MS.display();
  return ;
}

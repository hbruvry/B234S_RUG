CellularAutomata   CA;
ReactionDiffusion  RD;

void  setup()
{
  size(1920, 1080, P3D);
  CA = new CellularAutomata(30, "B234/S", 1440, 720);
  for (int i = 0; i < 128; i++)
    CA.update();
  RD = new ReactionDiffusion(5, CA);
  for (int i = 0; i < 1024; i++)
  {
   RD.update();
   RD.swap();
  }
  return ;
}

void  draw()
{
  background(192);
  surface.setTitle("PresianRug - " + (int)frameRate + "fps");
  RD.display();
  CA.display();
  stroke(0, 0, 255);
  line(0, height / 2, width, height / 2);
  line(width / 2, 0, width / 2, height);
  return ;
}

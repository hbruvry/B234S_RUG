CellularAutomata   CA;
ReactionDiffusion  RD;

void  setup()
{
  size(1280, 720);
  CA = new CellularAutomata(30, "B234/S", 1080, 540);
  for (int i = 0; i < 24; i++)
    CA.update();
  RD = new ReactionDiffusion(5, CA);
  for (int i = 0; i < 512; i++)
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

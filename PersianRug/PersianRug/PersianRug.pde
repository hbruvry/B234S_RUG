CellularAutomata   CA;
ReactionDiffusion  RD;

void  setup()
{
  size(1280, 720);
  CA = new CellularAutomata(20, "B234/S");
  for (int i = 0; i < 120; i++)
    CA.update();
  RD = new ReactionDiffusion(CA.cells, CA.cellSize);
  return ;
}

void  draw()
{
  background(192);
  RD.update();
  RD.draw();
  RD.swap();
  return ;
}

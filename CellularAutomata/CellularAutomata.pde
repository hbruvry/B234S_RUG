import processing.svg.*;

// A fork of John Conway's Game of Life CA by Daniel Shiffman. 

Automata  CARug;
Automata  CAMove;
Automata  CALife;
int       Generation = 0;

/*
** Useful rules :
** Flock - B3/S12,
** B3/S2,
** EightLife - B3/S238,
** Holstein - B35678/S4678,
** Morley - B368/S245
** Selected - B37/S23
*/

void  init()
{
  CARug.init(false, 0.f);
  CALife.init(true, 0.125f);
  return ;
}

void  setup()
{
  size(1280, 720);
  CARug = new Automata(5, "B234/S", color(4, 12, 140), color(160, 168, 208), color(80, 88, 160));
  CALife = new Automata(5, "B37/S23", color(240, 96, 4), color(240, 128, 4), color(240, 128, 4));
  init();
  return ;
}

void  draw()
{ 
  surface.setTitle("Generation = " + Generation);
  background(167, 169, 217);
  CARug.displayBoth(CALife.cells);
  return ;
}

void keyPressed()
{
  if (key == ' ')
  {
    CARug.updateCellsState();
    CALife.updateCellsState();
    CARug.updateBothCellsOrientation(CALife.cells);
    CARug.updateCellsShape();
    CALife.updateCellsShape();
    Generation++;
  }
  else if (key == 's')
  {
    beginRecord(SVG, "frame-####.svg");
    CARug.displayBoth(CALife.cells);
    endRecord();
  }
  else if (key == 'r')
    init();
  return ;
}

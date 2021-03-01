// A fork of John Conway's Game of Life CA by Daniel Shiffman. 
Automata  CARug;
Automata  CAMove;
Automata  CALife;
int       Generation = 0;
PShape[]  Modules;

void  setup()
{
//80, 40
  size(1280, 768);
  CARug = new Automata(16, "B234/S", color(4, 12, 140), color(160, 168, 208), color(80, 88, 160));
  //Flock - B3/S12, B3/S2, EightLife - B3/S238, Holstein - B35678/S4678, Morley - B368/S245 B37/S23
  CALife = new Automata(32, "B234/S", color(240, 96, 4), color(240, 128, 4), color(240, 128, 4));
  CARug.init(false, 0.f);
  CALife.init(true, 0.125f);
  Modules = new PShape[16];
  for (int i = 0; i < Modules.length; i++)
  { 
    Modules[i] = loadShape("S_" + nf(i, 2) + ".svg");
    Modules[i].disableStyle();
  }
  return ;
}

// 32, 48, 82, 104

void  draw()
{ 
  surface.setTitle("Generation = " + Generation);
  background(167, 169, 217);
  stroke(255);
  line(0, height / 2, width, height / 2);
  line(width / 2, 0, width / 2, height);
  CARug.display();
  CALife.display();
  return ;
}

void keyPressed()
{
  if (key == ' ')
  {
    CARug.update();
    CALife.update();
    Generation++;
  }
  else if (key == 'r')
  {
    CALife.init(false, 0);
    CALife.init(true, 0.125f);
    Generation = 0;
  }
  else if (key == 's')
  {
//    beginRecord(SVG, "Rug" + Generation + ".svg");
    CARug.display();
    CALife.display();
//    endRecord();
  }
  return ;
}

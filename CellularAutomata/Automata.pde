class Automata
{
  int       cellSize;
  int       columns, rows;
  PVector   offset;
  Cell[][]  cells;
  
  String    rule;
  int[]     ruleBorn = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  int[]     ruleStasis = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  
  color     colorBorn;
  color     colorStasis;
  color     colorDeath;
  
  Automata(int cellSize_, String rule_, color colorBorn_, color colorStasis_, color colorDeath_)
  {
    cellSize = cellSize_;
    columns = width / cellSize;
    rows = height / cellSize;
    offset = new PVector(-1.f - columns % 2.f, 1 - rows % 2.f).div(2.f);
    cells = new Cell[rows][columns];
    rule = rule_;
    colorBorn = colorBorn_;
    colorStasis = colorStasis_;
    colorDeath = colorDeath_;
    return ;
  }

  /*
  ** if (abs(i - columns / 2.f + 0.5f) + abs(j - rows / 2.f + 0.5f) > Generation + 4)
  **   if (random(1.f) < 0.75f - (float)sqrt(pow(i - columns / 2.f + 0.5f, 2.f) + pow(j - rows / 2.f + 0.5f, 2.f)) / (columns / 1.5f))
  */

  void  init(boolean isRandom, float randomness)
  {
    PVector  position;
    
    setRule(rule);
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        position = new PVector((float)j * cellSize, (float)i * cellSize);
        cells[i][j] = new Cell(position, (float)cellSize, colorBorn, colorStasis, colorDeath);
        if (isRandom)
        {
          if (random(1.f) < randomness)
            cells[i][j].setState(1);
        }
        else if (getNeumannDist(j, i) < 2 && (columns / 2 - 1 <= j && j <= columns / 2))
          cells[i][j].setState(1);
        else if (i % (rows - 1) == 0 && (j < 1 || columns - 2 < j))
          cells[i][j].setState(1);
      }
    return ;
  }

  void  setRule(String str)
  {
    int   index;
    
    index = 0;
    if (str.length() == 0 || !str.substring(0, 1).equals("B"))
      return ;
    for (int i = 0; i < 9; i++)
    {
      ruleBorn[i] = 0;
      ruleStasis[i] = 0;
    }
    while (++index < str.length() && !str.substring(index, index + 1).equals("/"))
      SetRuleState(str.substring(index, index + 1), ruleBorn);
    if (str.length() < index + 1 || !str.substring(index + 1, index + 2).equals("S"))
      return ;
    for (int i = index + 2; i < str.length(); i++)
      SetRuleState(str.substring(i, i + 1), ruleStasis);
    return ;
  }

  void  SetRuleState(String str, int[] rule)
  {
      if (str.equals("0"))       rule[0] = 1;  
      else if (str.equals("1"))  rule[1] = 1;
      else if (str.equals("2"))  rule[2] = 1;
      else if (str.equals("3"))  rule[3] = 1;
      else if (str.equals("4"))  rule[4] = 1;
      else if (str.equals("5"))  rule[5] = 1;
      else if (str.equals("6"))  rule[6] = 1;
      else if (str.equals("7"))  rule[7] = 1;
      else if (str.equals("8"))  rule[8] = 1;
      return ;
  }

  float  getNeumannDist(int x, int y)
  {
    float    distance;
    
    distance = abs(x - columns / 2.f - offset.x) + abs(y - rows / 2.f + offset.y);
    return (distance);
  }
  
  float  getDist(int x, int y)
  {
    float distance;
    
    distance = sqrt(pow(x - columns / 2.f + offset.x, 2.f) + pow(y - rows / 2.f + offset.y, 2.f));
    return (distance);
  }

  int   getNeighbors(int x, int y)
  {
    int   neighbors;
    
    neighbors = 0;
    for (int i = -1; i <= 1; i++)
      for (int j = -1; j <= 1; j++)
        neighbors += cells[(y + j + rows) % rows][(x + i + columns) % columns].prevState;
    neighbors -= cells[y][x].prevState;
    return (neighbors);
  }

  int   getStateFromRule(int state, int neighbors)
  {
    if ((state == 0) && (ruleBorn[neighbors] == 1))
      return(1);
    else if ((state == 1) && (ruleStasis[neighbors] == 0))
      return(0);
    return(state);
  }

  int  getBinaryState(int x, int y)
  {
    String  binaryResult;
    
    binaryResult = "";
    if (cells[y][x].state == 1)
    {
      if (cells[(y - 1 + rows) % rows][(x + columns) % columns].state == 1)  binaryResult = "1";
      else binaryResult = "0";
      if (cells[(y + rows) % rows][(x - 1 + columns) % columns].state == 1)  binaryResult += "1";
      else binaryResult += "0";
      if (cells[(y + 1 + rows) % rows][(x + columns) % columns].state == 1)  binaryResult += "1";
      else binaryResult += "0";
      if (cells[(y + rows) % rows][(x + 1 + columns) % columns].state == 1)  binaryResult += "1";
      else binaryResult += "0";
      return (unbinary(binaryResult));
    }
    return (cells[y][x].binaryState);
  }
  
  void  update()
  {
    int  neighbors;
    int  state;
    
    state = 0;
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].savePreviousState();
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        neighbors = getNeighbors(j, i);
        state = getStateFromRule(cells[i][j].state, neighbors);
        cells[i][j].setState(state);
      }
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].setBinaryState(getBinaryState(j, i));
    return ;
  }
  
  /*
  ** if (Generation + 2 < abs(i - columns / 2.f + 0.5f) + abs(j - rows / 2.f + 0.5f)
  **   && abs(i - columns / 2.f + 0.5f) + abs(j - rows / 2.f + 0.5f) <= Generation + 4  && Generation < 24)
  */

  void  display()
  {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].display();
    return ;
  }
}

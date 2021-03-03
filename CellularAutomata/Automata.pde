class Automata
{
  int       cellSize;
  int       columns, rows;
  PVector   offset;
  Cell[][]  cells;
  
  String    rule;
  int[]     ruleBorn = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  int[]     ruleStasis = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  
  color     colorBorn, colorStasis, colorDeath;
  
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
  ** Cellar Automata initialization functions
  */
  
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
            cells[i][j].state = 1;
        }
        else if ((rows / 2 - 1 <= i && i <= rows / 2) && (columns / 2 - 1 <= j && j <= columns / 2))
          cells[i][j].state = 1;
        else if (i % (rows - 1) == 0 && (j < 1 || columns - 2 < j))
          cells[i][j].state = 1;
      }
    return ;
  }

  /*
  ** Cellar Automata update functions
  */

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
  
  String  getBinaryState(int x, int y)
  {
    String  binaryState;
    
    binaryState = "";
    if (cells[(y - 1 + rows) % rows][(x + columns) % columns].isActive() == 1)  binaryState = "1";
    else binaryState = "0";
    if (cells[(y + rows) % rows][(x - 1 + columns) % columns].isActive() == 1)  binaryState += "1";
    else binaryState += "0";
    if (cells[(y + 1 + rows) % rows][(x + columns) % columns].isActive() == 1)  binaryState += "1";
    else binaryState += "0";
    if (cells[(y + rows) % rows][(x + 1 + columns) % columns].isActive() == 1)  binaryState += "1";
    else binaryState += "0";
    return (binaryState);
  }
  
  void  updateCellsState()
  {
    int  neighbors;
    
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].prevState = cells[i][j].state;
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        neighbors = getNeighbors(j, i);
        if (cells[i][j].state == 0 && ruleBorn[neighbors] == 1)
          cells[i][j].state = 1;
        else if (cells[i][j].state == 1 && ruleStasis[neighbors] == 0)
          cells[i][j].state = 0;
      }
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].binaryState = getBinaryState(j, i);
  }
  
  void  updateBothCellsOrientation(Cell[][] cellsIn)
  {
    PVector orientation;
    
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        orientation = cells[i][j].getOrientationFromBinaryState();
        orientation.lerp(cellsIn[i][j].getOrientationFromBinaryState(), 0.5f);
        if (orientation.magSq() > 0.001f)
          orientation.normalize();
        cells[i][j].orientation = orientation;
        cellsIn[i][j].orientation = orientation;
      }
    return;
  }
  
  void  mergeCellsOrientation(Cell[][] cellsIn)
  {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        cells[i][j].orientation.lerp(cellsIn[i][j].orientation, 0.5f);
      }
    return;
  }
  
  void  updateCellsShape()
  {
    PVector vec, vecZero;
    
    vec = new PVector(0.f, 0.f);
    vecZero = new PVector(0.f, 0.f);
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].resetShape();
    for (int i = 0; i < rows - 1; i++)
      for (int j = 0; j < columns - 1; j++)
      {
        vec = new PVector(0.f, 0.f);
        for (int k = 0; k <= 1; k++)
          for (int l = 0; l <= 1; l++)
            vec.add(cells[i + k][j + l].orientation);
        vec.div(4.f);
        vec.mult(-cellSize);
        cells[i][j].morphShape(vecZero.copy(), vecZero.copy(), vec.copy(), vecZero.copy());
        cells[i][j + 1].morphShape(vecZero.copy(), vecZero.copy(), vecZero.copy(), vec.copy());
        cells[i + 1][j + 1].morphShape(vec.copy(), vecZero.copy(), vecZero.copy(), vecZero.copy());
        cells[i + 1][j].morphShape(vecZero.copy(), vec.copy(), vecZero.copy(), vecZero.copy());
      }
    return ;
  }
  
  /*
  ** if (Generation + 2 < abs(i - columns / 2.f + 0.5f) + abs(j - rows / 2.f + 0.5f)
  **   && abs(i - columns / 2.f + 0.5f) + abs(j - rows / 2.f + 0.5f) <= Generation + 4  && Generation < 24)
  */

  void  displayBoth(Cell[][] cellsIn)
  {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        if (cellsIn[i][j].prevState == 0 && cellsIn[i][j].state == 0)
          cells[i][j].display();
        else
          cellsIn[i][j].display();
        //cells[i][j].displayDebug();
      }
    return ;
  }
  
  void  display()
  {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].display();
    return ;
  }
}

class  CACell
{
  int    statePrev, state;
  String stateBinary;
  
  CACell()
  {
    statePrev = 0;
    state = 0;
    stateBinary = "";
    return ;
  }
  
  int  isActive()
  {
    if (statePrev == 1 || state == 1)
      return(1);
    return(0);
  }
}

class  CellularAutomata
{
  int         cellSize;
  int         cellsWidth, cellsHeight;
  int         columns, rows;
  CACell[][]  cells;
  
  int[]       ruleBorn = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  int[]       ruleStasis = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  color       colorBorn, colorStasis, colorDeath, colorNull;
  
  CellularAutomata(int cellSize_, PVector caSize, String rule, color colorBorn_, color colorStasis_, color colorDeath_, color colorNull_)
  {
    cellSize =    cellSize_;
    cellsWidth =  (int)caSize.x;
    cellsHeight = (int)caSize.y;
    columns =     cellsWidth / cellSize;
    rows =        cellsHeight / cellSize;
    cells =       new CACell[rows][columns];
    colorBorn =   colorBorn_;
    colorStasis = colorStasis_;
    colorDeath =  colorDeath_;
    colorNull =   colorNull_;
    init(rule);
    return ;
  }
  
  void  init(String rule)
  {
    setRule(rule);
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        cells[i][j] = new CACell();
        if (!rule.equals("B234/S"))
        {
          if (random(0.f, 1.f) < 0.125f)
            cells[i][j].state = 1;
        }
        else if ((rows / 2 - 1 <= i && i <= rows / 2)
                && (columns / 2 - 1 <= j && j <= columns / 2))
          cells[i][j].state = 1;
        else if (i % (rows - 1) == 0 && (j == 0 || columns - 1 == j))
          cells[i][j].state = 1;
      }
    return ;
  }
  
  void  setRuleState(String str, int[] rule)
  {
    for (int i = 0; i < 9; i++)
      if (str.equals(str(i)))
        rule[i] = 1;
    return ;
  }
  
  void  setRule(String str)
  {
    int   index;
    
    index = 0;
    for (int i = 0; i < 9; i++)
      ruleBorn[i] = ruleStasis[i] = 0;
    while (++index < str.length() && !str.substring(index, index + 1).equals("/"))
      setRuleState(str.substring(index, index + 1), ruleBorn);
    for (int i = index + 2; i < str.length(); i++)
      setRuleState(str.substring(i, i + 1), ruleStasis);
    return ;
  }
  
  int   getNeighbors(int x, int y)
  {
    int   neighbors;
    
    neighbors = 0;
    for (int i = -1; i <= 1; i++)
      for (int j = -1; j <= 1; j++)
        neighbors += cells[(y + j + rows) % rows][(x + i + columns) % columns].statePrev;
    neighbors -= cells[y][x].statePrev;
    return (neighbors);
  }
  
  String  getBinaryState(int x, int y)
  {
    int     i, j;
    String  binaryState;
    
    i = y + rows;
    j = x + columns;
    binaryState = "";
    binaryState = (cells[(i - 1) % rows][j % columns].isActive() == 1) ? "1" : "0";
    binaryState = (cells[i % rows][(j - 1) % columns].isActive() == 1) ? "1" : "0";
    binaryState = (cells[(i + 1) % rows][j % columns].isActive() == 1) ? "1" : "0";
    binaryState = (cells[i % rows][(j + 1) % columns].isActive() == 1) ? "1" : "0";
    return (binaryState);
  }
  
  void  update()
  {
    int  neighbors;
    
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        cells[i][j].statePrev = cells[i][j].state;
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
        cells[i][j].stateBinary = getBinaryState(j, i);
    return ;
  }
  
  void  display()
  {
    noStroke();
    pushMatrix();
    translate((width - cellsWidth) / 2, (height - cellsHeight) / 2);
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        if (cells[i][j].statePrev == 1 || cells[i][j].state == 1)
          {
            if (cells[i][j].statePrev == 0)
              fill(colorBorn);
            else if (cells[i][j].state == 0)
              fill(colorDeath);
            else
              fill(colorStasis);
          }
        else
          fill(colorNull);
        rect (j * cellSize, i * cellSize, cellSize, cellSize);
      }
    popMatrix();
    return ;
  }
}

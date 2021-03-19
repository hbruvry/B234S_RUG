class  CellularAutomata
{
  int         cellSize;
  int         columns, rows;
  CACell[][]  cells;
  
  int[]       ruleBorn = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  int[]       ruleStasis = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  
  CellularAutomata(int cellSize_, String rule)
  {
    cellSize = cellSize_;
    columns = width / cellSize;
    rows = height / cellSize;
    cells = new CACell[rows][columns];
    init();
    setRule(rule);
    return ;
  }
  
  void  init()
  {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        cells[i][j] = new CACell();
        if ((rows / 2 - 1 <= i && i <= rows / 2) && (columns / 2 - 1 <= j && j <= columns / 2))
          cells[i][j].state = 1;
        else if (i % (rows - 1) == 0 && (j < 1 || columns - 2 < j))
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
    if (str.length() == 0 || !str.substring(0, 1).equals("B"))
      return ;
    for (int i = 0; i < 9; i++)
    {
      ruleBorn[i] = 0;
      ruleStasis[i] = 0;
    }
    while (++index < str.length() && !str.substring(index, index + 1).equals("/"))
      setRuleState(str.substring(index, index + 1), ruleBorn);
    if (str.length() < index + 1 || !str.substring(index + 1, index + 2).equals("S"))
      return ;
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
    return ;
  }
}
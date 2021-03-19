class  ReactionDiffusion
{
  int         cellSize;
  int         columns, rows;
  RDCell[][]  cellsPrev;
  RDCell[][]  cells;
  float  diffusionA = 0.2097f;
  float  diffusionB = 0.1050f;
  float  feed = 0.0290f;
  float  kill = 0.0570f;
  
  ReactionDiffusion(int cellSize_, CellularAutomata ca)
  {
    cellSize = cellSize_;
    columns = width / cellSize;
    rows = height / cellSize;
    println(columns);
    println(rows);
    cellsPrev = new RDCell[rows][columns];
    cells = new RDCell[rows][columns];
    init(ca);
    return ;
  }
  
  void  init(CellularAutomata ca)
  {
    int    k, l;
    float  offsetX, offsetY;
    float  state;
    
    offsetX = (width - ca.columns * ca.cellSize) / 2.f;
    offsetY = (height - ca.rows * ca.cellSize) / 2.f;
    println(offsetX);
    println(offsetY);
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        k = (int)((i * cellSize - offsetY) / ca.cellSize);
        l = (int)((j * cellSize - offsetX) / ca.cellSize);
        state = 0.f;
        if ((offsetY - cellSize < i * cellSize && i * cellSize < height - offsetY)
            && (offsetX < j * cellSize && j * cellSize < width - offsetX))
          if (ca.cells[k][l].state == 0.f && ca.cells[k][l].statePrev == 0.f)
            state = 1.f;
        cellsPrev[i][j] = new RDCell(1.f, state);
        cells[i][j] = new RDCell(1.f, state);
      }
    return ;
  }
  
  void  swap()
  {
    RDCell[][]  tmpCells;
    
    tmpCells = cellsPrev;
    cellsPrev = cells;
    cells = tmpCells;
    return ;
  }
  
  float laplaceA(int i, int j)
  {
    float  sumA;
    
    sumA = -cellsPrev[i][j].a;
    sumA += cellsPrev[i][j - 1].a * 0.2f;
    sumA += cellsPrev[i][j + 1].a * 0.2f;
    sumA += cellsPrev[i + 1][j].a * 0.2f;
    sumA += cellsPrev[i - 1][j].a * 0.2f;
    sumA += cellsPrev[i - 1][j - 1].a * 0.05f;
    sumA += cellsPrev[i - 1][j + 1].a * 0.05f;
    sumA += cellsPrev[i + 1][j + 1].a * 0.05f;
    sumA += cellsPrev[i + 1][j - 1].a * 0.05f;
    return (sumA);
  }
  
  float laplaceB(int i, int j)
  {
    float  sumB;
    
    sumB = -cellsPrev[i][j].b;
    sumB += cellsPrev[i][j - 1].b * 0.2f;
    sumB += cellsPrev[i][j + 1].b * 0.2f;
    sumB += cellsPrev[i + 1][j].b * 0.2f;
    sumB += cellsPrev[i - 1][j].b * 0.2f;
    sumB += cellsPrev[i - 1][j - 1].b * 0.05f;
    sumB += cellsPrev[i - 1][j + 1].b * 0.05f;
    sumB += cellsPrev[i + 1][j + 1].b * 0.05f;
    sumB += cellsPrev[i + 1][j - 1].b * 0.05f;
    return (sumB);
  }
  
  void  update()
  {
    float  a, b;
    
    for (int i = 1; i < rows - 1; i++)
      for (int j = 1; j < columns - 1; j++)
      {
        a = cellsPrev[i][j].a;
        b = cellsPrev[i][j].b;
        cells[i][j].a = a + diffusionA * laplaceA(i, j) - a * b * b + feed * (1.f - a);
        cells[i][j].b = b + diffusionB * laplaceB(i, j) + a * b * b - (kill + feed) * b;
        cells[i][j].a = constrain(cells[i][j].a, 0.f, 1.f);
        cells[i][j].b = constrain(cells[i][j].b, 0.f, 1.f);
      }
    return ;
  }
  
  void  display()
  {
    float  intensity;
    
    for (int i = 1; i < rows - 1; i++)
      for (int j = 1; j < columns - 1; j++)
      {
        intensity = cells[i][j].a - cells[i][j].b;
        noStroke();
        fill(255, 0, 0);
        if (intensity < 0.5f)
          rect(j * cellSize, i * cellSize, cellSize, cellSize);
      }
  }
}

class  RDCell
{
  float  a, b;
  
  RDCell(float a_, float b_)
  {
    a = a_;
    b = b_;
    return ;
  }
}

class  ReactionDiffusion
{
  int        cellSize;
  int        columns, rows;
  RDCell[][] cellsPrev;
  RDCell[][] cells;
  PVector    caOffset;
  float      caCellSize;
  
  float      diffusionA = 1.f;
  float      diffusionB = 0.5f;
  float      feed = 0.055f;
  float      kill = 0.062f;
  color      colorRD;
  
  ReactionDiffusion(int cellSize_, color colorRD_)
  {
    cellSize =   cellSize_;
    columns =    width / cellSize;
    rows =       height / cellSize;
    cellsPrev =  new RDCell[rows][columns];
    cells =      new RDCell[rows][columns];
    colorRD =    colorRD_;
    caOffset =   new PVector(0.f, 0.f);
    caCellSize = 1.f;
    init();
    return ;
  }
  
  void  init()
  {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        cellsPrev[i][j] = new RDCell(1.f, 0.f);
        cells[i][j] = new RDCell(1.f, 0.f);
      }
    return ;
  }
  
  void  updateFromCA(CellularAutomata ca)
  {
    float  state;
    
    caCellSize = ca.cellSize;
    caOffset.x = (width - ca.columns * caCellSize) / 2.f;
    caOffset.y = (height - ca.rows * caCellSize) / 2.f;
    for (int i = 0; i < rows; i++)
      for (int j = 0, k = 0, l = 0; j < columns; j++)
      {
        state = 0.f;
        k = (int)((i * cellSize - caOffset.y) / caCellSize);
        l = (int)((j * cellSize - caOffset.x) / caCellSize);
        if ((caOffset.y <= i * cellSize && i * cellSize < height - caOffset.y)
            && (caOffset.x <= j * cellSize && j * cellSize < width - caOffset.x))
        {
          if (ca.cells[k][l].state == 1 && new PVector(j * cellSize + cellSize / 2.f, i * cellSize + cellSize / 2.f).dist(new PVector(l * caCellSize + caCellSize / 2.f + caOffset.x, k * caCellSize + caCellSize / 2.f + caOffset.y)) < 1)
            state = 1.f;
        }
        cellsPrev[i][j] = new RDCell(1.f, state);
        cells[i][j] = new RDCell(1.f, state);
      }
    return ;
  }
  
  void  swap()
  {
    RDCell[][]  tmpCells;
    
    tmpCells =  cellsPrev;
    cellsPrev = cells;
    cells =     tmpCells;
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
    float  k, l;
    
    for (int i = 1; i < rows - 1; i++)
      for (int j = 1; j < columns - 1; j++)
      {
        k = (float)(i * cellSize - caOffset.y) / caCellSize;
        l = (float)(j * cellSize - caOffset.x) / caCellSize;
        k = constrain(k / ((height - caOffset.y * 2.f) / caCellSize), 0.f, 1.f);
        l = constrain(l / ((width - caOffset.x * 2.f) / caCellSize), 0.f, 1.f);
        feed = map(l, 0.f, 1.f, 0.025f, 0.015f);
        kill = map(k, 0.f, 1.f, 0.050f, 0.055f);
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
    
    noStroke();
    fill(colorRD);
    for (int i = 1; i < rows - 1; i++)
      for (int j = 1; j < columns - 1; j++)
      {
        intensity = cells[i][j].a - cells[i][j].b;
        if (intensity < 0.5f)
          rect(j * cellSize, i * cellSize, cellSize, cellSize);
      }
    return ;
  }
}
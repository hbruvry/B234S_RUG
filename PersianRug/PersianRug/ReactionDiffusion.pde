class  ReactionDiffusion
{
  RDCell[][]  cellsPrev;
  RDCell[][]  cells;
  float  dA = 0.2097f;
  float  dB = 0.1050f;
  float  feed = 0.098f;
  float  k = 0.0555f;
  
  ReactionDiffusion(CACell[][] cellsIn, int cellSize)
  {
    cellsPrev = new RDCell[height][width];
    cells = new RDCell[height][width];
    init(cellsIn, cellSize);
    return ;
  }
  
  void  init(CACell[][] cellsIn, int cellSize)
  {
    for (int i = 0; i < height; i++)
      for (int j = 0; j < width; j++)
      {
        cellsPrev[i][j] = new RDCell(1.f, (float)cellsIn[i / cellSize][j / cellSize].state);
        cells[i][j] = new RDCell(1.f, (float)cellsIn[i / cellSize][j / cellSize].state);
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
    
    for (int i = 1; i < height - 1; i++)
      for (int j = 1; j < width - 1; j++)
      {
        a = cellsPrev[i][j].a;
        b = cellsPrev[i][j].b;
        cells[i][j].a = a + dA * laplaceA(i, j) - a * b * b + feed * (1.f - a);
        cells[i][j].b = b + dB * laplaceB(i, j) + a * b * b - (k + feed) * b;
        cells[i][j].a = constrain(cells[i][j].a, 0.f, 1.f);
        cells[i][j].b = constrain(cells[i][j].b, 0.f, 1.f);
      }
    return ;
  }
  
  void  draw()
  {
    RDCell  cell;
    
    loadPixels();
    for (int i = 1; i < height - 1; i++)
      for (int j = 1; j < width - 1; j++)
      {
        cell = cells[i][j];
        pixels[i * width + j] = color((cell.a - cell.b) * 255);
      }
    updatePixels();
  }
}

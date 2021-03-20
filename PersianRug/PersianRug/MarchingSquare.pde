class  MarchingSquare
{
  int    resolution;
  int    columns, rows;
  float  field[][];
  
  MarchingSquare(int resolution_)
  {
    resolution = resolution_;
    columns = width / resolution;
    rows = height / resolution;
    field = new float[rows][columns];
    return ;
  }
  
  void  update(ReactionDiffusion rd)
  {
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
      {
        field[i][j] = rd.cells[i][j].a - rd.cells[i][j].b;
        //stroke(field[i][j] * 255, field[i][j] * 255, 0);
        //rect(j * resolution, i * resolution, resolution, resolution);
      }
    return ;
  }
  
  int   getState(float fieldA, float fieldB, float fieldC, float fieldD)
  {
    return ((fieldA > 0 ? 8 : 0) + (fieldB > 0 ? 4 : 0) + (fieldC > 0 ? 2 : 0) + (fieldD > 0 ? 1 : 0));
  }
  
  void  drawLine(PVector posStart, PVector posEnd)
  {
    stroke(0, 0, 255);
    strokeWeight(2);
    line(posStart.x, posStart.y, posEnd.x, posEnd.y);
    return ;
  }
  
  void  display()
  {
    float    h;
    float    fieldA, fieldB, fieldC, fieldD;
    PVector  posA, posB, posC, posD;
    int      x, y;
    
    h = 0.5f;
    for (int i = 0; i < rows - 1; i++)
      for (int j = 0; j < columns - 1; j++)
      {
        fieldA = field[i][j] - h;
        fieldB = field[i][j + 1] - h;
        fieldC = field[i + 1][j + 1] - h;
        fieldD = field[i + 1][j] - h;
        x = j * resolution;
        y = i * resolution;
        posA = new PVector(x + resolution * fieldA / (fieldA - fieldB), y);
        posB = new PVector(x + resolution, y + resolution * fieldB / (fieldB - fieldC));
        posC = new PVector(x + resolution * (1.f - fieldC / (fieldC - fieldD)), y + resolution);
        posD = new PVector(x, y + resolution * (1.f - fieldD / (fieldD - fieldA)));
        switch (getState(fieldA, fieldB, fieldC, fieldD)) {
        case 1:
          drawLine(posC, posD);
          break;
        case 2:
          drawLine(posB, posC);
          break;
        case 3:
          drawLine(posB, posD);
          break;
        case 4:
          drawLine(posA, posB);
          break;
        case 5:
          drawLine(posA, posD);
          drawLine(posB, posC);
          break;
        case 6:
          drawLine(posA, posC);
          break;
        case 7:
          drawLine(posA, posD);
          break;
        case 8:
          drawLine(posA, posD);
          break;
        case 9:
          drawLine(posA, posC);
          break;
        case 10:
          drawLine(posA, posB);
          drawLine(posC, posD);
          break;
        case 11:
          drawLine(posA, posB);
          break;
        case 12:
          drawLine(posB, posD);
          break;
        case 13:
          drawLine(posB, posC);
          break;
        case 14:
          drawLine(posC, posD);
          break;
        }
      }
  }
}

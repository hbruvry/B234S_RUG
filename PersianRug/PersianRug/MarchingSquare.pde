class  MarchingSquare
{
  int    resolution;
  int    columns, rows;
  float  field[][];
  color  colorMS;
  
  MarchingSquare(int resolution_, color colorMS_)
  {
    resolution = resolution_;
    columns =    width / resolution + 1;
    rows =       height / resolution + 1;
    field =      new float[rows][columns];
    colorMS =    colorMS_;
    return ;
  }
  
  void  update(ReactionDiffusion rd)
  {
    float  ratio;
    
    ratio = (float)resolution / rd.cellSize;
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        if (i < rows - 1 && j < columns - 1)
          field[i][j] = rd.cells[(int)(i * ratio)][(int)(j * ratio)].b - rd.cells[(int)(i * ratio)][(int)(j * ratio)].a;
        else
          field[i][j] = -0.5f;
    return ;
  }
  
  int   getState(float fieldA, float fieldB, float fieldC, float fieldD)
  {
    int  state;
    
    state = (fieldA > 0 ? 8 : 0) + (fieldB > 0 ? 4 : 0) + (fieldC > 0 ? 2 : 0) + (fieldD > 0 ? 1 : 0);
    return (state);
  }
  
  void  drawLine(PVector posStart, PVector posEnd)
  {
    stroke(0, 0, 255);
    strokeWeight(1);
    line(posStart.x, posStart.y, posEnd.x, posEnd.y);
    return ;
  }
  
  void  display()
  {
    float    h;
    float    fieldA, fieldB, fieldC, fieldD;
    PVector  posA, posB, posC, posD;
    PVector  posE, posF, posG, posH;
    int      x, y;
    
    h = -0.5f;
    noStroke();
    fill(colorMS);
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
        posE = new PVector (x, y);
        posF = new PVector (x + resolution, y);
        posG = new PVector (x + resolution, y + resolution);
        posH = new PVector (x, y + resolution);
        beginShape();
        switch (getState(fieldA, fieldB, fieldC, fieldD))
        {
          case 1:
            vertex(posC.x, posC.y);
            vertex(posH.x, posH.y);
            vertex(posD.x, posD.y);
            break;
          case 2:
            vertex(posB.x, posB.y);
            vertex(posG.x, posG.y);
            vertex(posC.x, posC.y);
            break;
          case 3:
            vertex(posB.x, posB.y);
            vertex(posG.x, posG.y);
            vertex(posH.x, posH.y);
            vertex(posD.x, posD.y);
            break;
          case 4:
            vertex(posA.x, posA.y);
            vertex(posF.x, posF.y);
            vertex(posB.x, posB.y);
            break;
          case 5:
            vertex(posA.x, posA.y);
            vertex(posF.x, posF.y);
            vertex(posB.x, posB.y);
            vertex(posC.x, posC.y);
            vertex(posH.x, posH.y);
            vertex(posD.x, posD.y);
            break;
          case 6:
            vertex(posA.x, posA.y);
            vertex(posF.x, posF.y);
            vertex(posG.x, posG.y);
            vertex(posC.x, posC.y);
            break;
          case 7:
            vertex(posA.x, posA.y);
            vertex(posF.x, posF.y);
            vertex(posG.x, posG.y);
            vertex(posH.x, posH.y);
            vertex(posD.x, posD.y);
            break;
          case 8:
            vertex(posA.x, posA.y);
            vertex(posD.x, posD.y);
            vertex(posE.x, posE.y);
            break;
          case 9:
            vertex(posA.x, posA.y);
            vertex(posC.x, posC.y);
            vertex(posH.x, posH.y);
            vertex(posE.x, posE.y);
            break;
          case 10:
            vertex(posA.x, posA.y);
            vertex(posB.x, posB.y);
            vertex(posG.x, posG.y);
            vertex(posC.x, posC.y);
            vertex(posD.x, posD.y);
            vertex(posE.x, posE.y);
            break;
          case 11:
            vertex(posE.x, posE.y);
            vertex(posA.x, posA.y);
            vertex(posB.x, posB.y);
            vertex(posG.x, posG.y);
            vertex(posH.x, posH.y);
            break;
          case 12:
            vertex(posE.x, posE.y);
            vertex(posF.x, posF.y);
            vertex(posB.x, posB.y);
            vertex(posD.x, posD.y);
            endShape(CLOSE);
            break;
          case 13:
            beginShape();
            vertex(posE.x, posE.y);
            vertex(posF.x, posF.y);
            vertex(posB.x, posB.y);
            vertex(posC.x, posC.y);
            vertex(posH.x, posH.y);
            break;
          case 14:
            vertex(posE.x, posE.y);
            vertex(posF.x, posF.y);
            vertex(posG.x, posG.y);
            vertex(posC.x, posC.y);
            vertex(posD.x, posD.y);
            break;
          case 15:
            vertex(posE.x, posE.y);
            vertex(posF.x, posF.y);
            vertex(posG.x, posG.y);
            vertex(posH.x, posH.y);
            break;
        }
        endShape(CLOSE);
      }
  }
}

class  Cell
{
  PVector  position, orientation;
  float    size;
  PShape   cShape;
  
  int      prevState, state;
  String   binaryState = "0000";
  
  color    colorBorn, colorStasis, colorDeath;

  Cell(PVector position_, float size_, color colorBorn_, color colorStasis_, color colorDeath_)
  {
    position = position_.copy();
    orientation = new PVector(0.f, 0.f);
    size = size_;
    setShape();
    prevState = 0;
    state = 0;
    colorBorn = colorBorn_;
    colorStasis = colorStasis_;
    colorDeath = colorDeath_;
    return ;
  }
  
  void  setShape()
  {
    cShape = createShape();
    cShape.setStroke(color(255, 0));
    cShape.beginShape();
    for (int i = 0; i < 4; i++)
      cShape.vertex(0.f, 0.f);
    cShape.endShape(CLOSE);
    resetShape();
  }

  void  resetShape()
  {
    cShape.setVertex(0, position);
    cShape.setVertex(1, new PVector(position.x + size, position.y));
    cShape.setVertex(2, new PVector(position.x + size, position.y + size));
    cShape.setVertex(3, new PVector(position.x, position.y + size));
    return ;
  }
  
  void  morphShape(PVector posTopLeft, PVector posTopRight, PVector posBotRight, PVector posBotLeft)
  {
    cShape.setVertex(0, cShape.getVertex(0).add(posTopLeft));
    cShape.setVertex(1, cShape.getVertex(1).add(posTopRight));
    cShape.setVertex(2, cShape.getVertex(2).add(posBotRight));
    cShape.setVertex(3, cShape.getVertex(3).add(posBotLeft));
    return ;
  }
  
  PVector  getShapeCenter()
  {
    PVector positionCenter;
    
    positionCenter = new PVector(0.f, 0.f, 0.f);
    positionCenter.add(cShape.getVertex(0));
    positionCenter.add(cShape.getVertex(1));
    positionCenter.add(cShape.getVertex(2));
    positionCenter.add(cShape.getVertex(3));
    positionCenter.div(4.f);
    return (positionCenter);
  }

  PVector  getOrientationFromBinaryState()
  {
    PVector  orientationFromBinary;
    
    orientationFromBinary = new PVector(0.f, 0.f);
    for (int i = 0; i < 4; i++)
    {
      if (binaryState.substring(i, i + 1).equals("1"))
        orientationFromBinary.add(PVector.fromAngle(-PI / 2.f - i * PI / 2.f));
    }
    if (orientationFromBinary.magSq() > 0.001f)
      orientationFromBinary.normalize();
    return (orientationFromBinary);
  }
  
  int  isActive()
  {
    if (prevState == 1 || state == 1)
      return(1);
    return(0);
  }
  
  void  displayDebug()
  {
    PVector  positionCenter;

    positionCenter = getShapeCenter();
    stroke(255, 64);
    line(positionCenter.x, positionCenter.y, positionCenter.x + orientation.x * 10.f, positionCenter.y + orientation.y * 10.f);
  }

  void  displayBoth()
  {
    noStroke();
    if (prevState == 0 && state == 1)
      cShape.setFill(colorBorn);
    else if (state == 1)
      cShape.setFill(colorStasis);
    else if (prevState == 1 && state == 0)
      cShape.setFill(colorDeath);
    if (prevState != 0 || state != 0)
      shape(cShape);
    return ;
  }

  void  display()
  {
    noStroke();
    if (prevState == 0 && state == 1)
      cShape.setFill(colorBorn);
    else if (state == 1)
      cShape.setFill(colorStasis);
    else if (prevState == 1 && state == 0)
      cShape.setFill(colorDeath);
    if (prevState != 0 || state != 0)
      shape(cShape);
    return ;
  }
}

class  Cell
{
  PVector  position, direction, tangent;
  float    size;
  int      prevState, state;
  String   binaryState = "0000";
  color    colorBorn, colorStasis, colorDeath;

  Cell(PVector position_, float size_, color colorBorn_, color colorStasis_, color colorDeath_)
  {
    position = position_.copy();
    direction = new PVector(0.f, 0.f);
    tangent = new PVector(0.f, 0.f);
    size = size_;
    prevState = 0;
    state = 0;
    colorBorn = colorBorn_;
    colorStasis = colorStasis_;
    colorDeath = colorDeath_;
    return ;
  }

  int  isActive()
  {
    if (prevState == 1 || state == 1)
      return(1);
    return(0);
  }

  PVector  getDirectionFromBinaryState()
  { 
    PVector  directionFromBinary;
    
    directionFromBinary = new PVector(0.f, 0.f);
    for (int i = 0; i < 4; i++)
    {
      if (binaryState.substring(i, i + 1).equals("1"))
        directionFromBinary.add(PVector.fromAngle(-PI / 2.f - i * PI / 2.f));
    }
    if (tangent.magSq() > 0.001f)
      directionFromBinary.normalize();
    return(directionFromBinary);
  }
  
  color    getColorFromState()
  {
    color  newColor;
    
    newColor = colorStasis;
    if (prevState == 0 && state == 1)
      newColor = colorBorn;
    else if (prevState == 1 && state == 0)
      newColor = colorDeath;
    return (newColor);
  }

  void  display()
  {
    color  newColor;

    newColor = getColorFromState();
    if (isActive() == 1)
    {
      rectMode(CENTER);
      stroke(newColor);
      fill(newColor);
      pushMatrix();
      translate(position.x + size / 2.f, position.y + size / 2.f);
      square(0, 0, size);
      stroke(255);
      //line(-tangent.x, -tangent.y, tangent.x, tangent.y);
      popMatrix();
    }
    return ;
  }
}

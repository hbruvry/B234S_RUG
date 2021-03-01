class  Cell
{
  PVector  position;
  float    size;
  color    colorBorn;
  color    colorStasis;
  color    colorDeath;
  int      state;
  int      prevState;
  int      binaryState;

  Cell(PVector position_, float size_, color colorBorn_, color colorStasis_, color colorDeath_)
  {
    position = position_.copy();
    size = size_;
    colorBorn = colorBorn_;
    colorStasis = colorStasis_;
    colorDeath = colorDeath_;
    state = 0;
    prevState = 0;
    binaryState = 0;
    return ;
  }
  
  void  savePreviousState()
  {
    prevState = state;
    return ;
  }

  void  setState(int s)
  {
    state = s;
    return ;
  }
  
  void  setBinaryState(int s)
  {
    binaryState = s;
    return ;
  }

  void  display()
  {
    noStroke();
    if (prevState == 0 && state == 1)
      fill(colorBorn);
    else if (state == 1)
      fill(colorStasis);
    else if (prevState == 1 && state == 0)
      fill(colorDeath);
    if (prevState != 0 || state != 0)
      rect(position.x, position.y, size, size);
    return ;
  }
}

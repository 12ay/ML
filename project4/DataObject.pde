class DataObject {
   
   public float xPos;   // x value
   public float yPos;  //  y value
   
   // Scaled values
   public float scaledX;  // scaled x value 
   public float scaledY;  // scaled y value
   
   public int colorVal;
   public boolean moved;
   public int centroidId;
   public float minDistance;
   boolean isMediod;
   boolean isSwapedItem;   // The specifies the swapped data object
   
  public color[] dataColorValues = { #8000ff, #FF0000, #FFFF00, #0000FF};
   
   
   DataObject(float xParam, float yParam) {
     xPos = xParam;
     yPos = yParam;
     moved = false;
     centroidId = -1;
     minDistance = MAX_FLOAT;
     isMediod = false;
   }
  
 void applyScale(float xMinValue, float xMaxValue, float yMinValue, float yMaxValue) {
     scaledX = ( xPos - xMinValue ) / (xMaxValue - xMinValue);
     
     scaledY = ( yPos - yMinValue) / (yMaxValue - yMinValue);
 }
  
  
  void drawDataObject(float xVal, float yVal, int radius) {
      fill(dataColorValues[centroidId]);
      ellipse(xVal,yVal,radius,radius);

  }
    
}
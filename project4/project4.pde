import java.util.Random;
import java.util.*;

Table dataset;

int rowCount;
float xMin = MAX_FLOAT;
float xMax = MIN_FLOAT;
float yMin = MAX_FLOAT;
float yMax = MIN_FLOAT;
boolean drawOnce = true;
color[] colorValues = { #000000, #FF0000, #FFFF00, #0000FF};
float Svalue;

// Input variables
ArrayList<DataObject> dataList ;
int numCategories = 2;
ArrayList<CentroidObject> centroidList;
boolean objectMoved;


float xArray[];
float yArray[];

//This updates the minimum and maximum x and y values from dataList
void findMinMax() {
  for ( DataObject d : dataList) {
    if ( d.xPos < xMin ) {
      xMin = d.xPos;
    }
    if (d.xPos > xMax) {
      xMax = d.xPos;
    }

    if ( d.yPos < yMin ) {
      yMin = d.yPos;
    }
    if (d.yPos > yMax) {
      yMax = d.yPos;
    }
  }
}

//This scales X and Y coordinates of data objects
void applyScaleToDataObjects() {

  for ( DataObject d : dataList) {
    d.applyScale(xMin, xMax, yMin, yMax);
  }
}

//This populates the data and centroid arrays
void readInput() {

  rowCount = dataset.getRowCount();
  dataList = new ArrayList<DataObject>();
  centroidList =  new ArrayList<CentroidObject>();

  float x;
  float y;
  for ( int i = 0; i < rowCount; i++ ) {
    if ( i == 0 ) continue;      //header
    x = dataset.getFloat(i, 1);  //x-coordinate
    y = dataset.getFloat(i, 2);  //y-coordinate
    DataObject dataObject = new DataObject(x, y);
    dataList.add(dataObject);
  }
  findMinMax();
  applyScaleToDataObjects();
}

void applyClusteringAlgorithm() {

  // Generate a random number of size numCategory starting points
  for ( int i = 0; i < numCategories; i++ ) {
    // Randomly apply centroid coordinate between 0 and 1 for each feature
    Random randInst = new Random();
    CentroidObject dataObject = new CentroidObject(randInst.nextFloat(), randInst.nextFloat(), i);
    centroidList.add(dataObject);
  }
  
  // WE iterate over all the data objects for each centroid value marking the data object to the closest centroid
  objectMoved = true;

  while ( objectMoved == true ) {
    calculateCentroidAvg();
    objectMoved = false;
  }
}
// Calculate centroid avg.
void calculateCentroidAvg() {
  for ( DataObject d : dataList ) {
    for ( CentroidObject centroidObjects : centroidList) {

      // Calculate the distance from the centroid object to the data object element d
      // If the calculate distance is smaller , and the centroid id is different 
      // then change d.mindistance and centroid id to the centroid object id
      
     
      
      double value1 = centroidObjects.xPoint - d.scaledX;
      double value2 = centroidObjects.yPoint - d.scaledY;
      float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
      if (dataToObjectDist < d.minDistance) {
        d.minDistance = dataToObjectDist;
        if ( d.centroidId != centroidObjects.centroidId) {
          d.centroidId = centroidObjects.centroidId;

          objectMoved = true;
        }
      }
      
      if ( d.centroidId == centroidObjects.centroidId) {
        centroidObjects.xAccum += d.scaledX;
        centroidObjects.yAccum += d.scaledY;
        centroidObjects.count += 1;
        
      }
    }

    // Update centroids coordinates through median
    for (CentroidObject c : centroidList ) {
      c.xPoint = c.xAccum / c.count;
      c.yPoint = c.yAccum / c.count;
    }
  }
}


void calculateMedians() {
 for ( DataObject d : dataList ) {
    for ( CentroidObject centroidObject : centroidList) {
      double value1 = centroidObject.xPoint - d.scaledX;
      double value2 = centroidObject.yPoint - d.scaledY;
      
      xArray[centroidObject.centroidId] = d.scaledX;
      yArray[centroidObject.centroidId] = d.scaledX;
      
      float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
      if (dataToObjectDist < d.minDistance) {
        d.minDistance = dataToObjectDist;
        if ( d.centroidId != centroidObject.centroidId) {
          d.centroidId = centroidObject.centroidId;
          

          objectMoved = true;
        }
      }
      
      if ( d.centroidId == centroidObject.centroidId) {
        // When adding a new data object to the centroid, sort the centroid
        centroidObject.xAccum += d.scaledX;
        centroidObject.yAccum += d.scaledY;
        centroidObject.count += 1;
      }
    }

    //The median is found by sorting the x and y arrays in numeric order.
    //The middle element of the arrays become the median.
    Arrays.sort(xArray);
    float xMedian;
    if (xArray.length % 2 == 0){
    xMedian = ((float)xArray[xArray.length/2] + (float)xArray[xArray.length/2 - 1])/2;
    }
    else{
    xMedian = (float) xArray[xArray.length/2];
    }
    Arrays.sort(yArray);
    float yMedian;
    if (yArray.length % 2 == 0){
    yMedian = ((float)yArray[yArray.length/2] + (float)yArray[yArray.length/2 - 1])/2;
    }
    else{
    yMedian = (float) yArray[yArray.length/2];
    }
    
    // Update centroids coordinates through median
    for (CentroidObject c : centroidList ) {
      c.xPoint = xMedian;
      c.yPoint = yMedian;
    }
 }

    
}   

  

void calculateSSE() {
     // This function iterates over all the mediods and finds the SSE value
     // In this case we can identify data object that are a mediods
     // This is a nested loop iterating over mediods and the inner loop iterates over the data object
     
     float temporarySvalue = 0;
     for ( DataObject m : dataList ) {
         if ( m.isMediod == false) continue; 
         for ( DataObject d : dataList ) {
           if (d.isMediod == true) {
                   // calculate the value || x(i) - Cm || ^ 2
                    double value1 = d.scaledX - m.scaledX;
                    double value2 = d.scaledY - m.scaledY;
                    temporarySvalue += (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
           }
         }
     }
     if (temporarySvalue < Svalue) {
           // find the swapped dataObject and set it as a mediod.
           Svalue = temporarySvalue;
     }
}

void calculateMedoid() {
  // This function calls calculate SSE for every swapped dataObject
  
  calculateSSE();
  
}

void drawCluster() {

  println("Drawing once !");
  for ( DataObject d : dataList ) {
    // Here is where to draw

    //  Convert to map coordinates (distance,speed)
    //  Draw  X  or O to represent coordinates
    print(d.xPos + " " + d.yPos + " -- ");

    d.drawDataObject(d.xPos, d.yPos, 5);
  }
}

void drawCentroid() {
  print(" Draw centroid callback ! ");
  for ( CentroidObject centroidObjects : centroidList) {
    float xValue = centroidObjects.xPoint * (xMax - xMin) + xMin;
    float yValue = centroidObjects.yPoint * (yMax - yMin) + yMin;
    print(" x value " + xValue + " y value  " + yValue + "\n");
    centroidObjects.drawCentroid(xValue, yValue, 10);
  }
}

void setup() {

  size(1000, 1000);
  dataset = new Table("locations.tsv");  
  readInput();   /// Read input , scaled each of the data object features (distance,speed) between 0 and 1
  
  applyClusteringAlgorithm();
  //calculateMedians();  //not functional
  calculateMedoid();     //not functional

  /* Show all the test points as circles */
}

void draw() {

  // This is where the visualization is.
  if (drawOnce == true) {
    drawCluster();
    drawCentroid();
    drawOnce = false;
  }
}
Table dataset;

/* Input variables */
int []labelInput;
String []labelString;

float [] widthInput;
float [] heightInput;

/* Training variables */
float [] widthTraining;
float [] heightTraining;
String [] trainString;
int [] trainLabel;


/* Test variables */
float [] widthTest;
float [] heightTest;


/* Prediction variables */
int [] predictedTestType;
String [] predictedString;

/* Distance arrays*/
double [] dist;
double [] minDist;

/* Array indices */
int rowCount;
int testRowCount;
int trainRowCount;
int minTestRow;


//This function predicts the fruit name of the test variable using the k nearest neighbor algorithm.
void predictTestType() {
  
   dist = new double[trainRowCount];
   minDist = new double[testRowCount];
   
   predictedTestType = new int[testRowCount];
   predictedString = new String[testRowCount];
   
   for (int testRow = 1; testRow < testRowCount; testRow++){       // 14 iterations
     
     minDist[testRow] = 99;
     for(int trainRow = 1; trainRow < trainRowCount; trainRow++){  //45 iterations
       dist[trainRow] = Math.sqrt((widthTraining[trainRow] - widthTest[testRow])*(widthTraining[trainRow] - widthTest[testRow]) + (heightTraining[trainRow] - heightTest[testRow])*(heightTraining[trainRow] - heightTest[testRow]));
              
       if (dist[trainRow] <= minDist[testRow]){        //minDist in this section
         minDist[testRow] = dist[trainRow]; 
         minTestRow = trainRow;                        //index of dist[] where minDist occurs, +1 to get the row number
         predictedString[testRow] = trainString[minTestRow];
         predictedTestType[testRow] = trainLabel[minTestRow];
       }
     }
   }
}

//This function calulates the algorithm's accuracy in predicting the test variable's fruit name.
void calculateAccuracy() {
  
   float correct = 0;

   for (int i = 1; i < testRowCount ; i++){
     print("The predicted name is " + predictedString[i] + ". The real fruit name is  " + labelString[i * 4] + "\n");
      
      if (predictedString[i].equals(labelString[i * 4])){
        correct++;
      }
   }
   float accuracy = 100 * (correct / (testRowCount-1));
   print("\nAccuracy: " + accuracy + "%");
}

//This function gathers input variables.
void readInput() {
 
   rowCount = dataset.getRowCount();
   labelInput = new int[rowCount];
   labelString = new String[rowCount];
   widthInput = new float[rowCount];
   heightInput = new float[rowCount]; 
   
   for (int row = 1; row < rowCount; row++) {
     
     labelInput[row] = dataset.getInt(row,0);
     labelString[row] = dataset.getString(row,1);
     
     widthInput[row] = dataset.getFloat(row, 4);
     heightInput[row] = dataset.getFloat(row,5);
 
   }
}

//This function gathers the data of all training variables.
void trainingData(){
  
  rowCount = dataset.getRowCount();
  trainRowCount = (rowCount / 4) * 3;
  widthTraining = new float[trainRowCount];
  heightTraining = new float[trainRowCount];
  trainString = new String[trainRowCount];
  trainLabel = new int[trainRowCount];
  


  for (int row = 1, i = 0; row < rowCount; row++, i++) {        
    int excludeTest = row % 4;
    if (excludeTest != 0){
    widthTraining[i] = dataset.getFloat(row, 4);
    heightTraining[i] = dataset.getFloat(row, 5);
    trainString[i] = dataset.getString(row,1);      //fills up an array of fruit names from the 45 training values
    trainLabel[i] = dataset.getInt(row,0);
   
    } else if (excludeTest ==0){

     widthTraining[i] = dataset.getFloat(row+1, 4);
     heightTraining[i] = dataset.getFloat(row+1, 5);
     trainString[i] = dataset.getString(row+1,1);
     row++;
    }
    
  }

}


//This function gathers the data of all the test variables.
void testData(){
  
  rowCount = dataset.getRowCount();
  testRowCount = rowCount / 4;
  widthTest = new float[testRowCount];
  heightTest = new float[testRowCount];
  
  for (int row = 1; row < testRowCount; row++) {
    int everyFourth = row * 4;
    widthTest[row] = dataset.getFloat(everyFourth, 4);
    heightTest[row] = dataset.getFloat(everyFourth, 5);
  }
}

void setup() {
  
  size(700,700);
  dataset = new Table("fruit_data_with_colors.txt");  
  readInput();
  trainingData();
  testData();
  predictTestType();
  calculateAccuracy();

}

void drawTrainingData() {
  
  color[] colorValues = new color[8];
  
  colorValues[0] = #000000;  // Black
  colorValues[1] = #FF0000;  // Red
  colorValues[2] = #FFFF00;  // Yellow
  colorValues[3] = #0000FF;  // Blue
  colorValues[4] = #00FF00;  // Lime
  colorValues[5] = #800080;  // Purple
  colorValues[6] = #808080;  // Gray
  colorValues[7] = #A52A2A;  // Brown
  
  int modulusCount = 0;
  
  
  for (int row = 0; row < rowCount; row++){
    //This loop colors the training variables.
    int category = modulusCount++ % 4;
    
    if (category == 0) {
      //If test data, do nothing. Test data is colored in a separte loop.
    } else {
        if ( labelInput[row] == 1 ) {
             // Black for Apple      
             fill(colorValues[0]);
        } else if (labelInput[row] == 2) {
             // Red for Mandarin 
             fill(colorValues[1]);
        } else if (labelInput[row] == 3) {
            // Yellow for Orange
            fill(colorValues[2]); 
        } else if (labelInput[row] == 4) {
            // Blue for Lemon
            fill(colorValues[3]); 
        }
        ellipse(widthInput[row] * 50, heightInput[row] * 50, 5,5);
    }
  } 
  
  for(int testRow = 0; testRow < testRowCount; testRow++){
    //This loop colors the test variables.
    if ( predictedTestType[testRow] == 1 ) {
             // Lime for apple 
             fill(colorValues[4]);
        } else if (predictedTestType[testRow] == 2) {
             // Purple for Mandarin
             fill(colorValues[5]);
        } else if (predictedTestType[testRow] == 3) {
            // Gray for Orange
            fill(colorValues[6]); 
        } else if (predictedTestType[testRow] == 4) {
            // Brown for Lemon
            fill(colorValues[7]); 
        }
        ellipse(widthTest[testRow] * 50, heightTest[testRow] * 50, 5,5);
    }
}


void draw() {
  
 // This is where the visualization is.
   drawTrainingData();
  
}
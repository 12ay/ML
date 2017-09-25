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
String [] predictedString;

/* Distance arrays*/
double [] dist;
double [] minDist;

/* Array indices */
int rowCount;
int testRowCount;
int trainRowCount;
int minTestRow;

/* Averaging variables */
int mandarinTruePos = 0, appleTruePos = 0, orangeTruePos = 0, lemonTruePos = 0;


//This function predicts the fruit name of the test variable using the k nearest neighbor algorithm.
void predictTestType() {
  
   dist = new double[trainRowCount];
   minDist = new double[testRowCount];
   predictedString = new String[testRowCount];
   
   for (int testRow = 1; testRow < testRowCount; testRow++){
     
     minDist[testRow] = 99;
     for(int trainRow = 1; trainRow < trainRowCount; trainRow++){
       dist[trainRow] = Math.sqrt((widthTraining[trainRow] - widthTest[testRow])*(widthTraining[trainRow] - widthTest[testRow]) + (heightTraining[trainRow] - heightTest[testRow])*(heightTraining[trainRow] - heightTest[testRow]));
              
       //if there is a new minimum distance, the predicted string is updated
       if (dist[trainRow] <= minDist[testRow]){
         minDist[testRow] = dist[trainRow]; 
         minTestRow = trainRow;
         predictedString[testRow] = trainString[minTestRow];
       }
     }
   }
}

//This function counts the number of true positives from and calulates the micro average of the algorithm
void calculateAccuracy() {
  
   float totalTruePos = 0;
   
   for (int i = 1; i < testRowCount ; i++){
     print("The predicted name is " + predictedString[i] + ". The real fruit name is  " + labelString[i * 4] + "\n");
      
      if (predictedString[i].equals(labelString[i * 4])){
        if(labelString[i * 4].equals("mandarin")){
          mandarinTruePos++;
        }else if (labelString[i * 4].equals("apple")){
          appleTruePos++;
        }else if (labelString[i * 4].equals("orange")){
          orangeTruePos++;
        }else if (labelString[i * 4].equals("lemon")){
          lemonTruePos++;
        }
        totalTruePos++;
      }
   }
   float microAvg = 100 * (totalTruePos / (testRowCount-1));
   print("\nMicro Average: " + microAvg + "%\n");
}

//This function counts the instances and calculates the macro average of the algorithm
void calculateMacro(){

  float mandarinInst = 0, appleInst = 0, orangeInst = 0, lemonInst = 0;
  
  for (int i = 1; i < testRowCount ; i++){
    if(labelString[i * 4].equals("mandarin")){
          mandarinInst++;
        }else if (labelString[i * 4].equals("apple")){
          appleInst++;
        }else if (labelString[i * 4].equals("orange")){
          orangeInst++;
        }else if (labelString[i * 4].equals("lemon")){
          lemonInst++;
        }
  }
  float mandarinAcc = 100*(mandarinTruePos/mandarinInst);
  float appleAcc = 100*(appleTruePos/appleInst);
  float orangeAcc = 100*(orangeTruePos/orangeInst);
  float lemonAcc = 100*(lemonTruePos/lemonInst);
  float macroAvg = ((mandarinAcc + appleAcc + orangeAcc + lemonAcc)/4);
  print("Macro Average: " + macroAvg + "%\n");
  print("Precision for mandarins, apples, oranges, and lemons respectively: "+mandarinAcc+"% "+appleAcc+"% "+orangeAcc+"% "+lemonAcc + "%\n");
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
  
  //this for-loop fills up arrays conerning the training data
  for (int row = 1, i = 0; row < rowCount; row++, i++) {        
    int excludeTest = row % 4;
    if (excludeTest != 0){
    widthTraining[i] = dataset.getFloat(row, 4);
    heightTraining[i] = dataset.getFloat(row, 5);
    trainString[i] = dataset.getString(row,1);
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
  calculateMacro();
}

void drawTrainingData() {
  
  
  color[] colorValues = new color[4];
  
  colorValues[0] = #FF0000;  // Red
  colorValues[1] = #00FF00;  // Green
  colorValues[2] = #FFA500;  // Orange
  colorValues[3] = #FFFF00;  // Yellow

  int modulusCount = 0;
  
  for (int row = 0; row < rowCount; row++){
    //This loop colors the training variables.
    int category = modulusCount++ % 4;
    
    if (category == 0) {
      //If test data, do nothing. Test data is colored in a separte loop.
    } else {
        if ( labelInput[row] == 1 ) {
             // Red for Apple      
             fill(colorValues[0]);
        } else if (labelInput[row] == 2) {
             // Green for Mandarin 
             fill(colorValues[1]);
        } else if (labelInput[row] == 3) {
            // Orange for Orange
            fill(colorValues[2]); 
        } else if (labelInput[row] == 4) {
            // Yellow for Lemon
            fill(colorValues[3]); 
        }
        ellipse(widthInput[row] * 50, heightInput[row] * 50, 10,10);
    }
  } 
  
  for(int i = 1; i < testRowCount; i++){
    //This loop colors the test variables.
    
    if ( predictedString[i].equals("apple") ) {
             // Red for Apple  
             fill(colorValues[0]);
        } else if (predictedString[i].equals("mandarin")) {
             // Green for Mandarin 
             fill(colorValues[1]);
        } else if (predictedString[i].equals("orange")) {
            // Orange for Orange
            fill(colorValues[2]); 
        } else if (predictedString[i].equals("lemon")) {
            // Yellow for Lemon
            fill(colorValues[3]); 
        }
        rect(widthTest[i] * 50, heightTest[i] * 50, 7,7);
    }
}


void draw() {

   drawTrainingData();
  
}
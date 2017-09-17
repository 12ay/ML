Table dataset;

int rowCount;
int trainRowCount;
int testRowCount;


/* Input variables */
int []labelInput;
String []labelString;

float [] widthInput;
float [] heightInput;

/* Training variables */
float [] widthTraining;
float [] heightTraining;


/* Test variables */
float [] widthTest;
float [] heightTest;

double [] dist;
double [] minDist;

int minTestRow;

String [] trainString;
String [] predictedString;

void predictTestType() {
   dist = new double[trainRowCount];
   minDist = new double[testRowCount];
   
   predictedString = new String[testRowCount];
   

   // Iterating over all the training values

   // For each training value (x,y) (width,height)  find the euclidean distance between  the current test value (x,y)
   // and the training value (x,y)

   // the predicted test type is the training data that has the lowest Euclidean distance
   // set the predicted type for that training set to be the same type for that training data
   
   for (int testRow = 1; testRow < testRowCount; testRow++){       // 14 iterations
     
     minDist[testRow] = 99;
     for(int trainRow = 1; trainRow < trainRowCount; trainRow++){  //45 iterations
       dist[trainRow] = Math.sqrt((widthTraining[trainRow] - widthTest[testRow])*(widthTraining[trainRow] - widthTest[testRow]) + (heightTraining[trainRow] - heightTest[testRow])*(heightTraining[trainRow] - heightTest[testRow]));
       
       
       
       if (dist[trainRow] <= minDist[testRow]){        //minDist in this section
         minDist[testRow] = dist[trainRow]; 
         minTestRow = trainRow;                        //index of dist[] where minDist occurs, +1 to get the row number
         predictedString[testRow] = trainString[minTestRow];
       }


     
     }
     //print("The minDist is: " + minDist[testRow] + " at index " + minTestRow + "\n");
     //print("The fruit might be a(n) " + predictedString[testRow] + ".\n");
   
   }

}

void calculateAccuracy() {
  
   // Gather all the test data whose type is the correct type  and divide that number over the total number of 
   // test data 
   int correct = 0;
   int total = testRowCount;

   for (int i = 1; i < testRowCount ; i++){
     print(predictedString[i] + " " + labelString[i * 4] + "\n");

     if (predictedString[i] == labelString[i * 4]){                    //this line doesn't seem to work     
       correct++;                                                  
       }
    }
   float accuracy = 100 * (correct / total);
   print("The algorithm was " + accuracy + "% accurate\n"); 
   print("Number correct: " + correct);
}


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

void trainingData(){
  
  rowCount = dataset.getRowCount();
  trainRowCount = (rowCount / 4) * 3;                    //can't do testRowCount * 3
  widthTraining = new float[trainRowCount];
  heightTraining = new float[trainRowCount];
  trainString = new String[trainRowCount];
  


  for (int row = 1, i = 0; row < rowCount; row++, i++) {        
    int excludeTest = row % 4;
    if (excludeTest != 0){
    widthTraining[i] = dataset.getFloat(row, 4);
    heightTraining[i] = dataset.getFloat(row, 5);
    trainString[i] = dataset.getString(row,1);      //fills up an array of fruit names from the 45 training values
   
    } else if (excludeTest ==0){

     widthTraining[i] = dataset.getFloat(row+1, 4);
     heightTraining[i] = dataset.getFloat(row+1, 5);
     trainString[i] = dataset.getString(row+1,1);
     row++;
    }
    
  }

}
void testData(){
  
  rowCount = dataset.getRowCount();
  testRowCount = rowCount / 4;
  widthTest = new float[testRowCount];
  heightTest = new float[testRowCount];
  
  
  for (int row = 1; row < testRowCount; row++) {        //<=?
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
  /* Show all the test points as circles */
  
  
  //trainString! fruit names of the 45 training data
  //for ( int row =0; row < trainRowCount; row++ ){
  //    print(trainString[row] + "\n");
  //}


  //for ( int row =0; row < testRowCount; row++ ) {
  //   print( "(" + widthTest[row] + "," + heightTest[row] + " ) " );
  //}

}


void draw() {
  
 // This is where the visualization is. 
   for (int row = 0; row < rowCount; row++){
   
    ellipse(widthInput[row] * 50, heightInput[row] * 50, 5,5);
    
  } 
}
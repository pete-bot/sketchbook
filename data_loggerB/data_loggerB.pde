//PeterKydd
//29/08/13
// LAB02: DATA LOG

//GLOBAL VARIABLES
int sensorPin = 0;
float data[100];

//SETUP SKETCH
void setup(){
   analogReference(DEFAULT);
   Serial.begin(9600);
}

//MAIN PROGRAM
void loop(){
  
  int readCount = 0;
  int centredData = 0;
  float smoothValue = 0;
  float sensorValue = 0;
  
  
   for (readCount = 0; readCount<100; readCount++){
      sensorValue = analogRead(sensorPin);
      data[readCount] = sensorValue;
      delay(1);
   }

   for(int printCount = 0; printCount<100; printCount++){
      
      smoothValue = 0.9 * smoothValue + 0.1 * (float)data[printCount];
      centredData = data[printCount] + (512 - (int)smoothValue);
      for (int j = 0; j < centredData/20; j++){ 
         Serial.print(" ");
      }
      Serial.println("#");
   }
   
   //pause for 1 second
   //delay(1000);
   */
}





//PeterKydd
//29/08/13
// LAB02: DATA LOG

//GLOBAL VARIABLES
int sensorPin = 0;
int data[100];

//SETUP SKETCH
void setup(){
   analogReference(DEFAULT);
   Serial.begin(9600);
}

//MAIN PROGRAM
void loop(){
  
  
  
  int readCount = 0;
  int sensorValue = 0;
  
  
   for (readCount = 0; readCount<100; readCount++){
      sensorValue = analogRead(sensorPin);
      data[readCount] = sensorValue;
      delay(1);
   }

   for(int printCount = 0; printCount<100; printCount++){
      Serial.println(data[printCount], DEC);
      
   }
   
   //pause for 1 second
   delay(10000);

}





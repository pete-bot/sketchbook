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
  
  
  float smoothValue = 0;
  int readCount = 0;
  int centredData = 0;
  float sensorValue = 0;
  
   //read data in
   for (readCount = 0; readCount<100; readCount++){
      sensorValue = analogRead(sensorPin);
      data[readCount] = sensorValue;
      delay(1);
   }

   
   for(int printCount = 0; printCount<100; printCount++){
     //print data value 
     Serial.print(data[printCount], DEC);
      
      //print appropriately spaced %# symbol
      for (int j = 0; j < data[printCount]/20; j++){ 
         Serial.print(" ");
      }
      Serial.println("#");
   }
   
   //pause for 1 second
   delay(1000);

}





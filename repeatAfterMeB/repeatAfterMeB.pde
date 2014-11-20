//PeterKydd
//22/08/13
//program to repeat an input string, char by char

//control debug prints
//#define DEBUG

char incomingByte;

void setup(){
   Serial.begin(9600);
}

void loop(){
   
   //increase to 40 elements for longer strings :)
   char myString[40];
   int index = 0;
    
   //collect data
   while(Serial.available() > 0){
      incomingByte = Serial.read(); 
      myString[index] = incomingByte;
      index++;
      delay(10);
  
   }
  
   //append NULL byte to end of string
   
   myString[index] = 0;
   index = 0;
   
   //debug prints
   #ifdef DEBUG  
      while(myString[index] != 0 ){
         Serial.print(myString[index], BYTE);
         index++;
      }
    
      if(index>0){
         Serial.println();
      }
   
   #endif
   
   index = 0;
  
   while(myString[index] != 0 ){
      Serial.print(myString[index], BYTE);
      index++;
      
      if(myString[index] == 0){
         Serial.print('.');
      }
   }
}

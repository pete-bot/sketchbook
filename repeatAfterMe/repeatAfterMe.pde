//PeterKydd
//22/08/13
//program to repeat an input string, char by char

//for incoming serial data
char incomingByte;

void setup(){
   Serial.begin(9600);
}

void loop(){
   //send data when you recieve data
   if(Serial.available()>0){
      //read incoming byte
      incomingByte = Serial.read();
      
      Serial.println(incomingByte, BYTE );
   
   }




}


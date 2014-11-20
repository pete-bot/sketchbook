//peterkydd
//23/08/13
//LED flashing program
//Flash LED at 5hz (5/s, ie T =  0.200ms)

const int ledPin = 13;

void setup(){
   //initialise serial communication:
   Serial.begin(9600);
   
   //initialise LED pin as output:
   pinMode(ledPin, OUTPUT);
   
}

void loop(){
   int incomingByte;
   int flashNo = 0;
   int digit= -1;
   
   //independant flash counter
   int flashCount = 0;
  
   while(Serial.available()){
     //read in data from serial 
     incomingByte = Serial.read();
     delay(10);
        
      //ensure only numerical data is interpreted for the flashcount
      if((incomingByte >='0' ) && ( incomingByte <='9')){
         digit = (incomingByte-'0');
         flashNo = digit + (flashNo*10);
      }
   }
     
    while(flashNo > 0){
      digitalWrite(ledPin, HIGH);
      delay(100);
      digitalWrite(ledPin, LOW);
      delay(100);
      flashNo--;
      
      //indepentdent flash counter increment
      flashCount++;
     }
     
     
   //PART C ammendment - print out independant counter (flashcount), number of time LED flashed  
   if(flashCount > 0){
      Serial.print("Pin13 flashed ");
      Serial.print(flashCount, DEC);
      Serial.print( " times.");
      Serial.println();
   }
}



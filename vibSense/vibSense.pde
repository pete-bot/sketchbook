//PeterKydd
//29/08/13
// VIBRATION SENSOR SOFTWARE

#define GREEN 10
#define YELLOW 20
#define RED 30


//GLOBAL VARIABLES
int sensorPin = 0;
int sensorValue = 0;

const int GREENLED = 10;
const int YELLOWLED = 9;
const int REDLED = 8;


//SETUP SKETCH
void setup(){
   //analogReference(DEFAULT);
   Serial.begin(9600);

   pinMode(GREENLED, OUTPUT);
   pinMode(YELLOWLED, OUTPUT);
   pinMode(REDLED, OUTPUT);

}

//MAIN PROGRAM
void loop(){
   
   float rawInput = 0;
   float alpha = 0.3;
   float smooth = 0;
   
   //float sensorValue = 0;
   

   rawInput = analogRead(sensorPin);                //read vibration data from sesnor 
   
   rawInput = constrain(rawInput, 0, 30);           // constrains value to these limits
   
   sensorvalue = map(rawInput, 0, 30, 0, 1023);     // maps vibration sensor inforamtion to a range of 1024
   
   smooth = alpha*sensorValue + (1 - alpha)*smooth;
   
 
   Serial.println(smooth, DEC); 
   delay(10); 
   
   //GREEN - EVERYOTHING IS OK! 
   if(sensorValue < GREEN){
      digitalWrite(GREENLED, HIGH);
      digitalWrite(YELLOWLED, LOW);
      digitalWrite(REDLED, LOW);
   
   //YELLOW - THINGS ARE OK, BUT PREPARE TO EVAC BRIDGE
   }else if((sensorValue >= GREEN) && (sensorValue < YELLOW)){
      digitalWrite(GREENLED, LOW);
      digitalWrite(YELLOWLED, HIGH);
      digitalWrite(REDLED, LOW);

   
   //RED - EVACUATE THE BRIDGE  
   }else if((sensorValue >= YELLOW) && (sensorValue < RED)){
      digitalWrite(GREENLED, LOW);
      digitalWrite(YELLOWLED, LOW);
      digitalWrite(REDLED, HIGH);  
   
   //RED, FLASHING - EVACUATE BRIDGE IMMEDIATELY!!  
   }else if(sensorValue >= RED){
     digitalWrite(GREENLED, LOW);
     digitalWrite(YELLOWLED, LOW);
      
     digitalWrite(REDLED, HIGH);
     delay(250);
     digitalWrite(RED, LOW);
     //delay(250);
   }
   
   
}





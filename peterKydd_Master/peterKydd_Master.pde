  //MOTOR CODE    

#include <IRremote.h>


//DEFINE THE FLEX SENSOR THRESHOLDS
#define FLEX_GREEN  27000
#define FLEX_YELLOW 29000
#define FLEX_RED    31000

#define VIB_GREEN 10
#define VIB_YELLOW 20
#define VIB_RED 30

int sensorPin = 0;
int sensorValue = 0;





const int GREEN_LED  = 13;
const int YELLOW_LED = 12;
const int RED_LED    = 11;

const int IR_Input = 3;

const int Enable1 = 4;
const int Enable2 = 7;

const int motor1_output1 = 5;
const int motor1_output2 = 6;

const int motor2_output1 = 8;
const int motor2_output2 = 9;
long ON = 0x00FFA25D;					//code for the first button

int MOTORPHASE = 0;     //

IRrecv irrecv(IR_Input);
decode_results results;




void setup(){
  
   //*****************************************************//
   /*  SETUP SKETCH 
   */
   //*****************************************************//
   
   Serial.begin(9600);             // Setup serial

   // Initialise OUTPUT pins for the LED ARRAY
     
   pinMode(GREENLED, OUTPUT);
   pinMode(YELLOWLED, OUTPUT);
   pinMode(REDLED, OUTPUT); 
     
   pinMode(IR_Input,INPUT);
   pinMode(motor1_output1,OUTPUT);
   pinMode(motor1_output2,OUTPUT);
   pinMode(motor2_output1,OUTPUT);
   pinMode(motor2_output2,OUTPUT);
   pinMode(Enable1,OUTPUT);
   pinMode(Enable2,OUTPUT);
   irrecv.enableIRIn();
}

void loop(){

  
   //*****************************************************//
   /*  MOTOR CONTROLS
   */
   //*****************************************************//
 
   if(MOTORPHASE == 0){ 
     int i = 0;
     digitalWrite(Enable1,LOW);
     digitalWrite(Enable2,LOW);
     if (irrecv.decode(&results)){
        while(1){
           if (results.value == ON && i==0){
              digitalWrite(Enable1,HIGH);
              digitalWrite(Enable2,HIGH);
              
              digitalWrite(motor2_output1,HIGH);
              digitalWrite(motor2_output2,LOW);
              
              digitalWrite(motor1_output1,HIGH);
              digitalWrite(motor1_output2,LOW);
              delay(5000);          //rasing the platform
              
              digitalWrite(motor1_output1,LOW);
              delay(5000);        //holding the tower
              
              digitalWrite(Enable2,LOW);  //tower reaches its max height
              
              digitalWrite(motor1_output1,LOW);
              digitalWrite(motor1_output2,HIGH);
              delay(5000);        // pulls the platform back to original position
              i=1;
               digitalWrite(Enable1,LOW);
            }
            }
        }
     MOTORPHASE = 1; 
  }
   
   //*****************************************************//
   /*  FLEX SENSOR CONTROLS
   */
   //*****************************************************//
   
   
   int analogPin = 1;     // potentiometer wiper (middle terminal) connected to analog pin 3
   int raw = 0;           // variable to store the raw input value
   int Vin = 5;           // variable to store the input voltage
   float Vout = 0;        // variable to store the output voltage
   float R1 = 330;        // variable to store the R1 value
   float R2 = 0;          // variable to store the R2 value
   float buffer = 0;      // buffer variable for calculation
   
   float smooth_flex = R2;
  
   raw = analogRead(analogPin);    // Reads the Input PIN
   Vout = (5.0 / 1023.0) * raw;    // Calculates the Voltage on th Input PIN
   buffer = (Vin / Vout) - 1;
   R2 = R1 / buffer;
  
   #ifdef DEUBG_FLEX
      Serial.print("Voltage: ");      //
      Serial.println(Vout);           // Outputs the information (mainly for debug purposes)
      Serial.print("R2: ");           //
      Serial.println(R2);             //
      delay(1000);
   #endif
   
   smooth_flex = R2;
   
   //*****************************************************//
   /*  VIBRATION SENSOR CONTROLS
   */
   //*****************************************************//
   
      
   float rawInput = 0;
   float alpha = 0.3;
   float smooth_vib = 0;
   
   //float sensorValue = 0;
   

   rawInput = analogRead(sensorPin);                //read vibration data from sesnor 
   
   rawInput = constrain(rawInput, 0, 30);           // constrains value to these limits
   
   sensorvalue = map(rawInput, 0, 30, 0, 1023);     // maps vibration sensor inforamtion to a range of 1024
   
   smooth_vib = alpha*sensorValue + (1 - alpha)*smooth;
   
   #ifdef DEBUG_VIB
      Serial.print("Vibration Value: ");
      Serial.println(smooth_vib), DEC); 
      delay(10); 
   #endif     
   
   if(smooth_flex >= smooth_vib){
      sensorValue = smooth_flex;
   }else{
      sensorValue = smooth_vib;
   }
         
   //*****************************************************//
   /*  LED ARRAY CONTROLS
   */
   //*****************************************************//
   
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
      
      
      
      


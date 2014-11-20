//GLOBAL VARS

int analogPin = 1;     // potentiometer wiper (middle terminal) connected to analog pin 3
                       // outside leads to ground and +5V
int raw = 0;           // variable to store the raw input value
int Vin = 5;           // variable to store the input voltage
float Vout = 0;        // variable to store the output voltage
float R1 = 330;         // variable to store the R1 value
float R2 = 0;          // variable to store the R2 value
float buffer = 0;      // buffer variable for calculation

//MY SETTINGS

#define GREEN  27000
#define YELLOW 29000
#define RED    31000


const int GREENLED  = 10;
const int YELLOWLED = 9;
const int REDLED    = 8;






void setup(){
  Serial.begin(9600);             // Setup serial
  digitalWrite(13, HIGH);         // Indicates that the program has intialized
}

void loop(){
  
  
  
  int sensorValue = R2;
  
  raw = analogRead(analogPin);    // Reads the Input PIN
  Vout = (5.0 / 1023.0) * raw;    // Calculates the Voltage on th Input PIN
  buffer = (Vin / Vout) - 1;
  R2 = R1 / buffer;
  Serial.print("Voltage: ");      //
  Serial.println(Vout);           // Outputs the information
  Serial.print("R2: ");           //
  Serial.println(R2);             //
  delay(1000);
   
   
   sensorValue = R2;
   
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


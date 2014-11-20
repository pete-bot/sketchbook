// =======================================================
// ENGG1000 - Computing Techincal Stream
// Trolley Car
// Wtitten by Michael Schofield August 2011
// Closed loop PID controller for a Trolley Car 
// ======================================================= 

// -------------------------------------------------------
// Global Variables
// -------------------------------------------------------

int interruptPin = 2; 
int interruptNo = 0;
long prevInterruptTime = 0;
int motorPinForward = 10;
int motorPinBackward = 11;
int enablePin = 12;

long prevCycleTime = 0;
float deltaTime = 0.05;

float rfDistance = 0.2;
float rfDistance_GLOBAL = 0;
float rfTarget = 0.2;
float rfStation1 = 0.2;
float rfStation2 = 2.9;
int rfTarget_GLOBAL = 1;


float pidKp = 4.1;
float pidKi = 0.06;
float pidKd = 5.00;
float pidPrevError = 0;
float pidErrorSum = 0;
float pidValue_GLOBAL = 0;
float pidErrorSum_GLOBAL = 0;
float pidErrorSlope_GLOBAL = 0;

//set up debug print defines


// -------------------------------------------------------
// Interrupt Event Handler
// -------------------------------------------------------
void interruptPinChange(){
  
  long interruptTime;
  float distance;
  interruptTime = micros();
  
  if (digitalRead(interruptPin) == HIGH){
     prevInterruptTime = interruptTime;    
     return;

  }else{
     distance = (float)(interruptTime - prevInterruptTime) / 5800;  
  }


  //if((distance < 0.15) || (distance > 6)){
  //   return;
  //}
  
  rfDistance = distance;
  rfDistance_GLOBAL = rfDistance;

}

// -------------------------------------------------------
// Set Motor Speed
// -------------------------------------------------------
void setMotorSpeed(float pidValue) {
  
  int pwmDutyCycle;

  // Calculate the duty cycle based on the PID function: PID(+1) = +100%, PID(-1) = -100%
  
   //Serial.println("   ");
  //Serial.println("pidvalue =   ");
  //Serial.println(pidValue, DEC);
  pwmDutyCycle = pidValue * 255; 
  
  // Make sure it is a valid duty cycle
  //reverse speed
  if(pwmDutyCycle > 255){
     pwmDutyCycle = 255;
     
  }else if (pwmDutyCycle < -255){
     pwmDutyCycle = -255;  
  }
  
  if(pwmDutyCycle > 0){
     analogWrite(motorPinBackward, 0); 
     analogWrite(motorPinForward, pwmDutyCycle);
     
  }else if(pwmDutyCycle < 0){
     analogWrite(motorPinBackward, pwmDutyCycle); 
     analogWrite(motorPinForward, 0);
     
  }else if (pwmDutyCycle == 0){
     analogWrite(motorPinForward, 0); 
     analogWrite(motorPinBackward, 0); 
  
  }else if((pwmDutyCycle >= 0) && (pwmDutyCycle <= 255)){
     
  }    
}
  
// -------------------------------------------------------
// PID
// -------------------------------------------------------
float PID(float target, float actual, float deltaTime) {
  
   float pidError;
   float pidErrorSlope;
   float pidValue;
   float pidPreviousError;
  
  // Calculate the Error function Error(t) = Target(t) - Actual(t)
   pidPreviousError = pidError;
   pidError = target - actual;
  
  // Calculate the PID component values
   pidErrorSum = (pidErrorSum + pidError * deltaTime);
   pidErrorSlope = ((pidError - pidPreviousError)/deltaTime);
  
   pidErrorSum_GLOBAL = pidErrorSum;
   pidErrorSlope_GLOBAL = pidErrorSlope;
  
  
  // Calculate the PID function value
   pidValue = (pidKp * pidError + pidKi * pidErrorSum + pidKd * pidErrorSlope);
   
   pidValue_GLOBAL = pidValue;
   
   return pidValue;
}

// -------------------------------------------------------
// Check Destination
// -------------------------------------------------------
void checkDestination(){
  
  
    // Have we arrived at our destination: Station 1
    if((rfDistance <= rfStation1 + 0.01) && (rfTarget == rfStation1)){
       rfTarget = rfStation2;
       rfTarget_GLOBAL = 1;
       pidErrorSum = 0;
       
       Serial.print("Target changed to station");
       Serial.println(rfTarget_GLOBAL, DEC );
       Serial.println("Exit: checkDestination()"); 
 
       
    // Have we arrived at our destination: Station 2  
    }else if((rfDistance >= rfStation2) && (rfTarget == rfStation2)){
       rfTarget = rfStation1;
       rfTarget_GLOBAL = 2;
       pidErrorSum = 0;
     
       Serial.print("Target changed to station");
       Serial.println(rfTarget_GLOBAL, DEC );
       Serial.println("Exit: checkDestination()"); 
 
  
   }      
}
  
// -------------------------------------------------------
// The setup() method runs once, when the sketch starts
// -------------------------------------------------------
void setup(){  
  
  // Set up the enable pins
  pinMode(enablePin, INPUT);
  
  // Set up the motor speed pins
  pinMode(motorPinForward, OUTPUT);
  pinMode(motorPinBackward, OUTPUT);
  
  // Set up the interupt
  pinMode(interruptPin, INPUT);
  attachInterrupt(interruptNo, interruptPinChange, CHANGE);

  // initialize the serial communications
  Serial.begin(9600); 
 // Serial.println("Initialised");
  //Serial.println("------------------------------------------");
}

// -------------------------------------------------------
// The loop() method runs over and over again
// -------------------------------------------------------
void loop(){
  
  long cycleTime;
  float pidValue;
  float trolleyPosition;
  long rfPulseWidth;
  
  
  // DEBUG PRINTS SECTIONS
 
 Serial.println("Initialised");
 Serial.println("------------------------------------------");
 
 Serial.print("   rfDistance = ");
 Serial.println(rfDistance_GLOBAL, DEC);
 Serial.print("   rfTarget = ");
 Serial.println(rfTarget, DEC);

 
 Serial.println("Enter: PID()");
 
 Serial.print("   pidError = ");
 Serial.println(pidErrorSum_GLOBAL,DEC);
 Serial.print("   pidErrorSlope = ");
 Serial.println(pidErrorSlope_GLOBAL, DEC);
 Serial.print("   pidValue = ");
 Serial.println(pidValue_GLOBAL, DEC);
 
 Serial.println("Enter: setMotorSpeed()");
 Serial.print("   pwmDutyCycle = ");
 Serial.println(rfDistance, DEC);
 
 
  /*
  Serial.println("Enter: checkDestination()");
  Serial.print("Target changed to station");
  Serial.println(rfTarget_GLOBAL, DEC );
  Serial.println("Exit: checkDestination()"); 
 */
  
 Serial.println("------------------------------------------");
  
  
  
  // Log the time for this cycle of the loop()
  cycleTime = micros();
  deltaTime = (float)(cycleTime - prevCycleTime) / 1000000.0;
  prevCycleTime = cycleTime;
  
  // Is the Trolley Car enabled to move
  //if (digitalRead(enablePin) == HIGH) {
  if (true){
    
    // Calculte the PID function value
    pidValue = PID(rfTarget, rfDistance, deltaTime);
    
    // Set the motor speed
    setMotorSpeed(pidValue);
    
    // Check for arrival at the destination, and change of direction
    checkDestination();
    
  }
  
  // Calculate the trolley position to simulate the range finder
  trolleyPosition = rfDistance + constrain(pidValue, -1, 1) * 0.1;
  
  // Calculate the Range Finder pulse width
  rfPulseWidth = (long)(trolleyPosition * 5800.0);
  
  // Simulate the Range finder pulse
  pinMode(3, OUTPUT);
  digitalWrite(3, HIGH);
  
  if(rfPulseWidth <= 16383){
     delayMicroseconds(rfPulseWidth);
  }else{
     delayMicroseconds(16383);
     delayMicroseconds(rfPulseWidth - 16383);
  }
  
  digitalWrite(3, LOW);
  
  delay(50); 
  
}


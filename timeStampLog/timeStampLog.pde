// =======================================================
// ENGG1000 - Computing Techincal Stream
// Interrupt
// Written by Michael Schofield August 2011
// Implements an Interupt to reads incoming serial comms 
// ======================================================= 

// -------------------------------------------------------
// Global Variables
// -------------------------------------------------------
int interruptPin = 2; 
int interruptNo = 0;
long interruptTime[100];
int interruptState[100];
int dataLength = 0;

// -------------------------------------------------------
// Interrupt Event Handler
// -------------------------------------------------------
void interruptPinChange(){
  
  // Log the time of the interrupt
  interruptTime[dataLength] = micros();
  
  // Record the pin state
  interruptState[dataLength] = (digitalRead(interruptPin) == HIGH);
  
  // Increment the length of the data log
  dataLength++;
  
}

// -------------------------------------------------------
// The setup() method runs once, when the sketch starts
// -------------------------------------------------------
void setup(){  
  
  // Set up the interupt
  pinMode(interruptPin, INPUT);
  attachInterrupt(interruptNo, interruptPinChange, CHANGE);

  // initialize the serial communications
  Serial.begin(9600); 
  Serial.println("Initialised");
  
}

// -------------------------------------------------------
// The loop() method runs over and over again
// -------------------------------------------------------
void loop(){
  
  // Use the USB Serial Comms as a substitute for a genuine 
  // signal coming into InterruptPin0
  // Connect Digital IO Pins 0 & 2
  
  // Has there been a transmission
  if (Serial.available() > 0) {
    
    // Wait for all the data to arrive
    delay(100);
    
    // Flush the buffer
    Serial.flush();
    
    // Is there any data to view
    if (dataLength > 1) {
      
      // Print the data log
      Serial.println("Log begins");
      for(int i = 1; i < dataLength; i++) {
        
        // Print the data log
        Serial.print(interruptTime[i] - interruptTime[i-1], DEC);
        Serial.print(" - ");
        Serial.println(interruptState[i-1], DEC);

      }
      Serial.println("Log ends");
      
      // Reset the data log
      dataLength = 0;
      
    }
    
  }
      
}

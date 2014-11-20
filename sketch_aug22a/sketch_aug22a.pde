//PeterKydd
//22/08/13
//Hello world program 

void setup(){
  //initialise serial communication at 9600 baud rate
   serial.begin(9600);
}

void loop(){
   
  serial.println("Hello World");
  
  delay(1000);

}

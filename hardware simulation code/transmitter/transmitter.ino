
char inByte='a';

void setup() 
{
  Serial.begin(9600);
}


void loop() 
{
  if (Serial.available() > 0) 
  {
      delay(10000);
  }
  else
  {
      Serial.print("a");
      delay(10000);        
  }
  
}

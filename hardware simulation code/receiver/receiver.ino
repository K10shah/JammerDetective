#include <LiquidCrystal.h>
#include <XBee.h>

#include <Servo.h> 

XBee xbee = XBee();



Rx16Response rx16 = Rx16Response();

LiquidCrystal lcd(3,4,5,6,7,8);

Servo myservo;
Servo myservo1;
int pos=0;
int rssi = 0;
char inByte='z';
int angle= 0;
int ledPin = 13;
int count = 0;
float distance=0;
int pdr = 0; 
int ledStatus = HIGH;



void setup() {

  // start serial
  Serial.begin(9600);
  xbee.setSerial(Serial);
  lcd.begin(16,2);
  lcd.setCursor(4,0);
  lcd.print("Welcome");
  lcd.setCursor(0,1);
  lcd.print("Jammer detector");
  myservo.attach(9);
  myservo1.attach(10);
 
  
   delay(3000);
}


void loop()
{
    myservo.write(0);
    myservo1.write(0);
    xbee.readPacket();
    
    
    if (xbee.getResponse().isAvailable()) {
        // got a rx packet
       
        if (xbee.getResponse().getApiId() == RX_16_RESPONSE) {
                xbee.getResponse().getRx16Response(rx16);
        	
        
                inByte = rx16.getData(0);//taking data
                if(inByte=='a')
                {
                  lcd.clear();
                  lcd.print("Received packet");
                  lcd.setCursor(0,1);
                  lcd.print("PDR = 100%     ");
                  delay(1000);
                  lcd.setCursor(0,1);
                  lcd.print("No jammer      ");
                  delay(1000);
                }
                if(inByte == 'b')
                {
                        if(count == 0)
                      {
                       for(pos = 0; pos < 180; pos += 1)  
                      {                                  
                        myservo.write(pos);
                        ledStatus = digitalRead(ledPin);
                        if(ledStatus ==LOW) 
                       {
                        angle = pos;  
                        lcd.clear();
                       lcd.print("Jammer at angle:"); 
                        lcd.setCursor(0,1);  
                        lcd.print(angle);
                       }
                        delay(15);                       
                      } 
                      
                       for(pos = 0; pos < 180; pos += 1)  
                      {                                  
                        myservo1.write(pos);
                        ledStatus = digitalRead(ledPin);
                        if(ledStatus ==LOW) 
                        {
                        angle = pos+180;
                        lcd.clear(); 
                        lcd.print("Jammer at angle:"); 
                        lcd.setCursor(0,1);   
                        lcd.print(angle);
                       }

                        delay(15);  
                      }
                      //end of last for loop
                      }
        count = count+1;
       if (count==100)
       {
         count=0;
       }
       rssi = rx16.getRssi();
       lcd.setCursor(0,0);
       lcd.clear();
       lcd.print("Distance: ");
       if(rssi>36)
       {
       distance = (rssi-36)/7.1;
       }
       else
       {
       distance = 0;
     }
       lcd.print(distance);
       lcd.print("m");
       lcd.setCursor(0,1);
       if(distance > 1 && distance < 20)
       {
       pdr = 100 - (20-distance)*5;
       }
       else if(distance < 1)
       {
         pdr = 0;
       }
       lcd.print("PDR : ");
       lcd.print(pdr);
      lcd.print("%"); 
      
        } 
      
      }
      
    } 
}


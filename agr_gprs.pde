
float humidity_value = 0;
// use for average float temp[10];
float value_pluviometer=0;
float value_temperature=0;
float value_pressure=0;

int answer;
char aux_str[150];
unsigned int counter = 0;
float temp;
int d1;      
float f2;
int d2; 
void setup(){

// Setup for Serial port over USB
USB.begin();
USB.println("USB port started...");

//Switch on the board
SensorAgrV20.setBoardMode(SENS_ON);



RTC.begin();
//RTC.setTime("12:07:17:02:17:25:00");
delay(100);

}

void loop(){
  
// Init RTC

//RTC.ON();
SensorAgrV20.sleepAgr("00:00:00:10",RTC_OFFSET,RTC_ALM1_MODE1,UART0_OFF|UART1_OFF|BAT_OFF,SENS_AGR_PLUVIOMETER);
SensorAgrV20.detachPluvioInt();

    // Go to sleep disconnecting all the switches and modules
    // After 10 seconds, Waspmote wakes up thanks to the RTC Alarm
//PWR.deepSleep("00:00:00:10",RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);
//TODO check above if its the same as the one used ?ALL_OFF?

//TODO CHECK RTC.ON RTC.OFF
USB.begin();
//pluviometer inter
if(intFlag & PLV_INT)
{
  USB.println(("---------------------"));
        USB.println(("pluviometer interrupts"));
        USB.println(("---------------------"));
  //read
  value_pluviometer=SensorAgrV20.readValue(SENS_AGR_PLUVIOMETER);
  delay(100);
  USB.println("pluviometer: ");
  USB.println(value_pluviometer);
  
}

//otan parei RTC interruption kathe 10sec   //na mpei edw mesa to GPRS kai na ayksithoun ta lepta px kathe 20-60
if( intFlag & RTC_INT )
    {
        USB.println(("---------------------"));
        USB.println(("RTC INT  captured"));
        USB.println(("---------------------"));
        
      /*  Utils.blinkLEDs(300);
        Utils.blinkLEDs(300);
        Utils.blinkLEDs(300);*/
        intFlag &= ~(RTC_INT);
        
 
 
 //READ SENSORS except pluv
 
 
  SensorAgrV20.setSensorMode(SENS_ON,SENS_AGR_TEMPERATURE);
 delay(2000); //waiting
  value_temperature=SensorAgrV20.readValue(SENS_AGR_TEMPERATURE);
  SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_TEMPERATURE);

   SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_HUMIDITY);
   delay(1500);
   humidity_value = SensorAgrV20.readValue(SENS_AGR_HUMIDITY);
   SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_HUMIDITY);

	SensorAgrV20.setSensorMode(SENS_ON,SENS_AGR_PRESSURE);
 delay(1000);
     value_pressure=SensorAgrV20.readValue(SENS_AGR_PRESSURE);
SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_PRESSURE);
float ldr_value;
  SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_LDR);
  ldr_value=SensorAgrV20.readValue(SENS_AGR_LDR);
  delay(100);
 SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_LDR);
float value_anemometer=0;
 SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_ANEMOMETER);
delay(1000);
 value_anemometer=SensorAgrV20.readValue(SENS_AGR_ANEMOMETER);
SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_ANEMOMETER);
float value_vane=0;
SensorAgrV20.setSensorMode(SENS_ON,SENS_AGR_VANE);
delay(100);
value_vane=SensorAgrV20.readValue(SENS_AGR_VANE);




  // Turn off the sensor
  SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_VANE);
  
  // Part 2: USB printing 
  switch(SensorAgrV20.vane_direction)
  {
    case  SENS_AGR_VANE_N   :  USB.println("N");
                               break;
    case  SENS_AGR_VANE_NNE :  USB.println("NNE");
                               break;
    case  SENS_AGR_VANE_NE  :  USB.println("NE");
                               break;
    case  SENS_AGR_VANE_ENE :  USB.println("ENE");
                               break;
    case  SENS_AGR_VANE_E   :  USB.println("E");
                               break;
    case  SENS_AGR_VANE_ESE :  USB.println("ESE");
                               break;
    case  SENS_AGR_VANE_SE  :  USB.println("SE");
                               break;
    case  SENS_AGR_VANE_SSE :  USB.println("SSE");
                               break;
    case  SENS_AGR_VANE_S   :  USB.println("S");
                               break;
    case  SENS_AGR_VANE_SSW :  USB.println("SSW");
                               break;
    case  SENS_AGR_VANE_SW  :  USB.println("SW");
                               break;
    case  SENS_AGR_VANE_WSW :  USB.println("WSW");
                               break;
    case  SENS_AGR_VANE_W   :  USB.println("W");
                               break;
    case  SENS_AGR_VANE_WNW :  USB.println("WNW");
                               break;
    case  SENS_AGR_VANE_NW  :  USB.println("WN");
                               break;
    case  SENS_AGR_VANE_NNW :  USB.println("NNW");
                               break;
  }

 //char tempstring[] = "";
  
USB.print("temperature: ");
USB.print(value_temperature);

USB.println(" C");
USB.print("humidity: ");
USB.print(humidity_value);
USB.println(" %RH");

USB.print("Pressure: ");

USB.print(value_pressure);
USB.println(" kPa");

USB.print("Luminosity: ");
USB.print(ldr_value);
USB.println(" V");
USB.print("Anemometer: ");
USB.print(value_anemometer);
USB.println("km/h");

USB.print("vane");
USB.print(value_vane);
USB.println("Wind direction");
  switch(SensorAgrV20.vane_direction)
  {
    case  SENS_AGR_VANE_N   :  USB.println("N");
                               break;
    case  SENS_AGR_VANE_NNE :  USB.println("NNE");
                               break;
    case  SENS_AGR_VANE_NE  :  USB.println("NE");
                               break;
    case  SENS_AGR_VANE_ENE :  USB.println("ENE");
                               break;
    case  SENS_AGR_VANE_E   :  USB.println("E");
                               break;
    case  SENS_AGR_VANE_ESE :  USB.println("ESE");
                               break;
    case  SENS_AGR_VANE_SE  :  USB.println("SE");
                               break;
    case  SENS_AGR_VANE_SSE :  USB.println("SSE");
                               break;
    case  SENS_AGR_VANE_S   :  USB.println("S");
                               break;
    case  SENS_AGR_VANE_SSW :  USB.println("SSW");
                               break;
    case  SENS_AGR_VANE_SW  :  USB.println("SW");
                               break;
    case  SENS_AGR_VANE_WSW :  USB.println("WSW");
                               break;
    case  SENS_AGR_VANE_W   :  USB.println("W");
                               break;
    case  SENS_AGR_VANE_WNW :  USB.println("WNW");
                               break;
    case  SENS_AGR_VANE_NW  :  USB.println("WN");
                               break;
    case  SENS_AGR_VANE_NNW :  USB.println("NNW");
                               break;
  }
 
 
 // Getting Temperature from internal waspmote
  USB.print("Temperature: ");
  USB.println(RTC.getTemperature(),DEC);  
  }
     gprs();                                                                                                                                                            

clearIntFlag();
//gprs();   ///logika na mpei mesa sto if RTC INT twn getting values??
delay(5000);
}
void gprs(){
// setup for Serial port over USB:
    USB.begin();
    USB.println(F("USB port started..."));
int answer;
    // activates the GPRS_Pro module:
    answer = GPRS_Pro.ON(); 
    if ((answer == 1) || (answer == -3)) ///edw pali to -3 de ksero apo pou
    { 
        USB.println(F("GPRS_Pro module ready..."));
    
        // sets pin code:
   //     USB.println(F("Setting PIN code..."));
        // **** must be substituted by the SIM code
        
       // waits for connection to the network:
        answer = GPRS_Pro.check(180);    
        if (answer == 1)
        {
             
            USB.println(F("GPRS_Pro module connected to the network..."));
        
            // configures GPRS connection for HTTP or FTP applications:
            answer = GPRS_Pro.configureGPRS_HTTP_FTP(1);
            if (answer == 1)
            {
                USB.print(F("Get the URL..."));
               
             
                d1=humidity_value;
                sprintf(aux_str, "http://pruebas.libelium.com/test-get-post.php?counter=%d&temp=%d.%02d", counter, d1, d2);
                answer = GPRS_Pro.readURL(aux_str, 1);
                // gets URL from the solicited URL
                if ( answer == 1)
                {
                    USB.println(F("Done"));  
                    USB.println(GPRS_Pro.buffer_GPRS);
                }
                else if (answer < -9)
                {
                    USB.print(F("Failed. Error code: "));
                    USB.println(answer, DEC);
                    USB.print(F("CME error code: "));
                    USB.println(GPRS_Pro.CME_CMS_code, DEC);
                }
                else 
                {
                    USB.print(F("Failed. Error code: "));
                    USB.println(answer, DEC);
                }
                       
            }
            else
            {
                USB.println(F("Configuration 1 failed. Error code: "));
                USB.println(answer, DEC);
            }
        }
        else
        {
            USB.println(F("GPRS_Pro module cannot connect to the network"));     
        }
    }
    else
    {
        USB.println(F("GPRS_Pro module not ready"));    
    }

    GPRS_Pro.OFF(); // powers off the GPRS_Pro module
    counter++;
}



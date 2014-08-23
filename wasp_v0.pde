  boolean flag;
  float humidity_value = 0;
  // use for average float temp[10];
  float temperatures[10];
  float value_pluviometer=0;
  float value_temperature=0;
  float value_pressure=0;
   float ldr_value;
    float value_anemometer=0;
    float value_vane=0;
     char *direction;
  // Variable to store the number of pulviometer pulses
long pluviometerCounter = 0;

// Variable to store the precipitations value
float pluviometer;
  //h
  //char* direction[3];
  int answer;
  
  char aux_str[150];
  
  unsigned int counter = 0;
  
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
  
  //RTC.ON();??
  
    SensorAgrV20.sleepAgr("00:00:00:10",RTC_OFFSET,RTC_ALM1_MODE1,UART0_OFF|UART1_OFF|BAT_OFF,SENS_AGR_PLUVIOMETER);
    //SensorAgrV20.attachPluvioInt();
  SensorAgrV20.detachPluvioInt(); 
      // Go to sleep disconnecting all the switches and modules
      // After 10 seconds, Waspmote wakes up thanks to the RTC Alarm
  //PWR.deepSleep("00:00:00:10",RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);
  flag=false;
  USB.begin();
  //pluviometer inter
  if(intFlag & PLV_INT)
  {
    USB.println(("---------------------"));
          USB.println(("pluviometer interrupts"));
          USB.println(("---------------------"));
          pluviometerCounter++;
    //read
    delay(100);
    value_pluviometer=SensorAgrV20.readValue(SENS_AGR_PLUVIOMETER);//returns rain per minute (mm/min). 
    //http://www.libelium.com/forum/viewtopic.php?f=15&t=1440
    //also see http://www.libelium.com/forum/viewtopic.php?f=15&t=10611
    
    
    USB.println("pluviometer: ");
    USB.println(value_pluviometer);//
    //send data again with pluv measure
    //edw kathe paradeigma leei kai ta dika tou 
    
   /* // we notify the drops and mm in the period of time
    USB.print(" - Number of drops in the period: ");
    USB.println(drop_counter - 1);
    USB.print("mm of water in the period: ");
    USB.println(0.28 * (drop_counter - 1));
    USB.println();
    drop_counter = 0;*/
    
    // Convert the number of interruptions received into mm of rain
  pluviometer = float(pluviometerCounter) * 0.2794;  
  
  // Print the accumulated rainfall
  USB.print("Accumulated rainfall: ");
  USB.print(pluviometer);
  USB.println("mm");
  
  
  
 
clearIntFlag();//an de to stamatisw me to clearintflag de stamataei
   // flag=true;
    //enableInterrupts(PLV_INT);//
    
    //TODO otan arxisei na brexei as trexei kai ta alla measurements giati an de statamatisei na brexei de stamatane ta interrupts
//readSensors();  

}
  
  //otan parei RTC interruption kathe 10sec i otan arxisei na brexei?i an alliws metrame ta counts apo ta interrupts an eixe breksei sto distima pou perase
 else if( intFlag & RTC_INT )//||flag)
      {
          USB.println(("---------------------"));
          USB.println(("RTC INT captured"));
          USB.println(("---------------------"));
          Utils.blinkLEDs(300);
          Utils.blinkLEDs(300);
          Utils.blinkLEDs(300);
          intFlag &= ~(RTC_INT);
   
   flag=false;
   
   /* // we notify the drops and mm in the period of time 10secpx
    USB.print(" - Number of drops in the period: ");
    USB.println(drop_counter - 1);
    USB.print("mm of water in the period: ");
    USB.println(0.28 * (drop_counter - 1));
    USB.println();
    drop_counter = 0;*/
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
 
    SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_LDR);
    ldr_value=SensorAgrV20.readValue(SENS_AGR_LDR);
    delay(100);
   SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_LDR);
 
   SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_ANEMOMETER);
  delay(1000);
   value_anemometer=SensorAgrV20.readValue(SENS_AGR_ANEMOMETER);
  SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_ANEMOMETER);
  
  SensorAgrV20.setSensorMode(SENS_ON,SENS_AGR_VANE);
  delay(100);
  value_vane=SensorAgrV20.readValue(SENS_AGR_VANE);
  
  
  
  
    // Turn off the sensor
    SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_VANE);
    
    switch(SensorAgrV20.vane_direction)
    {
      case  SENS_AGR_VANE_N   :  USB.println("N");
      direction="N";
                                 break;
      case  SENS_AGR_VANE_NNE :  USB.println("NNE");
      direction="NNE";
                                 break;
      case  SENS_AGR_VANE_NE  :  USB.println("NE");
      direction="NE";
                                 break;
      case  SENS_AGR_VANE_ENE :  USB.println("ENE");
      direction="ENE";
                                 break;
      case  SENS_AGR_VANE_E   :  USB.println("E");
      direction="E";
                                 break;
      case  SENS_AGR_VANE_ESE :  USB.println("ESE");
      direction="ESE";
                                 break;
      case  SENS_AGR_VANE_SE  :  USB.println("SE");
      direction="SE";
                                 break;
      case  SENS_AGR_VANE_SSE :  USB.println("SSE");
      direction="SSE";
                                 break;
      case  SENS_AGR_VANE_S   :  USB.println("S");
      direction="S";
                                 break;
      case  SENS_AGR_VANE_SSW :  USB.println("SSW");
      direction="SSW";
                                 break;
      case  SENS_AGR_VANE_SW  :  USB.println("SW");
      direction="SW";
                                 break;
      case  SENS_AGR_VANE_WSW :  USB.println("WSW");
      direction="WSW";
                                 break;
      case  SENS_AGR_VANE_W   :  USB.println("W");
      direction="W";
                                 break;
      case  SENS_AGR_VANE_WNW :  USB.println("WNW");
      direction="WNW";
                                 break;
      case  SENS_AGR_VANE_NW  :  USB.println("WN");
      direction="WN";
                                 break;
      case  SENS_AGR_VANE_NNW :  USB.println("NNW");
      direction="NNW";
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
 
    
   
   
   // Getting Temperature from internal waspmote
    USB.print("Temperature: ");
    USB.println(RTC.getTemperature());
  
  //send data gprs
  clearIntFlag();

  
  gprs();
  
 // 
    }
                                                                                                                                                             
  
  
    
  delay(5000);
  }
  void gprs(){
  
    USB.print("temperature: ");
  USB.print(value_temperature);
  
  
    // setup for GPRS_Pro serial port
    GPRS_Pro.ON();
    USB.println("GPRS_Pro module ready...");
      
    // waiting while GPRS_Pro connects to the network
    while(!GPRS_Pro.check(180));
    USB.println("GPRS_Pro connected to the network");
    if(GPRS_Pro.configureGPRS_TCP_UDP(SINGLE_CONNECTION,NON_TRANSPARENT)){
          USB.print("Configured OK. \nIP dir: ");
          USB.println(GPRS_Pro.IP_dir);
      }else{
          USB.println("Configuration failed");
      } 
    USB.print("Opening TCP socket...");  
      if(GPRS_Pro.createSocket(TCP_CLIENT,"mtp.doeyetea.eu","8080")){ // * should be replaced by the desired IP direction and $ by the port
          USB.println("Conected");
      }else{
          USB.println("Error opening the socket");
      }
      
  char aux_str[300];
  
  
  
  float s=RTC.getTemperature();
                  s++;
                  
       //convert from float to string
     char buffer_temp[10];
  //dtostrf(value_temperature, 5, 2, buffer_temp);  
  dtostrf(s, 5, 2, buffer_temp);
   char buffer_pressure[10];
  dtostrf(value_pressure, 5, 2, buffer_pressure);
  char buffer_value_anemometer[10];
  dtostrf(value_anemometer, 5, 2, buffer_value_anemometer);
  char buffer_value_pluviometer[10];
  dtostrf(value_pluviometer, 5, 2, buffer_value_pluviometer);
  
  //TODO in general check buffer size in waspgprs_pro.h
  //print freememory
  //
  
  //yparxei thema me to %f gia float sto sprintf etsi to pairnw kai to kanw string  
    sprintf(aux_str, "{\"measurements\":[{\"moduleID\":3,\"value\":\"%s\"},{\"moduleID\":4,\"value\":\"%s\"},{\"moduleID\":5,\"value\":\"%s\"},{\"moduleID\":6,\"value\":\"%s\"}]}",direction, buffer_temp,buffer_value_pluviometer,buffer_value_anemometer);
   USB.println(aux_str);
   int str_length;   
       str_length=strlen(aux_str);
      char content_length[300];
      USB.print("Sending test string...");  
      USB.print(str_length);
    sprintf(content_length,"Content-Length: %d\r\n",str_length);  
      if(GPRS_Pro.sendData("POST /gmswar/gms/saveMS HTTP/1.1\r\n" )&&
      //GPRS_Pro.sendData("Content-Length: 300\r\n" )&&
      GPRS_Pro.sendData(content_length )&&
      GPRS_Pro.sendData("Content-Type: application/json\r\n" )&&
      GPRS_Pro.sendData("\r\n" )&&
    //GPRS_Pro.sendData("{\"measurements\":[{\"moduleID\":3,\"value\":\"stelios1\"},{\"moduleID\":4,\"value\":\"25\"},{\"moduleID\":5,\"value\":\"4\"},{\"moduleID\":6,\"value\":\"25\"}]}" )
      GPRS_Pro.sendData(aux_str)
      ){
          USB.println("Sended");
          
           USB.println(GPRS_Pro.buffer_GPRS);
           delay(30);
           
      }else{
          USB.println("Failed sending");
      }
      
      // Close socket
      USB.print("Closing TCP socket...");  
      if(GPRS_Pro.closeSocket()){
          USB.println("Closed");
      }else{
          USB.println("Failed closing");
      }
  counter++;
    delay(2000);
    GPRS_Pro.OFF(); // powers off the GPRS_Pro module
      
      USB.println(F("Sleeping..."));
  
  }
  
 /*
 int index;
 for (int i=1; i<10; i++) 
      {
          temperatures[0] = temperatures[0] + temperatures[i];
      }
      temperatures[0] = temperatures[0] / 10 ;
      USB.print("measureTemperature(): ");
      USB.println(temperatures[0]); 
  */
  void readSensors(){///get sensor values every 1minute?then report every 15-20?i real time
  //READ SENSORS except pluv
   
   
    SensorAgrV20.setSensorMode(SENS_ON,SENS_AGR_TEMPERATURE);
   delay(2000); //waiting
    value_temperature=SensorAgrV20.readValue(SENS_AGR_TEMPERATURE);
   //temperatures[index]=value_temperature;
   //index++;
  
  
  
    SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_TEMPERATURE);
  
  
  
  
     SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_HUMIDITY);
     delay(1500);
     humidity_value = SensorAgrV20.readValue(SENS_AGR_HUMIDITY);
     SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_HUMIDITY);
  
  	SensorAgrV20.setSensorMode(SENS_ON,SENS_AGR_PRESSURE);
   delay(1000);
       value_pressure=SensorAgrV20.readValue(SENS_AGR_PRESSURE);
  SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_PRESSURE);
 
    SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_LDR);
    ldr_value=SensorAgrV20.readValue(SENS_AGR_LDR);
    delay(100);
   SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_LDR);
 
   SensorAgrV20.setSensorMode(SENS_ON, SENS_AGR_ANEMOMETER);
  delay(1000);
   value_anemometer=SensorAgrV20.readValue(SENS_AGR_ANEMOMETER);
  SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_ANEMOMETER);
  
  SensorAgrV20.setSensorMode(SENS_ON,SENS_AGR_VANE);
  delay(100);
  value_vane=SensorAgrV20.readValue(SENS_AGR_VANE);
  
  
  
  
    // Turn off the sensor
    SensorAgrV20.setSensorMode(SENS_OFF, SENS_AGR_VANE);
    
    switch(SensorAgrV20.vane_direction)
    {
      case  SENS_AGR_VANE_N   :  USB.println("N");
      direction="N";
                                 break;
      case  SENS_AGR_VANE_NNE :  USB.println("NNE");
      direction="NNE";
                                 break;
      case  SENS_AGR_VANE_NE  :  USB.println("NE");
      direction="NE";
                                 break;
      case  SENS_AGR_VANE_ENE :  USB.println("ENE");
      direction="ENE";
                                 break;
      case  SENS_AGR_VANE_E   :  USB.println("E");
      direction="E";
                                 break;
      case  SENS_AGR_VANE_ESE :  USB.println("ESE");
      direction="ESE";
                                 break;
      case  SENS_AGR_VANE_SE  :  USB.println("SE");
      direction="SE";
                                 break;
      case  SENS_AGR_VANE_SSE :  USB.println("SSE");
      direction="SSE";
                                 break;
      case  SENS_AGR_VANE_S   :  USB.println("S");
      direction="S";
                                 break;
      case  SENS_AGR_VANE_SSW :  USB.println("SSW");
      direction="SSW";
                                 break;
      case  SENS_AGR_VANE_SW  :  USB.println("SW");
      direction="SW";
                                 break;
      case  SENS_AGR_VANE_WSW :  USB.println("WSW");
      direction="WSW";
                                 break;
      case  SENS_AGR_VANE_W   :  USB.println("W");
      direction="W";
                                 break;
      case  SENS_AGR_VANE_WNW :  USB.println("WNW");
      direction="WNW";
                                 break;
      case  SENS_AGR_VANE_NW  :  USB.println("WN");
      direction="WN";
                                 break;
      case  SENS_AGR_VANE_NNW :  USB.println("NNW");
      direction="NNW";
                                 break;
    }
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
 
    
  }
  


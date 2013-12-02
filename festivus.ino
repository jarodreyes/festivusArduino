#include <SPI.h>
#include <Ethernet.h>
#include <PusherClient.h>

// Constants representing Pins on the Arduino
#define RED    6 
#define GREEN  9
#define BLUE   5

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
PusherClient client;
long k;

void setup() {
  pinMode(RED, OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);

  // We'll default to pink.
  analogWrite(RED, 80);
  analogWrite(GREEN, 0);
  analogWrite(BLUE, 0);
  
  Serial.begin(9600);
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Init Ethernet failed");
    for(;;)
      ;
  }
  // paste next block of code here.
  if(client.connect("your-pusher-key")) {
    client.bind("blue", blue);
    client.bind("red", red);
    client.bind("green", green);
    client.bind("owl", brown);
    client.subscribe("festivus_channel");
  }
  else {
    while(1) {}
  }
}

//paste loop function here
void loop() {
  if (client.connected()) {
    client.monitor();
    Serial.println("Client connected.");
  }
  else {
    Serial.println("Client error connecting.");
  }
}

// paste color functions here
void blue(String data) {
  analogWrite(RED, 30);
  analogWrite(GREEN, 144);
  analogWrite(BLUE, 255);
}

void red(String data) {
  analogWrite(RED, 255);
  analogWrite(GREEN, 0);
  analogWrite(BLUE, 0);
}

void green(String data) {
  analogWrite(RED, 124);
  analogWrite(GREEN, 252);
  analogWrite(BLUE, 0);
}

void brown(String data) {
  analogWrite(RED, 139);
  analogWrite(GREEN, 69);
  analogWrite(BLUE, 19);
}
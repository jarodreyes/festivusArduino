#include <SPI.h>
#include <Ethernet.h>
#include <PusherClient.h>

// Constants representing Pins on the Arduino
#define RED    6 
#define GREEN  9
#define BLUE   5
#define FADESPEED 5

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
PusherClient client;
long k;

void setup() {
  pinMode(RED, OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);

  // We'll default to pink.
  analogWrite(RED, 0);
  analogWrite(GREEN, 0);
  analogWrite(BLUE, 0);
  fade();
  
  Serial.begin(9600);
  if (Ethernet.begin(mac) == 0) {
    Serial.println("Init Ethernet failed");
    for(;;)
      ;
  }
  // paste next block of code here.
  if(client.connect("3c75ce0c7941ced00a14")) {
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

void fade() {
  int r, g, b;
  // fade from white to blue
  for (b = 0; b < 256; b++) { 
    analogWrite(BLUE, b);
    delay(FADESPEED);
  }
  // fade from blue to violet
  for (r = 0; r < 256; r++) { 
    analogWrite(RED, r);
    delay(FADESPEED);
  } 
  // fade from violet to red
  for (b = 255; b > 0; b--) { 
    analogWrite(BLUE, b);
    delay(FADESPEED);
  } 
  // fade from red to yellow
  for (g = 0; g < 256; g++) { 
    analogWrite(GREEN, g);
    delay(FADESPEED);
  } 
  // fade from yellow to green
  for (r = 255; r > 0; r--) { 
    analogWrite(RED, r);
    delay(FADESPEED);
  } 
  // fade from green to teal
  for (b = 0; b < 256; b++) { 
    analogWrite(BLUE, b);
    delay(FADESPEED);
  } 
  // fade from teal to blue
  for (g = 255; g > 0; g--) { 
    analogWrite(GREEN, g);
    delay(FADESPEED);
  }
  // fade from blue to white
  for (b = 0; b < 256; b++) { 
    analogWrite(RED, b);
    analogWrite(GREEN, b);
    delay(FADESPEED);
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
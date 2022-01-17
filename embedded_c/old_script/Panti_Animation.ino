#include <Adafruit_GFX.h>
#include <Adafruit_NeoMatrix.h>
#include <Adafruit_NeoPixel.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
ESP8266WebServer server(80);
void handleColour();
void handle404();


#define PIN D2
#define WIFI_USERNAME YOUR_USERNAME
#define WIFI_PASSWORD YOUR_PASSWORD

int delayValue=500;
int i;
//the Wemos WS2812B RGB shield has 1 LED connected to pin 2
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(300, PIN, NEO_GRB + NEO_KHZ800);

void setup()
{
  pixels.begin(); // This initializes the NeoPixel library.

  //WiFi-Setup
    Serial.begin(9600);
    WiFi.begin(WIFI_USERNAME, WIFI_PASSWORD);
    Serial.print("Connecting");
    while (WiFi.status() != WL_CONNECTED)
    {
      delay(500);
      Serial.print(".");
    }
    Serial.println();

    Serial.print("Connected, IP address: ");
    Serial.println(WiFi.localIP());

    //Server-Setup
    server.on("/colour", HTTP_POST, handleColour);
    server.onNotFound(handle404);

    server.begin();

}


void loop()
{
   server.handleClient();

}

//simple function which takes values for the red, green and blue led and also
//a delay


void handleColour(){
  if (!server.hasArg("r") || !server.hasArg("g") || !server.hasArg("b") ||
      server.arg("r") == NULL || server.arg("g") == NULL || server.arg("b") == NULL){
        server.send(400, "text/plain", "400: Invalid Request");
        return;
      }

     for(i=5; i<300; i++)
     {
          setPixelColor(
              i,
              pixels.Color(
                 server.arg("r").toInt(),
                 server.arg("g").toInt(),
                 server.arg("b").toInt()
               )
          );
     }

     pixels.show();
     delay(delayValue);

   Serial.println(server.arg("r"));
   server.send(200);
}

void handle404(){
  server.send(404, "text/plain", "404: Not found");
}

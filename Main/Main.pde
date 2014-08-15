import processing.serial.*;
import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context


Serial myPort;        // The serial port

int sizeX = 1024;
int sizeY = 768;
int sizeFont = 72;

String formatter = "";
PFont myFont;

int startTime = 0;
int endTime = 0;
int currentTime = 0;
int raceTime = 0;
int timeSinceFinish = 0;
int scoreAdded = 1;

int[] highscores = new int[5];
String scorer = "???";
String[] highscorer = new String[5];

void setup () {
  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, "/dev/tty.usbmodem1d1111", 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  
  //for sound
  minim = new Minim(this);
  player = minim.loadFile("Applause.mp3", 2048);
  
  size(sizeX, sizeY);        
  background(0);
  //frameRate(100);
  //String[] fontList = PFont.list();
  //println(fontList);
  myFont = createFont("HelveticaCondensed", 32);
  textFont(myFont);
  textSize(sizeFont);
  textAlign(RIGHT);
  
  // highscores
  for (int i=0; i<highscores.length; i++) {
    highscores[i] = 99990;
  }
  highscorer[0] = "???";
  highscorer[1] = "???";
  highscorer[2] = "???";
  highscorer[3] = "???";
  highscorer[4] = "???";
}

void draw() {
    background(0);
    if (startTime != 0) {
      currentTime = (millis()-startTime);
      if (endTime == 0) {
        formatter = nf(float(currentTime)/1000, 2, 2);
        text(formatter, (sizeX/2)+50, sizeY/2);
      }
      if (currentTime >= 99990) {
        endTime = 0;
        startTime = 0;
      }
    }
    else {
        timeSinceFinish = millis()-endTime;
        if (timeSinceFinish <= 5000)  {
          // shows players time
          formatter = nf(float(raceTime)/1000, 2, 2);
          text(formatter, (sizeX/2)+50, sizeY/2);
          if (endTime != 0) {
            textSize(36);
            text("Your time :",(sizeX/2)+50, (sizeY/2)-(sizeFont+5));
            textSize(72);
          }
          for (int i=0; i < highscores.length; i++) {
            if (raceTime <= highscores[i]) {
              textSize(36);
              text("Enter initials:", (sizeX/2)+50,(sizeY/2)+1*(sizeFont+5));
              textSize(72);
              text(scorer,(sizeX/2)+50, (sizeY/2)+2*(sizeFont+5));
            }
          }
        }
        else if (timeSinceFinish <= 10000) {
          // enters score
          if (scoreAdded == 0) {
            addNewScore(raceTime);
            scoreAdded = 1;
          }
          // shows highscores board
          text("Highscores: ", (sizeX/2)+50, (sizeFont+5)+5);
          for (int i=0; i<highscores.length; i++) {
            text(highscorer[i], (sizeX/2)+10, (i+2)*(sizeFont+5)+5);
            formatter = nf(float(highscores[i])/1000, 2, 2);
            text(formatter, (sizeX/2)+300, (i+2)*(sizeFont+5)+5);
          }
        }
        else {
          currentTime = 0;
          //formatter = nf(float(currentTime)/1000, 2, 2);
          //text(formatter, 250, 150);
          textAlign(CENTER);
          text("Ready?",(sizeX/2)+0, (sizeY/2)-1*(sizeFont+5));
          text("Set.",(sizeX/2)+0, (sizeY/2)+0*(sizeFont+5));
          text("CLIMB!",(sizeX/2)+0, (sizeY/2)+1*(sizeFont+5));
          textAlign(RIGHT);
        }
    }
}

void keyPressed() {
 if (keyCode == UP) {
    startTime = millis();
    background(0);
    endTime = 0;
    raceTime = 0;
    scoreAdded = 1;
    scorer = "???";
    //player = minim.loadFile("Applause.mp3", 2048);
    player.close();
    player = minim.loadFile("Applause.mp3", 2048);
    player.play();
  }
 else if (keyCode == DOWN && raceTime == 0) {
    endTime = millis();
    raceTime = (endTime - startTime);
    startTime = 0;
    scoreAdded = 0;
    //player = minim.loadFile("Applause.mp3", 2048);
    player.close();
    player = minim.loadFile("Running.mp3", 2048);
    player.play();
 }
  
   // If the key is between 'A'(65) to 'Z' and 'a' to 'z'(122)
 if((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) {
   if (scorer == "???") {
     scorer = "";
   }
   scorer = scorer + key;
   scorer = scorer.toUpperCase();
   if (scorer.length() > 3) {
     scorer = "???";
   }
 }
}

void serialEvent (Serial myPort) {
   // get the ASCII string:
   String inString = myPort.readStringUntil('\n');
   
   if (inString != null) {
   // trim off any whitespace:
   inString = trim(inString);
   int inByte = int(inString);
   
   switch(inByte) {
     case 1: 
          startTime = millis();
          background(0);
          endTime = 0;
          raceTime = 0;
          scoreAdded = 1;
          scorer = "???";
          //player = minim.loadFile("Applause.mp3", 2048);
          player.close();
          player = minim.loadFile("Applause.mp3", 2048);
          player.play();
          break;
     case 2:
       if (raceTime == 0) {
          endTime = millis();
          raceTime = (endTime - startTime);
          startTime = 0;
          scoreAdded = 0;
          //player = minim.loadFile("Applause.mp3", 2048);
          player.close();
          player = minim.loadFile("Running.mp3", 2048);
          player.play();
          break;
       }
   }
   }
 }

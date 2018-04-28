import processing.serial.*;
import cc.arduino.*;

int NUM_PINS = 53;       // Total pins on Arduino Mega
int FRAME_DELAY = 100;   // Delay between frames (in milliseconds)
int SHIFT_DELAY = 50;    // Delay between pattern shifts (in frames)
int NUM_TAPPERS = 6;     // Number of Tappers

// List of pins for each Tapper
// First number for solenoid pin, the rest for LED pins
int[] PINS_0 = {1, 2, 3, 4, 5, 6, 7, 8};
int[] PINS_1 = {1, 2, 3, 4, 5, 6, 7, 8};
int[] PINS_2 = {1, 2, 3, 4, 5, 6, 7, 8};
int[] PINS_3 = {1, 2, 3, 4, 5, 6, 7, 8};
int[] PINS_4 = {1, 2, 3, 4, 5, 6, 7, 8};
int[] PINS_5 = {1, 2, 3, 4, 5, 6, 7, 8};
int[][] PINS = {PINS_0, PINS_1, PINS_2, PINS_3, PINS_4, PINS_5};

int frameCounter = 0;
int shiftCounter = 0;

Tapper[] tapperArray;
Pattern[] patternList;
Arduino arduino;

void setup() {
  
  size(470, 200);
  
  // Prints available serial ports, Need to change [0] to wanted port number.
  println(Arduino.list());                                
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  // Set all arduino pins to OUTPUT
  for (int i=0; i <= NUM_PINS; i++)
    arduino.pinMode(i, Arduino.OUTPUT);
  
  // Create an array of Tapper objects
  tapperArray = new Tapper[NUM_TAPPERS];
  for (int i=0; i < NUM_TAPPERS; i++)
    tapperArray[i] = new Tapper(PINS[i].length - 1);
  
  // Parse and set patterns
  parsePatterns();
  setPatterns(0);
  
}

// Parse patterns from txt file to an array of pattern objects
void parsePatterns() {
  String[] lines;
  lines = loadStrings("patterns.txt");
  patternList = new Pattern[lines.length];
  for (int i=0; i < lines.length; i++) {
    patternList[i] = new Pattern();
    patternList[i].setSeq(lines[i]);
  }
}

// Setting of patterns for all LEDs, starting from certain index of patternList
void setPatterns(int index) {
  int counter = index;
  for (int i=0; i < NUM_TAPPERS; i++) {
    for (int j=0; j < PINS[i].length - 1; j++){
      tapperArray[i].setPattern(patternList[counter % patternList.length], j);
      counter++;
    }
  }
}

// Function to set LED pins low/high based on array of boolean values
void setLedPins(int tapperNum, boolean[] values) {
  for (int i=0; i < PINS[tapperNum].length ; i++)
    if (values[i] == true)
      arduino.digitalWrite(PINS[tapperNum][i], Arduino.HIGH);
    else
      arduino.digitalWrite(PINS[tapperNum][i], Arduino.LOW);
}


void loop() {
  
  if (frameCounter == SHIFT_DELAY) {
    setPatterns(shiftCounter);
    shiftCounter++;
    if (shiftCounter == patternList.length)
      shiftCounter = 0;
  }
    
  for (int i=0; i < NUM_TAPPERS; i++) {
    tapperArray[i].advanceOneFrame();
    setLedPins(i, tapperArray[i].getLedStates());
  }
  frameCounter++;
  
}
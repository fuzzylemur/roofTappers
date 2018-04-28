// Class representing an individual Tapper object.
class Tapper {
  
  int numLeds;
  int counter;
  Pattern[] patArray;
  boolean[] ledStates;
  boolean solState;    // For later use
  
  // Create a new Tapper object with given number of LEDs
  Tapper(int leds) {
    
    solState = false;
    numLeds = leds;
    patArray = new Pattern[numLeds];
    ledStates = new boolean[numLeds];
    
    for (int i=0; i < numLeds; i++) {
      patArray[i] = new Pattern();
      ledStates[i] = false;
    }
  }
  
  // Function for setting one LED to a specific Pattern
  void setPattern(Pattern patt, int ledNum) {
    patArray[ledNum] = patt;
  }
  
  // Function for updating led states and advancing one frame in the sequence
  void advanceOneFrame() {
    
    for (int i=0; i < numLeds; i++)
      ledStates[i] = patArray[i].getValue(counter);
    
    counter++;
    if (counter == Pattern.PAT_SIZE)
      counter = 0;
  }
  
  // Function for getting the array of led states
  boolean[] getLedStates() {return ledStates;}
  
  // Function for getting number of LEDs on tapper
  int getNumLeds() {return numLeds;}
}
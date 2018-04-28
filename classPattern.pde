
// Class representing a pattern of on/off flashes
class Pattern {
  
  static final char ON_CHAR = '0';
  static final int PAT_SIZE = 64;
  boolean[] patSeq;
  
  // Create a new pattern object
  Pattern() {
    patSeq = new boolean[PAT_SIZE];
  }
  
  // Set pattern sequence based on input String
  void setSeq(String patStr) {
    for (int i=0; i < PAT_SIZE; i++) {
      if (patStr.charAt(i) == ON_CHAR)
        patSeq[i] = true;
      else
        patSeq[i] = false;
    }
  }
  
  // Get a value from the pattern sequence at a specific index
  boolean getValue(int index) {return patSeq[index];}
 
}
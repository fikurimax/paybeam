#include <LiquidCrystal_I2C.h>

// set the LCD number of columns and rows
int lcdColumns = 16;
int lcdRows = 2;

// set LCD address, number of columns and rows
// if you don't know your display address, run an I2C scanner sketch
LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows);

#define LDR_PIN A1
#define charLength 9
#define bitLength 8
const int uDelay = 150;    //pulse width in ms
const int ref = 50;        //ldr HIGH cutoff val
int bits[charLength][bitLength];
int val=0;

void setup() {
  Serial.begin(115200);

  // initialize LCD
  lcd.init();
  // turn on LCD backlight                      
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("Isi pesan");
}

void loop() {
  val = analogRead(LDR_PIN);
  if(val>ref){
    startListening(val);
    printChar(bits);
    Serial.println();
    // Print the array elements:
    for (int i = 0; i < charLength; i++) {
      for (int ii = 0; ii < bitLength; ii++) {
        Serial.print(bits[i][ii]);
        Serial.print(""); // Print a space between elements
      }
      printf("(%s)", (char) getRune(bits, i));
      Serial.print(" ");
    }
    Serial.println();
  }
}

//reads the incoming signal and stores to bits[] array
void startListening(int treshold){
  delay(uDelay); // mark the first beam to be the sync request
  for(int i = 0; i < charLength; i++) {
    for(int ii = 0; ii < bitLength; ii++){
      if (ii == 0) {
        bits[i][0] = 0;
        delay(uDelay);
        continue;
      }
      if(analogRead(LDR_PIN) >= treshold) bits[i][ii]=1;
      else bits[i][ii]=0;
      delay(uDelay);
    }

    delay(uDelay);
  }
}

int getRune(int x[charLength][bitLength], int index) {
  return x[index][0]*128 + x[index][1]*64 + x[index][2]*32 + x[index][3]*16 +x[index][4]*8 +x[index][5]*4 +x[index][6]*2 +x[index][7];
}

//a very simple binay to decimal covertor
void printChar(int x[charLength][bitLength]){
  lcd.setCursor(0,1);
  for (int i = 0; i < charLength; i++) {
    lcd.print((char) getRune(x, i));
  }
}
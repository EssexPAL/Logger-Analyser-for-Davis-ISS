/*
   Last Modified Time: March 14, 2026 at 7:24:03 AM
*/

#include <Arduino.h>

class flashLED {
    public:

        flashLED() { // consructor
            count = -1;
            mode = 0;
        };

        void setIO(uint8_t ioNumber) {
            ioNo = ioNumber;
            pinMode(ioNo, OUTPUT);
            digitalWrite(ioNo, LOW);
        }

        void flash(uint8_t per) {
            digitalWrite(ioNo, HIGH);
            half = per / 2;
            period = per;
            mode = 1;
            count = 0;
        };
    
        void pulse(uint8_t onVal) {
            digitalWrite(ioNo, HIGH);
            count = onVal;
            mode = 2;
        };

        void on() {
            digitalWrite(ioNo, HIGH);
            mode = 0;
        }

         void off() {
            digitalWrite(ioNo, LOW);
            mode = 0;
        };

        void tick() {
//            Serial.printf("Tick io: %d, mode: %d, count: %d\n", ioNo, mode, count);
            switch (mode) {
                case 1: // flash
                        if (count == 0) 
                            digitalWrite(ioNo, HIGH);
                        else if (count == half)
                            digitalWrite(ioNo, LOW);

                        count++;
                        count = count % period;
                        break;
                case 2: // pulse
                        if (count == 0) {
                            digitalWrite(ioNo, LOW);
                            mode = 0;

                        } else
                            count--;
                        break;
                }
            }

    private:
        uint8_t ioNo = 0;
        uint8_t count = -1;
        uint8_t period;
        uint8_t mode; // 0 = on/off, 1 = flash, 2 = pulse
        uint8_t half = 0;
};

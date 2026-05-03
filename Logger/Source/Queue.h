/*
   Last Modified Time: February 18, 2026 at 10:02:38 PM
*/

/* FIFO queue for RemoteQueue objects */

#ifndef QUEUE_h
#define QUEUE_h

//#include "SDfunctions.h"

#define QUEUESIZE 8


class CmdQueue {
    public:

        CmdQueue() { // consructor
            //inIdx = 0;
            //outIdx = 0;
            //count = 0;
            //memset(queue, 0, sizeof(queue));
            flush();
        };

    /*  
    * Pushes the supplied item into the queue.
    */
        bool push(RemoteRequest a) {
            bool ok = false;

            if (count < QUEUESIZE) {
                queue[inIdx] = a;
                count++;
                inIdx++;
                inIdx &= 0x07;
                ok = true;
            }
            return ok;
      };

    /*  
    * Returns the next item in the queue.
    */
        RemoteRequest pop() {
            bool ok = false;
            RemoteRequest remr;

            if (count > 0) {
                count--;
                remr = queue[outIdx];
                outIdx++;
                outIdx &= 0x07;
            }

            return remr;
        };

    /*  
    * Clear all entries in the queue, its count and its index's.
    */
        void flush() {
            inIdx = 0;
            outIdx = 0;
            count = 0;
            memset(queue, 0, sizeof(queue));
        };
        
    /*  
    * Returns the input index.
    */
        uint8_t getInIdx() {
            return inIdx;
        };

    /*  
    * Returns the ouyput index.
    */
        uint8_t getOutIdx() {
            return outIdx;
        };

    /*  
    * Returns the number of items in the queue.
    */
        uint8_t getCount() {
            return count;
        };

    private:
        RemoteRequest queue[QUEUESIZE];
        uint8_t inIdx;
        uint8_t outIdx;
        uint8_t count;
};

#endif
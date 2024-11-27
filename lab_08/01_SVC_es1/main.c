
#include <stdint.h>

// Function prototype
extern void call_svc();

int main(void) {
    // Configure the stack pointer for PSP
    int sp_value = 0x10000200;  // Ensure this value is appropriate for your platform
    __asm volatile("mov sp, %0" :: "r"(sp_value) : );

    // Invoke the Supervisor Call function
    call_svc();

    while (1) {
        // Infinite loop to prevent the program from exiting
    }
}
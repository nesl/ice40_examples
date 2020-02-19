// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2017 by Wilson Snyder.
//======================================================================

// Include common routines
#include <verilated.h>

// Include model header, generated from Verilating "tb.v"
#include "Vtb.h"

// If "verilator --trace" is used, include the tracing class
#if VM_TRACE
# include <verilated_vcd_c.h>
#endif

// Current simulation time (64-bit unsigned)
vluint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}

int main(int argc, char** argv) {

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    Verilated::commandArgs(argc, argv);
    // Set debug level, 0 is off, 9 is highest presently used
    Verilated::debug(0);
    // Randomize values on reset
    Verilated::randReset(2);

    // Construct the Verilated model, from Vtb.h generated from Verilating "tb.v"
    Vpassthrough* tb = new Vpassthrough; // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper

#if VM_TRACE
    // If verilator was invoked with --trace argument,
    // and if at run time passed the +trace argument, turn on tracing
    VerilatedVcdC* tfp = NULL;
    const char* flag = Verilated::commandArgsPlusMatch("trace");
    if (flag && 0==strcmp(flag, "+trace")) {
        Verilated::traceEverOn(true);  // Verilator must compute traced signals
        VL_PRINTF("Enabling waves into logs/vlt_dump.vcd...\n");
        tfp = new VerilatedVcdC;
        tb->trace(tfp, 99);  // Trace 99 levels of hierarchy
        Verilated::mkdir("logs");
        tfp->open("logs/vlt_dump.vcd");  // Open the dump file
    }
#endif

    // Set some inputs
    tb->but = 0;
    tb->uart_rx = 0;

    for (; main_time < 20; main_time++) {
	tb->but = main_time & 3;
	tb->uart_rx = !!(main_time & 4);

        // Evaluate model
        tb->eval();

#if VM_TRACE
        // Dump trace data for this cycle
        if (tfp)
		tfp->dump(main_time);
#endif

        // Read outputs
        VL_PRINTF("[%" VL_PRI64 "d] but=%x led=%x uart_rx=%x uart_tx=%x\n",
		  main_clock, tb->but, tb->led, tb->uart_rx, tb->uart_tx);
    }

    // Final model cleanup
    tb->final();

    // Close trace if opened
#if VM_TRACE
    if (tfp)
	    tfp->close();
#endif

    //  Coverage analysis (since test passed)
#if VM_COVERAGE
    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage.dat");
#endif

    // Destroy model
    delete tb;

    // Fin
    exit(0);
}

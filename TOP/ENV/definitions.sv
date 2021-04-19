`default_nettype none

parameter CMD_WIDTH = 4;
parameter DATA_WIDTH = 32;
parameter TAG_WIDTH = 2;
typedef enum bit[CMD_WIDTH-1:0] {   NOOP,       // 0
                                    ADD,        // 1
                                    SUB,        // 2
                                    LSL = 5,    // 5
                                    LSR         // 6
                                } operation;

parameter RESP_WIDTH = 2;

parameter NUM_PORTS = 4;



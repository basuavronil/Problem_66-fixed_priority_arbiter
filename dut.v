module fixed_priority_arbiter (
    input  wire [3:0] req,   // Request lines from 4 Masters
    output wire [3:0] grant  // Grant lines to 4 Masters (One-hot)
);

    // Highest priority to req[0], lowest to req[3]
    assign grant[0] =  req[0];
    assign grant[1] =  req[1] && !req[0];
    assign grant[2] =  req[2] && !req[0] && !req[1];
    assign grant[3] =  req[3] && !req[0] && !req[1] && !req[2];

endmodule

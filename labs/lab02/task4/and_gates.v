// Dataflow: inertial delay, swallows pulses shorter than 5
module and_df (input a, input b, output y);
  assign #5 y = a & b;
endmodule

// Delay before the assignment: inputs are read AFTER 5 units
module and_beh_before (input a, input b, output reg y);
  always @(a or b) begin
    #5 y = a & b;
  end
endmodule

// Intra-assignment delay: inputs are read NOW, applied after 5 units
module and_beh_intra (input a, input b, output reg y);
  always @(a or b) begin
    y = #5 a & b;
  end
endmodule

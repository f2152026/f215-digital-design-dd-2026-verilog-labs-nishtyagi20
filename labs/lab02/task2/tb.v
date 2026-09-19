// tb.v

// tb.v  (task2: lut)

module tb;

  reg  [1:0] t_sel;
  wire [7:0] t_dout;

  integer i;

  // Instance name must stay DUT for the $dumpvars line
  lut #(.WIDTH(8), .DEPTH(4)) DUT (
    .sel (t_sel),
    .dout(t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    #1; // let the ROM's initial block finish first
    for (i = 0; i < 4; i = i + 1) begin
      t_sel = i[1:0];
      #10;
    end
    $finish;
  end

  initial
    $monitor($time, " sel=%d | dout=%d", t_sel, t_dout);

endmodule
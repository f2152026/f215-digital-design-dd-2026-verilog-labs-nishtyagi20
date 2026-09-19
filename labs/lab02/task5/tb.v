module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] expected;
  integer    a, b, o, errors;

  // Instance name must stay DUT for the $dumpvars line
  alu DUT (.a(t_a), .b(t_b), .op(t_op), .result(t_result));

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    // op is the innermost loop, so op changes while a and b stay the same.
    // That exposes the sensitivity-list bug.
    for (a = 0; a < 16; a = a + 1) begin
      for (b = 0; b < 16; b = b + 1) begin
        for (o = 0; o < 2; o = o + 1) begin
          t_a  = a[3:0];
          t_b  = b[3:0];
          t_op = o[0];
          #1;
          expected = (o == 0) ? (a[3:0] + b[3:0]) : (a[3:0] - b[3:0]);
          if (t_result !== expected) begin
            errors = errors + 1;
            $display("FAIL: a=%0d b=%0d op=%0d | got %0d, expected %0d",
                     t_a, t_b, t_op, t_result, expected);
          end
        end
      end
    end

    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TEST(S) FAILED", errors);
    $finish;
  end

endmodule

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  reg        exp_gt, exp_lt, exp_eq;
  integer    i, j, errors;

  // Instance name must stay DUT for the $dumpvars line
  comp2 DUT (
    .A (t_a),
    .B (t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
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
    errors = 0;
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #1;

        // Expected values computed independently of the DUT
        exp_gt = (i > j);
        exp_lt = (i < j);
        exp_eq = (i == j);

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          errors = errors + 1;
          $display("FAIL: A=%0d B=%0d | got GT=%b LT=%b EQ=%b, expected GT=%b LT=%b EQ=%b",
                   t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        end
      end
    end

    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TEST(S) FAILED", errors);
    $finish;
  end

endmodule

`timescale 1ns/1ps
module tb_fair_validation_gate;
    reg clk=0, rst_n=0, start=0;
    reg cert_ok=0, sig_ok=0, nonce_ok=0, fmt_ok=0, ep_ok=0;
    reg [31:0] ts_msg=0, ts_ref=0;
    wire done, accept;
    wire [3:0] reason_code;

    fair_validation_gate #(.DELTA_T(32'd300)) dut(
        .clk(clk), .rst_n(rst_n), .start(start), .cert_ok(cert_ok), .sig_ok(sig_ok),
        .nonce_ok(nonce_ok), .fmt_ok(fmt_ok), .ep_ok(ep_ok), .ts_msg(ts_msg), .ts_ref(ts_ref),
        .done(done), .accept(accept), .reason_code(reason_code)
    );

    always #5 clk = ~clk;

    task run_case;
        input c; input s; input n; input f; input e; input [31:0] tm; input [31:0] tr;
        begin
            @(negedge clk);
            cert_ok=c; sig_ok=s; nonce_ok=n; fmt_ok=f; ep_ok=e; ts_msg=tm; ts_ref=tr; start=1;
            @(negedge clk); start=0;
            @(posedge clk);
            $display("accept=%0d reason_code=%0d", accept, reason_code);
        end
    endtask

    initial begin
        $dumpfile("fair_validation_gate.vcd");
        $dumpvars(0, tb_fair_validation_gate);
        repeat(2) @(negedge clk); rst_n=1;
        run_case(1,1,1,1,1,1000,1100); // ACCEPT
        run_case(0,1,1,1,1,1000,1100); // CERT_FAIL
        run_case(1,0,1,1,1,1000,1100); // SIG_FAIL
        run_case(1,1,1,1,1,1000,1500); // TIME_FAIL
        run_case(1,1,0,1,1,1000,1100); // REPLAY_FAIL
        run_case(1,1,1,0,1,1000,1100); // FMT_FAIL
        run_case(1,1,1,1,0,1000,1100); // EP_FAIL
        #20 $finish;
    end
endmodule

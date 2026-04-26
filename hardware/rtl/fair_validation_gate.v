// FAIR Hardware Validation Gate for ECC-HLFB-eVOTING
// Emits ACCEPT only when CERT, SIG, TIME, NONCE, FORMAT and EP checks are valid.
`timescale 1ns/1ps

module fair_validation_gate #(
    parameter TS_WIDTH = 32,
    parameter DELTA_T  = 32'd300
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  start,
    input  wire                  cert_ok,
    input  wire                  sig_ok,
    input  wire                  nonce_ok,
    input  wire                  fmt_ok,
    input  wire                  ep_ok,
    input  wire [TS_WIDTH-1:0]    ts_msg,
    input  wire [TS_WIDTH-1:0]    ts_ref,
    output reg                   done,
    output reg                   accept,
    output reg  [3:0]             reason_code
);
    localparam RC_ACCEPT     = 4'd0;
    localparam RC_CERT_FAIL  = 4'd1;
    localparam RC_SIG_FAIL   = 4'd2;
    localparam RC_TIME_FAIL  = 4'd3;
    localparam RC_REPLAY_FAIL= 4'd4;
    localparam RC_FMT_FAIL   = 4'd5;
    localparam RC_EP_FAIL    = 4'd6;

    wire [TS_WIDTH-1:0] abs_diff = (ts_ref >= ts_msg) ? (ts_ref - ts_msg) : (ts_msg - ts_ref);
    wire time_ok = (abs_diff <= DELTA_T);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
            accept <= 1'b0;
            reason_code <= RC_ACCEPT;
        end else begin
            done <= 1'b0;
            if (start) begin
                done <= 1'b1;
                accept <= 1'b0;
                if (!cert_ok)       reason_code <= RC_CERT_FAIL;
                else if (!sig_ok)   reason_code <= RC_SIG_FAIL;
                else if (!time_ok)  reason_code <= RC_TIME_FAIL;
                else if (!nonce_ok) reason_code <= RC_REPLAY_FAIL;
                else if (!fmt_ok)   reason_code <= RC_FMT_FAIL;
                else if (!ep_ok)    reason_code <= RC_EP_FAIL;
                else begin
                    accept <= 1'b1;
                    reason_code <= RC_ACCEPT;
                end
            end
        end
    end
endmodule

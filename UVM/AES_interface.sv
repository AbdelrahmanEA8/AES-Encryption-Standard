interface AES_Interface #(
    parameter DATA_W = 128, KEY_L = 128
)(
    input logic clk     //system clock
);

    
    logic   reset_n;                     //asynch reset
    logic   valid_in;                   //cipherkey valid signal
    logic   [KEY_L-1:0]  cipher_key;     //cipher key
    logic   [DATA_W-1:0] plain_text;     //plain text
    logic   [DATA_W-1:0] cipher_text;    //cipher text
    logic   valid_out;                   //output valid signal


    clocking dvr2dut_cb @(posedge clk);
        default output #0; // go to Re-NBA region and wait for the clock to be stable then drive in
    
        output reset_n, valid_in, cipher_key, plain_text;
    endclocking

    clocking dut2mon_cb @(posedge clk);
        default input #1step; // Sample at postponed of the prev. clk cycle
    
        input cipher_text, valid_out;
    endclocking
        
endinterface
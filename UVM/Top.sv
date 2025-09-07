module Top();
import uvm_pkg::*;
import AES_pack::*;

    // Clk generation
    bit clk;
    always #10 clk = ~clk;

    // instances
    AES_Interface AES_if(clk);

    AES_128 dut(
        .clk(clk), 
        .reset_n(AES_if.reset_n), 
        .valid_in(AES_if.valid_in), 
        .cipher_key(AES_if.cipher_key), 
        .plain_text(AES_if.plain_text), 
        .cipher_text(AES_if.cipher_text), 
        .valid_out(AES_if.valid_out)
        );
    
    initial begin
        // set the virtual interface for the environment
        uvm_config_db#(virtual AES_Interface)::set(null, "uvm_test_top","top2test", AES_if);
        run_test("MyTest");
    end
endmodule
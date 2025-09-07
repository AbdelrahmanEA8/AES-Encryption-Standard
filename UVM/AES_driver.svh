class MyDriver extends uvm_driver #(my_seq_item);
    // Component Registeration
    `uvm_component_utils(MyDriver)

    my_seq_item MySeqItem;
    virtual AES_Interface AES_if;

    // Component Construction
    function new (string name = "MyDriver", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Driver");
        if(!uvm_config_db#(virtual AES_Interface)::get(this, "", "agent2driver", AES_if)) begin
            `uvm_fatal("NOVIF", "Virtual interface not found")
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("Connecting Driver");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item_port.get_next_item(MySeqItem);
            `uvm_info("DRIVER", $sformatf("Driving transaction: reset_n=%0b valid_in=%0b cipher_key=0x%0h plain_text=0x%0h valid_in=%0b",
                                           MySeqItem.reset_n, MySeqItem.valid_in, MySeqItem.cipher_key, MySeqItem.plain_text, MySeqItem.valid_in), UVM_LOW)
            // Drive the signals to DUT
            @(AES_if.dvr2dut_cb);
            AES_if.reset_n <= MySeqItem.reset_n;
            AES_if.valid_in <= MySeqItem.valid_in;
            AES_if.cipher_key <= MySeqItem.cipher_key;
            AES_if.plain_text <= MySeqItem.plain_text;
            // Indicate item is done
            seq_item_port.item_done();
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Driver Report");
    endfunction

endclass
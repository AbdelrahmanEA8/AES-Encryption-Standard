class MyMonitor extends uvm_monitor;
    // Component Registeration
    `uvm_component_utils(MyMonitor)

    my_seq_item MySeqItem;
    virtual AES_Interface AES_if;
    uvm_analysis_port#(my_seq_item) mon_port;

    // Component Construction
    function new (string name = "MyMonitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Monitor");
        // Object Creation
        MySeqItem = my_seq_item::type_id::create("MySeqItem");
        mon_port = new("mon_port", this);
        if(!uvm_config_db#(virtual AES_Interface)::get(this, "", "agent2monitor", AES_if)) begin
            `uvm_fatal("NOVIF", "Virtual interface not found")
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("Connecting Monitor");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            @(AES_if.dut2mon_cb);
            MySeqItem = my_seq_item::type_id::create("MySeqItem");
            MySeqItem.reset_n = AES_if.reset_n;
            MySeqItem.valid_in = AES_if.valid_in;
            MySeqItem.cipher_key = AES_if.cipher_key;
            MySeqItem.plain_text = AES_if.plain_text;
            MySeqItem.cipher_text = AES_if.cipher_text;
            MySeqItem.valid_out = AES_if.valid_out;
            `uvm_info("MONITOR", $sformatf("Monitor observed transaction: reset_n=%0b valid_in=%0b cipher_key=0x%0h plain_text=0x%0h 
                                            cipher_text=%0h valid_out=%0b", MySeqItem.reset_n, MySeqItem.valid_in, MySeqItem.cipher_key, MySeqItem.plain_text, 
                                            MySeqItem.cipher_text, MySeqItem.valid_out), UVM_LOW)
            mon_port.write(MySeqItem);
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Monitor Report");
    endfunction

endclass
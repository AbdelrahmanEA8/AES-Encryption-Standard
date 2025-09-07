class MyAgent extends uvm_agent;
    // Component Registeration
    `uvm_component_utils(MyAgent)

    // Component instances
    MySequencer MySequencer_inst;
    MyDriver MyDriver_inst;
    MyMonitor MyMonitor_inst;
    my_seq_item MySeqItem;
    virtual AES_Interface AES_if;
    uvm_analysis_port#(my_seq_item) agent_port;

    // Components Construction
    function new(string name = "MyAgent", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Agent");
        // Components Creation
        MySequencer_inst = MySequencer::type_id::create("MySequencer_inst", this);
        MyDriver_inst = MyDriver::type_id::create("MyDriver_inst", this);
        MyMonitor_inst = MyMonitor::type_id::create("MyMonitor_inst", this);
        agent_port = new("agent_port", this);
        if(!uvm_config_db#(virtual AES_Interface)::get(this, "", "env2agent", AES_if)) begin
            `uvm_fatal("NOVIF", "Virtual interface not found")
        end
        uvm_config_db#(virtual AES_Interface)::set(this, "MyDriver_inst", "agent2driver", AES_if);
        uvm_config_db#(virtual AES_Interface)::set(this, "MyMonitor_inst", "agent2monitor", AES_if);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("Connecting Agent");
        MyMonitor_inst.mon_port.connect(this.agent_port);
        MyDriver_inst.seq_item_port.connect(MySequencer_inst.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Agent Report");
    endfunction

endclass
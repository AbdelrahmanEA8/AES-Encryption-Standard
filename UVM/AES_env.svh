class MyEnv extends uvm_env;
    // Component Registeration
    `uvm_component_utils(MyEnv) 

    // Component instances
    MyAgent MyAgent_inst;
    MyScoreboard MyScoreboard_inst;
    MySubscriber MySubscriber_inst;
    virtual AES_Interface AES_if;

    // Component Construction
    function new (string name = "MyEnv" , uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Environment");
        // Components creation
        MyAgent_inst = MyAgent::type_id::create("MyAgent_inst", this);
        MyScoreboard_inst = MyScoreboard::type_id::create("MyScoreboard_inst", this);
        MySubscriber_inst = MySubscriber::type_id::create("MySubscriber_inst", this);
        if(!uvm_config_db#(virtual AES_Interface)::get(this, "", "test2env", AES_if)) begin
            `uvm_fatal("NOVIF", "Virtual interface not found")
        end
        uvm_config_db#(virtual AES_Interface)::set(this, "MyAgent_inst", "env2agent", AES_if);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("Connecting Environment");
        MyAgent_inst.agent_port.connect(MySubscriber_inst.analysis_export);
        MyAgent_inst.agent_port.connect(MyScoreboard_inst.scb_imp);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Environment Report");
    endfunction

endclass
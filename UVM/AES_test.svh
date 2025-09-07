class MyTest extends uvm_test;
    // Component Registeration
    `uvm_component_utils(MyTest)

    // Component instances
    MyEnv MyEnv_inst;
    virtual AES_Interface AES_if;
    aes_reset_seq reset_seq;
    aes_rand_seq rand_seq;
    
    // Component Construction
    function new (string name = "MyTest", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Test");
        // Component creation
        MyEnv_inst = MyEnv::type_id::create("MyEnv_inst", this);
        reset_seq = aes_reset_seq::type_id::create("reset_seq");
        rand_seq = aes_rand_seq::type_id::create("rand_seq");
        if (!uvm_config_db#(virtual AES_Interface)::get(this, "", "top2test", AES_if)) begin
            `uvm_fatal("NOVIF", "Virtual interface not found")
        end
        uvm_config_db#(virtual AES_Interface)::set(this, "MyEnv_inst", "test2env", AES_if);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("Connecting Test");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        phase.raise_objection(this);
        reset_seq.start(MyEnv_inst.MyAgent_inst.MySequencer_inst);
        rand_seq.start(MyEnv_inst.MyAgent_inst.MySequencer_inst);
        phase.drop_objection(this);
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Test Report");
    endfunction

endclass
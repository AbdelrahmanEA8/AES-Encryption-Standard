class MySequencer extends uvm_sequencer #(my_seq_item);
    // Component Registeration
    `uvm_component_utils(MySequencer)

    my_seq_item MySeqItem;

    // Component Construction
    function new (string name = "MySequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Sequencer");
        // Object Creation
        MySeqItem = my_seq_item::type_id::create("MySeqItem");
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("Connecting Subscriber");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Sequencer Report");
    endfunction

endclass
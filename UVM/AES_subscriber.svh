class MySubscriber extends uvm_subscriber #(my_seq_item);
    // Component Registeration
    `uvm_component_utils(MySubscriber)

    my_seq_item MySeqItem;

    // Covergroups
    covergroup mem_cg1;
        coverpoint MySeqItem.cipher_text {
            option.auto_bin_max = 100;
        }
        coverpoint MySeqItem.valid_out {
            bins valid_out_0_bin = {0};
            bins valid_out_1_bin = {1};
        }
        cross MySeqItem.cipher_text, MySeqItem.valid_out;
    endgroup

    covergroup mem_cg2;
        coverpoint MySeqItem.cipher_key {
            option.auto_bin_max = 100;
        }
        coverpoint MySeqItem.valid_in {
            bins valid_in_0_bin = {0};
            bins valid_in_1_bin = {1};
        }
        cross MySeqItem.cipher_key, MySeqItem.valid_in;
    endgroup

    // Component Construction
    function new (string name = "MySubscriber", uvm_component parent = null);
        super.new(name, parent);
        mem_cg1 = new;
        mem_cg2 = new;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Subscriber");
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
        $display("Subscriber Report");
    endfunction

    function void write(my_seq_item t);
        $display("Received item with data");
        MySeqItem = t;
        mem_cg1.sample();
        mem_cg2.sample();
    endfunction
endclass
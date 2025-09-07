class MyScoreboard extends uvm_scoreboard;
    // Component Registeration
    `uvm_component_utils(MyScoreboard)

    my_seq_item MySeqItem;
    uvm_analysis_imp#(my_seq_item, MyScoreboard) scb_imp;

    // Memory variables
    int passed_count = 0;
    int failed_count = 0;
    int TC_count = 0;
    integer fd; // Variable to hold file descriptor
    string line;
    logic [DATA_W-1:0] exp_out;

    // Component Construction
    function new (string name = "MyScoreboard", uvm_component parent = null);
        super.new( name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        $display("Building Scoreboard");
        scb_imp = new("scb_imp", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        $display("Connecting Scoreboard");
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        $display("Scoreboard Report");
        $display("----------------------------------------");
        $display("Final Report");
        $display("  Passed: %0d", passed_count);
        $display("  Failed: %0d", failed_count);
        $display("  Total: %0d", TC_count);
        $display("----------------------------------------");
    endfunction

    task write (my_seq_item t);

    if (t.reset_n == 0) begin
        $display("RESET Sequence");
    end 
    else begin
        if (t.valid_in == 1) begin
            fd = $fopen("./data_key.txt","w");
            if (!fd) begin
                $display("File was NOT opened successfully : %0d", fd);
                $finish;
            end

            // $fdisplay(fd,"%h \n%h",t.plain_text , t.cipher_key);
            $fwrite(fd,"%h\n",t.plain_text);
            $fwrite(fd,"%h\n",t.cipher_key);

            $fclose(fd);

            // System call to run the reference model
            $system($sformatf("python reference_model.py"));
            // $system("python ./reference_model.py");

            fd = $fopen("./output.txt","r");
            if (!fd) begin
                $display("File was NOT opened successfully : %0d", fd);
                $finish;
            end

            // if(!$fgets(line, fd)) begin
            //     $display("File was NOT opened successfully : %0d", fd);
            //     $fclose(fd);
            //     $finish;
            // end
            // $fscanf(line, "%h",exp_out);
            void'($fscanf(fd, "%h", exp_out));
            $fclose(fd);

            if((exp_out == t.cipher_text) && (t.valid_out == 1)) begin
                $display("[Scoreboard] SUCCESS , cipher_text=%h , exp_plain_text=%h , valid_out=%d, plain_text=%h, cipher_key=%h , valid_in=%d", 
                            t.cipher_text , exp_out, t.valid_out, t.plain_text, t.cipher_key, t.valid_in);
                passed_count++;
            end
            else begin
                $display("[Scoreboard] FAILURE , cipher_text=%h , exp_plain_text=%h , valid_out=%d, plain_text=%h, cipher_key=%h , valid_in=%d", 
                            t.cipher_text , exp_out, t.valid_out, t.plain_text, t.cipher_key, t.valid_in);
                failed_count++;
            end
        end
        TC_count++;
    end
endtask

endclass
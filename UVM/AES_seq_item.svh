parameter integer DATA_W = 128;
parameter integer KEY_L = 128;

class my_seq_item extends uvm_sequence_item;
    // Object Registeration
    `uvm_object_utils(my_seq_item)

    // In-Out ports
    rand logic                       reset_n;  
    rand logic                       valid_in;   
    rand logic   [KEY_L-1:0]    cipher_key;  
    rand logic   [DATA_W-1:0]    plain_text;   

    logic   [DATA_W-1:0]    cipher_text; 
    logic                       valid_out;

    // Component Construction
    function new (string name = "my_seq_item");
        super.new(name);
    endfunction

    // Constraints
    constraint c_op_ratio {
        if(reset_n == 0)
        {
            valid_in ==0;
        }
    }  

    constraint c_valid_in_dist {
        valid_in dist {0 := 5, 1 := 95};
    }

endclass
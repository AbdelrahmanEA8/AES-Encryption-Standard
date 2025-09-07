class aes_base_seq extends uvm_sequence;
  `uvm_object_utils(aes_base_seq)

  my_seq_item Item;


  function new(string name="aes_base_seq"); 
    super.new(name); 
  endfunction

  virtual task pre_body();
      Item = my_seq_item::type_id::create("Item");
  endtask
endclass

class aes_reset_seq extends aes_base_seq;
  `uvm_object_utils(aes_reset_seq)

  function new(string name="aes_reset_seq"); 
    super.new(name); 
  endfunction

  virtual task body();
    repeat (16) begin
      start_item(Item);
      assert(Item.randomize() with { reset_n == 0; valid_in == 0; });
      finish_item(Item);
    end
  endtask
endclass

class aes_rand_seq extends aes_base_seq;
  `uvm_object_utils(aes_rand_seq)
  int txn_counts = 100;

  function new(string name="aes_rand_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat (txn_counts) begin
      start_item(Item);
      assert(Item.randomize() with { reset_n == 1; });
      finish_item(Item);
    end
  endtask
endclass
class axi4_lite_sequence extends uvm_sequence #(axi4_lite_transaction);

    `uvm_object_utils(axi4_lite_sequence)

    int num_transactions = 20;

    function new(string name = "axi4_lite_sequence");
        super.new(name);
    endfunction

    task body();
        axi4_lite_transaction txn;

        repeat(num_transactions) begin
            txn = axi4_lite_transaction::type_id::create("txn");
            start_item(txn);
            if (!txn.randomize())
                `uvm_fatal("SEQ", "Randomization failed")
            finish_item(txn);
        end 
    endtask 

endclass
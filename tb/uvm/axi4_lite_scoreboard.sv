class axi4_lite_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(axi4_lite_scoreboard)

    uvm_analysis_imp #(axi4_lite_transaction, axi4_lite_scoreboard) analysis_export;

    // reference model - mirrors what the DUT should store
    logic [31:0] ref_model [2][4];

    int pass_count;
    int fail_count;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        pass_count = 0;
        fail_count = 0;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        analysis_export = new("analysis_export", this);
        // initialize reference model to 0
        foreach (ref_model[i,j])
            ref_model[i][j] = 0;
    endfunction

    function void write(axi4_lite_transaction txn);
        int target_idx;
        int reg_idx;

        // determine which target based on address
        target_idx = txn.addr[31];
        reg_idx    = txn.addr[3:2];

        if (txn.op == axi4_lite_transaction::WRITE) begin
            // update reference model
            ref_model[target_idx][reg_idx] = txn.data;
            `uvm_info("SB", $sformatf("WRITE: %s", txn.convert2string()), UVM_MEDIUM)

        end else begin
            // check read data against reference model
            if (txn.rdata == ref_model[target_idx][reg_idx]) begin
                pass_count++;
                `uvm_info("SB", $sformatf("PASS: READ %s got %h", 
                    txn.convert2string(), txn.rdata), UVM_MEDIUM)
            end else begin
                fail_count++;
                `uvm_error("SB", $sformatf("FAIL: READ %s expected %h got %h",
                    txn.convert2string(), ref_model[target_idx][reg_idx], txn.rdata))
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SB", $sformatf("RESULTS: %0d passed, %0d failed", 
            pass_count, fail_count), UVM_NONE)
    endfunction

endclass
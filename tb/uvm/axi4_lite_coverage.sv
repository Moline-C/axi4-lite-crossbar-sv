class axi4_lite_coverage extends uvm_subscriber #(axi4_lite_transaction);

    `uvm_component_utils(axi4_lite_coverage)

    axi4_lite_transaction txn;

    covergroup axi4_lite_cg;

        // was it a read or write?
        cp_op: coverpoint txn.op {
            bins write_op = {axi4_lite_transaction::WRITE};
            bins read_op  = {axi4_lite_transaction::READ};
        }

        // which initiator sent the transaction?
        cp_initiator: coverpoint txn.initiator {
            bins initiator0 = {0};
            bins initiator1 = {1};
        }

        // which target was accessed?
        cp_target: coverpoint txn.addr[31] {
            bins target0 = {0};
            bins target1 = {1};
        }

        // which register was accessed?
        cp_register: coverpoint txn.addr[3:2] {
            bins reg0 = {0};
            bins reg1 = {1};
            bins reg2 = {2};
            bins reg3 = {3};
        }

        // cross coverage - every initiator should access every target
        cx_initiator_target: cross cp_initiator, cp_target;

        // cross coverage - every operation on every target
        cx_op_target: cross cp_op, cp_target;

        // cross coverage - every operation by every initiator
        cx_op_initiator: cross cp_op, cp_initiator;

    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        axi4_lite_cg = new();
    endfunction

    function void write(axi4_lite_transaction t);
        txn = t;
        axi4_lite_cg.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("COV", $sformatf("Functional coverage: %.1f%%",
            axi4_lite_cg.get_coverage()), UVM_NONE)
    endfunction

endclass
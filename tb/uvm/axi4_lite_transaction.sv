class axi4_lite_transaction extends uvm_sequence_item;

    `uvm_object_utils(axi4_lite_transaction)

    // transaction type
    typedef enum {WRITE, READ} op_t;
    rand op_t op;

    // AXI signals
    rand logic [31:0] addr;
    rand logic [31:0] data;
    rand logic [3:0] strb;
    rand int initiator;

    // response
    logic [31:0] rdata;
    logic [1:0] resp;

    // constraints
    constraint c_addr {
        addr inside {32'h00000000, 32'h00000004,
                     32'h80000000, 32'h80000004};
    }

    constraint c_strb {
        strb == 4'hF;
    }

    constraint c_initiator {
        initiator inside {[0:1]};
    }

    function new(string name = "axi4_lite_transaction");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("op=%s addr=%h data=%h initiator=%0d",
            op.name(), addr, data, initiator);
    endfunction

endclass
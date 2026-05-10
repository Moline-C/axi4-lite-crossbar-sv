class axi4_lite_driver extends uvm_driver #(axi4_lite_transaction);

    `uvm_component_utils(axi4_lite_driver)

    virtual axi4_lite_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual axi4_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "No virtual interface found in config db")
    endfunction

    task run_phase(uvm_phase phase);
        axi4_lite_transaction txn;
        forever begin
            seq_item_port.get_next_item(txn);
            if (txn.op == axi4_lite_transaction::WRITE)
                do_write(txn);
            else
                do_read(txn);
            seq_item_port.item_done();
        end 
    endtask

    task do_write(axi4_lite_transaction txn);
        vif.awvalid[txn.initiator] = 1;
        vif.awaddr[txn.initiator] = txn.addr;
        vif.wvalid[txn.initiator] = 1;
        vif.wdata[txn.initiator] = txn.data;
        vif.wstrb[txn.initiator] = txn.strb;

        @(posedge vif.clk); #1;
        while (!vif.bvalid[txn.initiator]) begin 
            @(posedge vif.clk); #1;
        end 

        txn.resp = vif.bresp[txn.initiator];
        vif.awvalid[txn.initiator] = 0;
        vif.wvalid[txn.initiator] = 0;
        vif.bready[txn.initiator] = 1;
        @(posedge vif.clk); #1;
        vif.bready[txn.initiator] = 0;
    endtask 

    task do_read(axi4_lite_transaction txn);
        vif.arvalid[txn.initiator] = 1;
        vif.araddr[txn.initiator] = txn.addr;

        @(posedge vif.clk); #1;
        while (!vif.rvalid[txn.initiator]) begin
            @(posedge vif.clk); #1;
        end 

        txn.rdata = vif.rdata[txn.initiator];
        txn.resp = vif.rresp[txn.initiator];
        vif.arvalid[txn.initiator] = 0;
        vif.rready[txn.initiator] = 1;
        @(posedge vif.clk); #1;
        vif.rready[txn.initiator] = 0;
    endtask 

endclass 

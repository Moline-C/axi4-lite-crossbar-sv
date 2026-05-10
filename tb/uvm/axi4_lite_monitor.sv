class axi4_lite_monitor extends uvm_monitor;

    `uvm_component_utils(axi4_lite_monitor)

    virtual axi4_lite_if vif;

    uvm_analysis_port #(axi4_lite_transaction) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
        if (!uvm_config_db #(virtual axi4_lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "No virtual interface found in config db")
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            axi4_lite_transaction txn;
            txn = axi4_lite_transaction::type_id::create("txn");
            observe_transaction(txn);
            ap.write(txn);
        end
    endtask

    task observe_transaction(axi4_lite_transaction txn);
        // wait for any valid transaction to start
        @(posedge vif.clk);
        while (!(|(vif.awvalid) || |(vif.arvalid))) begin
            @(posedge vif.clk);
        end

        // determine initiator and operation type
        for (int i = 0; i < 2; i++) begin
            if (vif.awvalid[i]) begin
                txn.initiator = i;
                txn.op = axi4_lite_transaction::WRITE;
                txn.addr = vif.awaddr[i];
                break;
            end else if (vif.arvalid[i]) begin
                txn.initiator = i;
                txn.op = axi4_lite_transaction::READ;
                txn.addr = vif.araddr[i];
                break;
            end
        end

        // wait for transaction to complete
        if (txn.op == axi4_lite_transaction::WRITE) begin
            // wait for write data
            @(posedge vif.clk);
            while (!vif.bvalid[txn.initiator]) begin
                if (vif.wvalid[txn.initiator])
                    txn.data = vif.wdata[txn.initiator];
                @(posedge vif.clk);
            end
            txn.resp = vif.bresp[txn.initiator];
        end else begin
            // wait for read data
            while (!vif.rvalid[txn.initiator]) begin
                @(posedge vif.clk);
            end
            txn.rdata = vif.rdata[txn.initiator];
            txn.resp  = vif.rresp[txn.initiator];
        end
    endtask

endclass
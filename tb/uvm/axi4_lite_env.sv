class axi4_lite_env extends uvm_env;

    `uvm_component_utils(axi4_lite_env)

    axi4_lite_driver    driver;
    axi4_lite_monitor   monitor;
    axi4_lite_scoreboard scoreboard;
    axi4_lite_coverage  coverage;

    uvm_sequencer #(axi4_lite_transaction) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver     = axi4_lite_driver::type_id::create("driver", this);
        monitor    = axi4_lite_monitor::type_id::create("monitor", this);
        scoreboard = axi4_lite_scoreboard::type_id::create("scoreboard", this);
        coverage   = axi4_lite_coverage::type_id::create("coverage", this);
        sequencer  = uvm_sequencer #(axi4_lite_transaction)::type_id::create("sequencer", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
        monitor.ap.connect(scoreboard.analysis_export);
        monitor.ap.connect(coverage.analysis_export);
    endfunction

endclass
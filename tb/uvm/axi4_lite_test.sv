class axi4_lite_test extends uvm_test;
    `uvm_component_utils(axi4_lite_test)

    axi4_lite_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi4_lite_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        axi4_lite_sequence seq;
        phase.raise_objection(this);
        seq = axi4_lite_sequence::type_id::create("seq");
        seq.start(env.sequencer);
        phase.drop_objection(this);
    endtask

endclass
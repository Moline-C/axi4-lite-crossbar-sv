module traffic_light (
    input logic clk,
    input logic rst,
    input logic timer_done,
    output logic red,
    output logic green,
    output logic yellow
);

    typedef enum logic [1:0] {
        RED_S = 2'b00,
        GREEN_S = 2'b01,
        YELLOW_S = 2'b10
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (rst) 
            current_state <= RED_S;
         else 
            current_state  <= next_state;
    end

    always_comb begin
        case (current_state)
            RED_S: next_state = timer_done ? GREEN_S : RED_S;
            GREEN_S: next_state = timer_done ? YELLOW_S : GREEN_S;
            YELLOW_S: next_state = timer_done ? RED_S : YELLOW_S;
            default: next_state = RED_S;
        endcase
    end

    always_comb begin
        red = (current_state == RED_S);
        green = (current_state == GREEN_S);
        yellow = (current_state == YELLOW_S);
    end
endmodule
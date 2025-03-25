###################################################################

# Created by write_sdc on Tue Mar 25 15:54:17 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_wire_load_mode top
set_wire_load_model -name enG5K -library fsa0m_a_generic_core_ss1p62v125c
set_load -pin_load 0.05 [get_ports {o_encoded[2]}]
set_load -pin_load 0.05 [get_ports {o_encoded[1]}]
set_load -pin_load 0.05 [get_ports {o_encoded[0]}]
set_load -pin_load 0.05 [get_ports o_valid]
set_max_capacitance 0.15 [get_ports {i_data[7]}]
set_max_capacitance 0.15 [get_ports {i_data[6]}]
set_max_capacitance 0.15 [get_ports {i_data[5]}]
set_max_capacitance 0.15 [get_ports {i_data[4]}]
set_max_capacitance 0.15 [get_ports {i_data[3]}]
set_max_capacitance 0.15 [get_ports {i_data[2]}]
set_max_capacitance 0.15 [get_ports {i_data[1]}]
set_max_capacitance 0.15 [get_ports {i_data[0]}]
set_max_fanout 10 [get_ports {i_data[7]}]
set_max_fanout 10 [get_ports {i_data[6]}]
set_max_fanout 10 [get_ports {i_data[5]}]
set_max_fanout 10 [get_ports {i_data[4]}]
set_max_fanout 10 [get_ports {i_data[3]}]
set_max_fanout 10 [get_ports {i_data[2]}]
set_max_fanout 10 [get_ports {i_data[1]}]
set_max_fanout 10 [get_ports {i_data[0]}]
set_max_transition 3 [get_ports {i_data[7]}]
set_max_transition 3 [get_ports {i_data[6]}]
set_max_transition 3 [get_ports {i_data[5]}]
set_max_transition 3 [get_ports {i_data[4]}]
set_max_transition 3 [get_ports {i_data[3]}]
set_max_transition 3 [get_ports {i_data[2]}]
set_max_transition 3 [get_ports {i_data[1]}]
set_max_transition 3 [get_ports {i_data[0]}]
set_input_transition -max 0.5  [get_ports {i_data[7]}]
set_input_transition -min 0.5  [get_ports {i_data[7]}]
set_input_transition -max 0.5  [get_ports {i_data[6]}]
set_input_transition -min 0.5  [get_ports {i_data[6]}]
set_input_transition -max 0.5  [get_ports {i_data[5]}]
set_input_transition -min 0.5  [get_ports {i_data[5]}]
set_input_transition -max 0.5  [get_ports {i_data[4]}]
set_input_transition -min 0.5  [get_ports {i_data[4]}]
set_input_transition -max 0.5  [get_ports {i_data[3]}]
set_input_transition -min 0.5  [get_ports {i_data[3]}]
set_input_transition -max 0.5  [get_ports {i_data[2]}]
set_input_transition -min 0.5  [get_ports {i_data[2]}]
set_input_transition -max 0.5  [get_ports {i_data[1]}]
set_input_transition -min 0.5  [get_ports {i_data[1]}]
set_input_transition -max 0.5  [get_ports {i_data[0]}]
set_input_transition -min 0.5  [get_ports {i_data[0]}]

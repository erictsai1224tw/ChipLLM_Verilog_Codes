###################################################################

# Created by write_sdc on Tue Mar 25 16:49:30 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_wire_load_mode top
set_wire_load_model -name enG5K -library fsa0m_a_generic_core_ss1p62v125c
set_load -pin_load 0.05 [get_ports {o_encoded[3]}]
set_load -pin_load 0.05 [get_ports {o_encoded[2]}]
set_load -pin_load 0.05 [get_ports {o_encoded[1]}]
set_load -pin_load 0.05 [get_ports {o_encoded[0]}]
set_load -pin_load 0.05 [get_ports o_valid]
set_max_delay 10  -from [list [get_ports {i_data[7]}] [get_ports {i_data[6]}] [get_ports        \
{i_data[5]}] [get_ports {i_data[4]}] [get_ports {i_data[3]}] [get_ports        \
{i_data[2]}] [get_ports {i_data[1]}] [get_ports {i_data[0]}]]  -to [list [get_ports {o_encoded[3]}] [get_ports {o_encoded[2]}] [get_ports    \
{o_encoded[1]}] [get_ports {o_encoded[0]}] [get_ports o_valid]]

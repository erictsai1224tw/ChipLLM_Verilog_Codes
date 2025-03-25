###################################################################

# Created by write_sdc on Tue Mar 25 17:03:35 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_wire_load_mode top
set_wire_load_model -name enG5K -library fsa0m_a_generic_core_ss1p62v125c
set_load -pin_load 0.05 [get_ports {out[2]}]
set_load -pin_load 0.05 [get_ports {out[1]}]
set_load -pin_load 0.05 [get_ports {out[0]}]
set_load -pin_load 0.05 [get_ports valid]
set_max_delay 10  -from [list [get_ports {in[7]}] [get_ports {in[6]}] [get_ports {in[5]}]       \
[get_ports {in[4]}] [get_ports {in[3]}] [get_ports {in[2]}] [get_ports         \
{in[1]}] [get_ports {in[0]}]]  -to [list [get_ports {out[2]}] [get_ports {out[1]}] [get_ports {out[0]}]      \
[get_ports valid]]

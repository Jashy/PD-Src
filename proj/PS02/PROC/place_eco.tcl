derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS
derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin GND
derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS -tie
legalize_placement -eco

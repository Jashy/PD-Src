create_pg_composite_pattern PATTERN_M11_PWR_MESH -nets {VDD_CORE } -add_patterns {{{pattern: pattern_stripe_offtrack} {nets: {VDD_CORE }} {parameters: {M11 vertical 0.36 1.008 2.736 }}{offset: {1.14 0} }}} 
create_pg_composite_pattern PATTERN_M11_GND_MESH -nets {VSS } -add_patterns {{{pattern: pattern_stripe_offtrack} {nets: {VSS }} {parameters: {M11 vertical 0.36 0 2.736 }}{offset: {2.508 0} }}} 
create_pg_composite_pattern PATTERN_M2_PWR_BRIDGE -nets {VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE }} {parameters: {M2 horizontal 0.02 0 {2.736 0.96} track 0.6 }}{offset: {0.754 0.7} }}} 
create_pg_composite_pattern PATTERN_M2_GND_BRIDGE -nets {VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS }} {parameters: {M2 horizontal 0.02 0 {2.736 0.96} track 0.6 }}{offset: {2.123 0.7} }}} 
create_pg_composite_pattern PATTERN_M1_PWR_MESH -nets {VDD_CORE VDD_CORE } -add_patterns {{{pattern: pattern_stripe} {nets: {VDD_CORE VDD_CORE }} {parameters: {M1 vertical 0.037 0.02 2.736 track }}{offset: {1.065 0} }}} 
create_pg_composite_pattern PATTERN_M1_GND_MESH -nets {VSS VSS } -add_patterns {{{pattern: pattern_stripe} {nets: {VSS VSS }} {parameters: {M1 vertical 0.037 0.02 2.736 track }}{offset: {2.432 0} }}} 
create_pg_composite_pattern PATTERN_M4_PWR_BRIDGE -nets {VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE }} {parameters: {M4 horizontal 0.04 0 {2.736 0.96} track 0.6 }}{offset: {0.754 0.7} }}} 
create_pg_composite_pattern PATTERN_M4_GND_BRIDGE -nets {VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS }} {parameters: {M4 horizontal 0.04 0 {2.736 0.96} track 0.6 }}{offset: {2.123 0.7} }}} 
create_pg_composite_pattern PATTERN_M6_PWR_BRIDGE -nets {VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE }} {parameters: {M6 horizontal 0.04 0 {2.736 0.96} track 0.6 }}{offset: {0.754 0.7} }}} 
create_pg_composite_pattern PATTERN_M6_GND_BRIDGE -nets {VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS }} {parameters: {M6 horizontal 0.04 0 {2.736 0.96} track 0.6 }}{offset: {2.123 0.7} }}} 
create_pg_composite_pattern PATTERN_M8_PWR_BRIDGE -nets {VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE }} {parameters: {M8 horizontal 0.04 0 {2.736 0.96} track 0.6 }}{offset: {0.754 0.7} }}} 
create_pg_composite_pattern PATTERN_M8_GND_BRIDGE -nets {VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS }} {parameters: {M8 horizontal 0.04 0 {2.736 0.96} track 0.6 }}{offset: {2.123 0.7} }}} 
create_pg_composite_pattern PATTERN_M10_PWR_BRIDGE -nets {VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE }} {parameters: {M10 horizontal 0.062 0 {2.736 0.96} track 0.6 }}{offset: {0.754 0.7} }}} 
create_pg_composite_pattern PATTERN_M10_GND_BRIDGE -nets {VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS }} {parameters: {M10 horizontal 0.062 0 {2.736 0.96} track 0.6 }}{offset: {2.123 0.7} }}} 
create_pg_composite_pattern PATTERN_M3_GND_BRIDGE -nets {VSS VSS VSS VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS VSS VSS VSS }} {parameters: {M3 vertical 0.024 0.108 {2.736 0.96} track 0.3 }}{offset: {2.245 0.55} }}} 
create_pg_composite_pattern PATTERN_M3_PWR_BRIDGE -nets {VDD_CORE VDD_CORE VDD_CORE VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE VDD_CORE VDD_CORE VDD_CORE }} {parameters: {M3 vertical 0.024 0.108 {2.736 0.96} track 0.3 }}{offset: {0.877 0.55} }}} 
create_pg_composite_pattern PATTERN_M5_GND_BRIDGE -nets {VSS VSS VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS VSS VSS }} {parameters: {M5 vertical 0.038 0.114 {2.736 0.96} track 0.4 }}{offset: {2.289 0.5} }}} 
create_pg_composite_pattern PATTERN_M5_PWR_BRIDGE -nets {VDD_CORE VDD_CORE VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE VDD_CORE VDD_CORE }} {parameters: {M5 vertical 0.038 0.114 {2.736 0.96} track 0.4 }}{offset: {0.921 0.5} }}} 
create_pg_composite_pattern PATTERN_M7_GND_BRIDGE -nets {VSS VSS VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS VSS VSS }} {parameters: {M7 vertical 0.038 0.114 {2.736 0.96} track 0.4 }}{offset: {2.289 0.5} }}} 
create_pg_composite_pattern PATTERN_M7_PWR_BRIDGE -nets {VDD_CORE VDD_CORE VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE VDD_CORE VDD_CORE }} {parameters: {M7 vertical 0.038 0.114 {2.736 0.96} track 0.4 }}{offset: {0.921 0.5} }}} 
create_pg_composite_pattern PATTERN_M9_GND_BRIDGE -nets {VSS VSS } -add_patterns {{{pattern: pattern_bridge} {nets: {VSS VSS }} {parameters: {M9 vertical 0.076 0.152 {2.736 0.96} half_track 0.4 }}{offset: {2.327 0.5} }}} 
create_pg_composite_pattern PATTERN_M9_PWR_BRIDGE -nets {VDD_CORE VDD_CORE } -add_patterns {{{pattern: pattern_bridge} {nets: {VDD_CORE VDD_CORE }} {parameters: {M9 vertical 0.076 0.152 {2.736 0.96} half_track 0.4 }}{offset: {0.959 0.5} }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M4_PWR_MESH -nets {VDD_CORE } -add_patterns {{{pattern: wire_base_on_track} {nets: {VDD_CORE }} {parameters: {M4 horizontal 0.04 0.60 1.20 }}{offset: 0.1 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M4_GND_MESH -nets {VSS } -add_patterns {{{pattern: wire_base_on_track} {nets: {VSS }} {parameters: {M4 horizontal 0.04 0.60 1.20 }}{offset: 0.7 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M6_PWR_MESH -nets {VDD_CORE } -add_patterns {{{pattern: wire_base_on_track} {nets: {VDD_CORE }} {parameters: {M6 horizontal 0.04 0.60 1.20 }}{offset: 0.1 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M6_GND_MESH -nets {VSS } -add_patterns {{{pattern: wire_base_on_track} {nets: {VSS }} {parameters: {M6 horizontal 0.04 0.60 1.20 }}{offset: 0.7 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M5_PWR_MESH -nets {VDD_CORE } -add_patterns {{{pattern: wire_base_on_track} {nets: {VDD_CORE }} {parameters: {M5 vertical 0.038 0.60 1.20 }}{offset: 0.1 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M5_GND_MESH -nets {VSS } -add_patterns {{{pattern: wire_base_on_track} {nets: {VSS }} {parameters: {M5 vertical 0.038 0.60 1.20 }}{offset: 0.7 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M7_PWR_MESH -nets {VDD_CORE } -add_patterns {{{pattern: wire_base_on_track} {nets: {VDD_CORE }} {parameters: {M7 vertical 0.038 0.60 1.20 }}{offset: 0.1 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M7_GND_MESH -nets {VSS } -add_patterns {{{pattern: wire_base_on_track} {nets: {VSS }} {parameters: {M7 vertical 0.038 0.60 1.20 }}{offset: 0.7 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M8_PWR_MESH -nets {VDD_CORE } -add_patterns {{{pattern: wire_base_on_track} {nets: {VDD_CORE }} {parameters: {M8 horizontal 0.04 0.60 1.20 }}{offset: 0.1 }}} 
create_pg_composite_pattern PATTERN_SRAM_REGION_M8_GND_MESH -nets {VSS } -add_patterns {{{pattern: wire_base_on_track} {nets: {VSS }} {parameters: {M8 horizontal 0.04 0.60 1.20 }}{offset: 0.7 }}} 
set_pg_strategy STRATEGY_M11_PWR_MESH -pattern {{name: PATTERN_M11_PWR_MESH}  {nets: {VDD_CORE }} } -design_boundary -blockage {} 
set_pg_strategy STRATEGY_M11_GND_MESH -pattern {{name: PATTERN_M11_GND_MESH}  {nets: {VSS }} } -design_boundary -blockage {} 
set_pg_strategy STRATEGY_M2_PWR_BRIDGE -pattern {{name: PATTERN_M2_PWR_BRIDGE}  {nets: {VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M2_GND_BRIDGE -pattern {{name: PATTERN_M2_GND_BRIDGE}  {nets: {VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M1_PWR_MESH -pattern {{name: PATTERN_M1_PWR_MESH}  {nets: {VDD_CORE VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M1_GND_MESH -pattern {{name: PATTERN_M1_GND_MESH}  {nets: {VSS VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M4_PWR_BRIDGE -pattern {{name: PATTERN_M4_PWR_BRIDGE}  {nets: {VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M4_GND_BRIDGE -pattern {{name: PATTERN_M4_GND_BRIDGE}  {nets: {VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M6_PWR_BRIDGE -pattern {{name: PATTERN_M6_PWR_BRIDGE}  {nets: {VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M6_GND_BRIDGE -pattern {{name: PATTERN_M6_GND_BRIDGE}  {nets: {VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M8_PWR_BRIDGE -pattern {{name: PATTERN_M8_PWR_BRIDGE}  {nets: {VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M8_GND_BRIDGE -pattern {{name: PATTERN_M8_GND_BRIDGE}  {nets: {VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M10_PWR_BRIDGE -pattern {{name: PATTERN_M10_PWR_BRIDGE}  {nets: {VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M10_GND_BRIDGE -pattern {{name: PATTERN_M10_GND_BRIDGE}  {nets: {VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M3_GND_BRIDGE -pattern {{name: PATTERN_M3_GND_BRIDGE}  {nets: {VSS VSS VSS VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M3_PWR_BRIDGE -pattern {{name: PATTERN_M3_PWR_BRIDGE}  {nets: {VDD_CORE VDD_CORE VDD_CORE VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M5_GND_BRIDGE -pattern {{name: PATTERN_M5_GND_BRIDGE}  {nets: {VSS VSS VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M5_PWR_BRIDGE -pattern {{name: PATTERN_M5_PWR_BRIDGE}  {nets: {VDD_CORE VDD_CORE VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M7_GND_BRIDGE -pattern {{name: PATTERN_M7_GND_BRIDGE}  {nets: {VSS VSS VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M7_PWR_BRIDGE -pattern {{name: PATTERN_M7_PWR_BRIDGE}  {nets: {VDD_CORE VDD_CORE VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M9_GND_BRIDGE -pattern {{name: PATTERN_M9_GND_BRIDGE}  {nets: {VSS VSS }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_M9_PWR_BRIDGE -pattern {{name: PATTERN_M9_PWR_BRIDGE}  {nets: {VDD_CORE VDD_CORE }} } -core -blockage {{pg_regions: $core_block_regions} }
set_pg_strategy STRATEGY_SRAM_REGION_M4_PWR_MESH -pattern {{name: PATTERN_SRAM_REGION_M4_PWR_MESH}  {nets: {VDD_CORE }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M4_GND_MESH -pattern {{name: PATTERN_SRAM_REGION_M4_GND_MESH}  {nets: {VSS }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M6_PWR_MESH -pattern {{name: PATTERN_SRAM_REGION_M6_PWR_MESH}  {nets: {VDD_CORE }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M6_GND_MESH -pattern {{name: PATTERN_SRAM_REGION_M6_GND_MESH}  {nets: {VSS }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M5_PWR_MESH -pattern {{name: PATTERN_SRAM_REGION_M5_PWR_MESH}  {nets: {VDD_CORE }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M5_GND_MESH -pattern {{name: PATTERN_SRAM_REGION_M5_GND_MESH}  {nets: {VSS }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M7_PWR_MESH -pattern {{name: PATTERN_SRAM_REGION_M7_PWR_MESH}  {nets: {VDD_CORE }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M7_GND_MESH -pattern {{name: PATTERN_SRAM_REGION_M7_GND_MESH}  {nets: {VSS }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M8_PWR_MESH -pattern {{name: PATTERN_SRAM_REGION_M8_PWR_MESH}  {nets: {VDD_CORE }} } -macro $sram_macros
set_pg_strategy STRATEGY_SRAM_REGION_M8_GND_MESH -pattern {{name: PATTERN_SRAM_REGION_M8_GND_MESH}  {nets: {VSS }} } -macro $sram_macros
set_pg_strategy_via_rule VIA_RULE -via_rule { \
{{{strategies: STRATEGY_M10_PWR_BRIDGE}{layers: M10}}{{strategies: STRATEGY_M11_PWR_MESH}{layers: M11}}{via_master:VIA1011_DFM_P4_VIAyy_LE0v27_W62v62_C1v1_S0v0_HE27v27_HC} } \
{{{strategies: STRATEGY_M10_GND_BRIDGE}{layers: M10}}{{strategies: STRATEGY_M11_GND_MESH}{layers: M11}}{via_master:VIA1011_DFM_P4_VIAyy_LE0v27_W62v62_C1v1_S0v0_HE27v27_HC} } \
{{{strategies: STRATEGY_M9_GND_BRIDGE}{layers: M9}}{{strategies: STRATEGY_M10_GND_BRIDGE}{layers: M10}}{via_master:VIA910_1cut_NDR} } \
{{{strategies: STRATEGY_M9_PWR_BRIDGE}{layers: M9}}{{strategies: STRATEGY_M10_PWR_BRIDGE}{layers: M10}}{via_master:VIA910_1cut_NDR} } \
{{{strategies: STRATEGY_M8_PWR_BRIDGE}{layers: M8}}{{strategies: STRATEGY_M9_PWR_BRIDGE}{layers: M9}}{via_master:default} } \
{{{strategies: STRATEGY_M8_GND_BRIDGE}{layers: M8}}{{strategies: STRATEGY_M9_GND_BRIDGE}{layers: M9}}{via_master:default} } \
{{{strategies: STRATEGY_M7_PWR_BRIDGE}{layers: M7}}{{strategies: STRATEGY_M8_PWR_BRIDGE}{layers: M8}}{via_master:default} } \
{{{strategies: STRATEGY_M7_GND_BRIDGE}{layers: M7}}{{strategies: STRATEGY_M8_GND_BRIDGE}{layers: M8}}{via_master:default} } \
{{{strategies: STRATEGY_M6_PWR_BRIDGE}{layers: M6}}{{strategies: STRATEGY_M7_PWR_BRIDGE}{layers: M7}}{via_master:default} } \
{{{strategies: STRATEGY_M6_GND_BRIDGE}{layers: M6}}{{strategies: STRATEGY_M7_GND_BRIDGE}{layers: M7}}{via_master:default} } \
{{{strategies: STRATEGY_M5_PWR_BRIDGE}{layers: M5}}{{strategies: STRATEGY_M6_PWR_BRIDGE}{layers: M6}}{via_master:default} } \
{{{strategies: STRATEGY_M5_GND_BRIDGE}{layers: M5}}{{strategies: STRATEGY_M6_GND_BRIDGE}{layers: M6}}{via_master:default} } \
{{{strategies: STRATEGY_M4_PWR_BRIDGE}{layers: M4}}{{strategies: STRATEGY_M5_PWR_BRIDGE}{layers: M5}}{via_master:default} } \
{{{strategies: STRATEGY_M4_GND_BRIDGE}{layers: M4}}{{strategies: STRATEGY_M5_GND_BRIDGE}{layers: M5}}{via_master:default} } \
{{{strategies: STRATEGY_M3_PWR_BRIDGE}{layers: M3}}{{strategies: STRATEGY_M4_PWR_BRIDGE}{layers: M4}}{via_master:default} } \
{{{strategies: STRATEGY_M3_GND_BRIDGE}{layers: M3}}{{strategies: STRATEGY_M4_GND_BRIDGE}{layers: M4}}{via_master:default} } \
{{{strategies: STRATEGY_M2_PWR_BRIDGE}{layers: M2}}{{strategies: STRATEGY_M3_PWR_BRIDGE}{layers: M3}}{via_master:VIA23_1cut_BW20_UW24} } \
{{{strategies: STRATEGY_M2_GND_BRIDGE}{layers: M2}}{{strategies: STRATEGY_M3_GND_BRIDGE}{layers: M3}}{via_master:VIA23_1cut_BW20_UW24} } \
{{{strategies: STRATEGY_M1_PWR_MESH}{layers: M1}}{{strategies: STRATEGY_M2_PWR_BRIDGE}{layers: M2}}{via_master:default} } \
{{{strategies: STRATEGY_M1_GND_MESH}{layers: M1}}{{strategies: STRATEGY_M2_GND_BRIDGE}{layers: M2}}{via_master:default} } \
{{{existing : std_conn }}{{strategies: STRATEGY_M1_PWR_MESH}{layers: M1}}{via_master:VIA01_PG_LONG} } \
{{{existing : std_conn }}{{strategies: STRATEGY_M1_GND_MESH}{layers: M1}}{via_master:VIA01_PG_LONG} } \
{{{strategies: STRATEGY_SRAM_REGION_M4_PWR_MESH}{layers: M4}}{{strategies: STRATEGY_SRAM_REGION_M5_PWR_MESH}{layers: M5}}{via_master:default} } \
{{{strategies: STRATEGY_SRAM_REGION_M4_GND_MESH}{layers: M4}}{{strategies: STRATEGY_SRAM_REGION_M5_GND_MESH}{layers: M5}}{via_master:default} } \
{{{strategies: STRATEGY_SRAM_REGION_M5_PWR_MESH}{layers: M5}}{{strategies: STRATEGY_SRAM_REGION_M6_PWR_MESH}{layers: M6}}{via_master:default} } \
{{{strategies: STRATEGY_SRAM_REGION_M5_GND_MESH}{layers: M5}}{{strategies: STRATEGY_SRAM_REGION_M6_GND_MESH}{layers: M6}}{via_master:default} } \
{{{strategies: STRATEGY_SRAM_REGION_M6_PWR_MESH}{layers: M6}}{{strategies: STRATEGY_SRAM_REGION_M7_PWR_MESH}{layers: M7}}{via_master:default} } \
{{{strategies: STRATEGY_SRAM_REGION_M6_GND_MESH}{layers: M6}}{{strategies: STRATEGY_SRAM_REGION_M7_GND_MESH}{layers: M7}}{via_master:default} } \
{{{strategies: STRATEGY_SRAM_REGION_M7_PWR_MESH}{layers: M7}}{{strategies: STRATEGY_SRAM_REGION_M8_PWR_MESH}{layers: M8}}{via_master:VIA78_1cut_BW38_UW40} } \
{{{strategies: STRATEGY_SRAM_REGION_M7_GND_MESH}{layers: M7}}{{strategies: STRATEGY_SRAM_REGION_M8_GND_MESH}{layers: M8}}{via_master:VIA78_1cut_BW38_UW40} } \
{{{strategies: STRATEGY_SRAM_REGION_M8_PWR_MESH}{layers: M8}}{{existing : strap} {layers: M11}}{via_master:VIA_8_11} } \
{{{strategies: STRATEGY_SRAM_REGION_M8_GND_MESH}{layers: M8}}{{existing : strap} {layers: M11}}{via_master:VIA_8_11} } \
{{intersection: adjacent}{via_master: default}} } 
compile_pg -strategies { STRATEGY_M11_PWR_MESH STRATEGY_M11_GND_MESH STRATEGY_M2_PWR_BRIDGE STRATEGY_M2_GND_BRIDGE STRATEGY_M1_PWR_MESH STRATEGY_M1_GND_MESH STRATEGY_M4_PWR_BRIDGE STRATEGY_M4_GND_BRIDGE STRATEGY_M6_PWR_BRIDGE STRATEGY_M6_GND_BRIDGE STRATEGY_M8_PWR_BRIDGE STRATEGY_M8_GND_BRIDGE STRATEGY_M10_PWR_BRIDGE STRATEGY_M10_GND_BRIDGE STRATEGY_M3_GND_BRIDGE STRATEGY_M3_PWR_BRIDGE STRATEGY_M5_GND_BRIDGE STRATEGY_M5_PWR_BRIDGE STRATEGY_M7_GND_BRIDGE STRATEGY_M7_PWR_BRIDGE STRATEGY_M9_GND_BRIDGE STRATEGY_M9_PWR_BRIDGE} -via_rule {VIA_RULE} -ignore_via_drc 
compile_pg -strategies { STRATEGY_SRAM_REGION_M4_PWR_MESH STRATEGY_SRAM_REGION_M4_GND_MESH STRATEGY_SRAM_REGION_M6_PWR_MESH STRATEGY_SRAM_REGION_M6_GND_MESH STRATEGY_SRAM_REGION_M5_PWR_MESH STRATEGY_SRAM_REGION_M5_GND_MESH STRATEGY_SRAM_REGION_M7_PWR_MESH STRATEGY_SRAM_REGION_M7_GND_MESH STRATEGY_SRAM_REGION_M8_PWR_MESH STRATEGY_SRAM_REGION_M8_GND_MESH} -via_rule {VIA_RULE} 
derive_mask_constraint [get_shapes *] 

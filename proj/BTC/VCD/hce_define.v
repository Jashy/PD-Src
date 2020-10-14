`define TD #1

//BEGIN ONLY TOP USE
`define HCE_CITY    12'd99
`define HCE_RADIO       8'hEF
//END ONLY TOP USE

//`define HCE_INST_ADDER
//`define HCE_INST_K_IN_ADDER
//`define HCE_INST_ICG_DFF

`define HCE_FULL_PIPE_LATENCY 126
`define HCE_STG0_PIPE_LATENCY 63
`define HCE_STG1_PIPE_LATENCY 63
`define HCE_DATA3_LATENCY 14

`define HCE_CFG_SIZE    19  
`define HCE_MATRIX_SIZE 32*`HCE_CFG_SIZE
`define HCE_CITY_TOP `HCE_CITY

`define INDEX(x) (((x)+1)*(32)-1):((x)*(32))
`define IDX2X(x) (((2*x)+1)*(32)-1):((2*x)*(32))
`define INDEX256(x) (((x)+1)*(256)-1):((x)*(256))
`define E0(x) ( {x[1:0],x[31:2]} ^ {x[12:0],x[31:13]} ^ {x[21:0],x[31:22]} )
`define E1(x) ( {x[5:0],x[31:6]} ^ {x[10:0],x[31:11]} ^ {x[24:0],x[31:25]} )
`define CH(x,y,z) ( ((x) & (y)) ^ ((~x) & (z)) )
`define MAJ(x,y,z) ( ((x) & (y)) ^ ((y) & (z)) ^ ((x) & (z)) )
`define S0(x) ( { x[6:4] ^ x[17:15], {x[3:0], x[31:7]} ^ {x[14:0],x[31:18]} ^ x[31:3] } )
`define S1(x) ( { x[16:7] ^ x[18:9], {x[6:0], x[31:17]} ^ {x[8:0],x[31:19]} ^ x[31:10] } )

`define init_a	32'h6a09e667
`define init_b	32'hbb67ae85
`define init_c	32'h3c6ef372
`define init_d	32'ha54ff53a
`define init_e	32'h510e527f
`define init_f	32'h9b05688c
`define init_g	32'h1f83d9ab
`define init_h	32'h5be0cd19

`define tail_0	32'h80000000
`define size_0	32'h00000280
`define size_1	32'h00000100

`define k_table { \
		32'hc67178f2, 32'hbef9a3f7, 32'ha4506ceb, 32'h90befffa, \
		32'h8cc70208, 32'h84c87814, 32'h78a5636f, 32'h748f82ee, \
		32'h682e6ff3, 32'h5b9cca4f, 32'h4ed8aa4a, 32'h391c0cb3, \
		32'h34b0bcb5, 32'h2748774c, 32'h1e376c08, 32'h19a4c116, \
		32'h106aa070, 32'hf40e3585, 32'hd6990624, 32'hd192e819, \
		32'hc76c51a3, 32'hc24b8b70, 32'ha81a664b, 32'ha2bfe8a1, \
		32'h92722c85, 32'h81c2c92e, 32'h766a0abb, 32'h650a7354, \
		32'h53380d13, 32'h4d2c6dfc, 32'h2e1b2138, 32'h27b70a85, \
		32'h14292967, 32'h06ca6351, 32'hd5a79147, 32'hc6e00bf3, \
		32'hbf597fc7, 32'hb00327c8, 32'ha831c66d, 32'h983e5152, \
		32'h76f988da, 32'h5cb0a9dc, 32'h4a7484aa, 32'h2de92c6f, \
		32'h240ca1cc, 32'h0fc19dc6, 32'hefbe4786, 32'he49b69c1, \
		32'hc19bf174, 32'h9bdc06a7, 32'h80deb1fe, 32'h72be5d74, \
		32'h550c7dc3, 32'h243185be, 32'h12835b01, 32'hd807aa98, \
		32'hab1c5ed5, 32'h923f82a4, 32'h59f111f1, 32'h3956c25b, \
		32'he9b5dba5, 32'hb5c0fbcf, 32'h71374491, 32'h428a2f98}
		
`define phase(x) (cycle_cnt == x)

`define HCE_CFG_N0_A		'h00
`define HCE_CFG_T0_A		'h01
`define HCE_CFG_A0_A		'h02
`define HCE_CFG_B0_A		'h03
`define HCE_CFG_C0_A		'h04
`define HCE_CFG_D0_A		'h05
`define HCE_CFG_E0_A		'h06
`define HCE_CFG_F0_A		'h07
`define HCE_CFG_G0_A		'h08
`define HCE_CFG_H0_A		'h09
`define HCE_CFG_W0_A		'h0A
`define HCE_CFG_W1_A		'h0B
`define HCE_CFG_W2_A		'h0C
`define HCE_CFG_A3_A		'h0D
`define HCE_CFG_B3_A		'h0E
`define HCE_CFG_C3_A		'h0F
`define HCE_CFG_E3_A		'h10
`define HCE_CFG_F3_A		'h11
`define HCE_CFG_G3_A		'h12

`define HCE_CFG_MISC_A		'h18
`define HCE_BIST_CTL_A		'h1A
`define HCE_TOP_CTL_A		'h1C

//  {start_nonce,job_difct_buf,dat_a0,dat_b0,dat_c0,dat_d0,dat_e0,dat_f0,dat_g0,dat_h0,dat_w0,dat_w1,dat_w2} <= #1 `HCE_DEFAULT_TASK;
`define HCE_DEFAULT_N0 32'h12ece881
`define HCE_DEFAULT_T0 32'h007fff80
`define HCE_DEFAULT_A0 32'ha3c7b4d2
`define HCE_DEFAULT_B0 32'h33632f5e
`define HCE_DEFAULT_C0 32'h1e6b6adb
`define HCE_DEFAULT_D0 32'h05bff4ed
`define HCE_DEFAULT_E0 32'h1e0cc360
`define HCE_DEFAULT_F0 32'he215bafd
`define HCE_DEFAULT_G0 32'h42b6b522
`define HCE_DEFAULT_H0 32'h20c533f8
`define HCE_DEFAULT_W0 32'h0ecc7aac
`define HCE_DEFAULT_W1 32'hf3760b54
`define HCE_DEFAULT_W2 32'hee152818

`define HCE_DEFAULT_TASK { \
    `HCE_DEFAULT_N0, \
    `HCE_DEFAULT_T0, \
    `HCE_DEFAULT_A0, \
    `HCE_DEFAULT_B0, \
    `HCE_DEFAULT_C0, \
    `HCE_DEFAULT_D0, \
    `HCE_DEFAULT_E0, \
    `HCE_DEFAULT_F0, \
    `HCE_DEFAULT_G0, \
    `HCE_DEFAULT_H0, \
    `HCE_DEFAULT_W0, \
    `HCE_DEFAULT_W1, \
    `HCE_DEFAULT_W2 \
    }

`define HCE_DEFAULT_G3 32'ha4accc25
`define HCE_DEFAULT_F3 32'h502d9755
`define HCE_DEFAULT_E3 32'h709cebae
`define HCE_DEFAULT_C3 32'he307bf98
`define HCE_DEFAULT_B3 32'hb00280ab
`define HCE_DEFAULT_A3 32'hc3a0ffe8
`define HCE_DEFAULT_DATA3 { \
	`HCE_DEFAULT_G3, \
	`HCE_DEFAULT_F3, \
	`HCE_DEFAULT_E3, \
	`HCE_DEFAULT_C3, \
	`HCE_DEFAULT_B3, \
	`HCE_DEFAULT_A3 \
}	

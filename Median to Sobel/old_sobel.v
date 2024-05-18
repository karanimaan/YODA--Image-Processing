`define ROW 256
`define COL 256
`define width 8


module sobel(
// -----------------------------------------------------------------------------
// --------------------------------input's--------------------------------------
input     [`ROW*`width*3-1:0] 	row_in  ,//input row each clock event. 6144 bit
input 				CLK     ,//Clock.
input				SET	,//set 
input				RST     ,//reset
// -----------------------------------------------------------------------------
// --------------------------------output's-------------------------------------
output reg[`ROW*`width*3-1:0] 	row_out  //output row fixed each clock event.		
);
// -----------------------------------------------------------------------------
// -------------------------------register's------------------------------------
reg       [`ROW*`width*3-1:0]	line_1  ;//up.
reg       [`ROW*`width*3-1:0]	line_2  ;//middle.
reg       [`ROW*`width*3-1:0]	line_3  ;//down.
reg		       [2:0] state, next;//state mechine.
reg             [`width-1:0]   counter  ;//counter
// -----------------------------------------------------------------------------

for (i=0; i<`ROW; i=i+1) begin
    for
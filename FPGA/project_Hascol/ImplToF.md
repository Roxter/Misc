using bincompl;







process type Ext = begin
	in input_ena(1);
	in output_rdy_ena(1);
	out output_ena(1);
	out input_rdy_ena(1);
end;

process type Ext1 = begin
	in input_ena(1);
	in output_rdy_ena(1);
	out output_ena(1);
end;

process type Ext2 = begin
	in input_ena(1);
	in output_rdy_ena(1);
	out output_ena(1);
end;

process type Ext3 = begin
	in input_ena(1);
	in output_rdy_ena(1);
	out output_ena(1);
end;

module Top = begin
	
	process Main = begin
	
		in inp(int(16)) {forceLive};
		out outp(uint(64), uint(64), uint(64), uint(1)) {forceLive};
		out outp1(uint(64), uint(64), uint(64), uint(1)) {forceLive};
		out outpVars(uint(10), uint(64), uint(64)) {forceLive};

		data sums: [0..63:uint(10)] int(24);
		data sumsqs: [0..63:uint(10)] uint(32);
		data i: uint(10) = 0;
		data defi: 1 = 0b1;
		data endofoutp: uint(1) = 0;
		data endofoutp1: uint(1) = 0;
		data icoefmult: [0..63:uint(10)] uint(13);
		data varLeft: [0..63:uint(10)] uint(64);
		data varLeft1: [0..63:uint(10)] uint(48);
		data varLeft2: [0..63:uint(10)] uint(48);
		data varRight: [0..63:uint(10)] uint(64);
		data varRight1: [0..63:uint(10)] uint(72);
		data varRight2: [0..63:uint(10)] uint(72);

		default {
			if defi then
				icoefmult[0] := 0 | icoefmult[1] := 4096 | icoefmult[2] := 2048 | icoefmult[3] := 1365 | icoefmult[4] := 1024 | icoefmult[5] := 819 | icoefmult[6] := 682 | icoefmult[7] := 585 | icoefmult[8] := 512 | icoefmult[9] := 455 | icoefmult[10] := 409 | icoefmult[11] := 372 | icoefmult[12] := 341 | icoefmult[13] := 315 | icoefmult[14] := 292 | icoefmult[15] := 273 | icoefmult[16] := 256 | icoefmult[17] := 240 | icoefmult[18] := 227 | icoefmult[19] := 215 | icoefmult[20] := 204 | icoefmult[21] := 195 | icoefmult[22] := 186 | icoefmult[23] := 178 | icoefmult[24] := 170 | icoefmult[25] := 163 | icoefmult[26] := 157 | icoefmult[27] := 151 | icoefmult[28] := 146 | icoefmult[29] := 141 | icoefmult[30] := 136 | icoefmult[31] := 132 | icoefmult[32] := 128 | icoefmult[33] := 124 | icoefmult[34] := 120 | icoefmult[35] := 117 | icoefmult[36] := 113 | icoefmult[37] := 110 | icoefmult[38] := 107 | icoefmult[39] := 105 | icoefmult[40] := 102 | icoefmult[41] := 99 | icoefmult[42] := 97 | icoefmult[43] := 95 | icoefmult[44] := 93 | icoefmult[45] := 91 | icoefmult[46] := 89 | icoefmult[47] := 87 | icoefmult[48] := 85 | icoefmult[49] := 83 | icoefmult[50] := 81 | icoefmult[51] := 80 | icoefmult[52] := 78 | icoefmult[53] := 77 | icoefmult[54] := 75 | icoefmult[55] := 74 | icoefmult[56] := 73 | icoefmult[57] := 71 | icoefmult[58] := 70 | icoefmult[59] := 69 | icoefmult[60] := 68 | icoefmult[61] := 67 | icoefmult[62] := 66 | icoefmult[63] := 65 |
				defi := 0b0 else skip fi |
			if i > 64 and i < 126 then 
					let subsumsqs = (ext((sumsqs[63]-sumsqs[i-64]),48)) in
					let qssubsums = (((sums[63] - sums[i-64]) >* (sums[63] - sums[i-64])):uint(48)) in
					let varR = (((( subsumsqs >* (ext(icoefmult[64-(i+1-64)],48)))>>12){0:63}):uint(64)) - (((( qssubsums >* (ext(icoefmult[64-(i+1-64)] >* icoefmult[64-(i+1-64)],48)))>>24){0:63}):uint(64)) in {
						if i == 125 then endofoutp1 := 0b1 else skip fi |
						inform outp1 ((ext(subsumsqs, 64)), (ext(qssubsums, 64)), varR, endofoutp1) |
						varRight[i-64] := varR
					} |
					inform outpVars (i, varLeft[i-64-1], varRight[i-64-1]) |
					i := i + 1
			else skip fi
		}
		
		inp(in0) { 
			if i < 64 then
				if (i == 0) then
					sums[i] := sext(in0, 24) |
					sumsqs[i] := ((in0 >* in0):uint(32)) |
					i := i + 1
				else
					sums[i] :=  sums[i-1] + sext(in0, 24) |
					sumsqs[i] :=  sumsqs[i-1] + ((in0 >* in0):uint(32)) |
					if i == 63 then
						i := i +2
					else
						i := i + 1 fi;
					if i != 1 and i < 63 then 													
						let qssumsqs = ext(sumsqs[i-1],48) in
						let qssums = ((sums[i-1] >* sums[i-1]):uint(48)) in
						let varL = ((((( qssumsqs >* (ext(icoefmult[i],48)))>>12){0:63}):uint(64)) - (((( qssums >* (ext(icoefmult[i] >* icoefmult[i],48)))>>24){0:63}):uint(64))) in {
							if i == 62 then endofoutp := 0b1 else skip fi |
							inform outp ((ext(qssumsqs, 64)), (ext(qssums, 64)), varL, endofoutp) |
							varLeft[i-1] := varL
						}
					else skip fi
				fi
			else skip fi
		}
		
		local: handlerForVar(k: uint(10)) when true {
			skip
		}
		
	end;
	
	module FromFile : begin
		interface slave : Ext;
		in input(1) {forceLive};
		out output(int(16)) {forceLive};
	end = external "01" with output = Main.inp;

	module ToFile : begin
		interface slave : Ext1;
		in input(1) {forceLive};
		in inputs(uint(64), uint(64), uint(64), uint(1)) {forceLive};
	end = external "02" with inputs = Main.outp;
	
	module ToFile1 : begin
		interface slave : Ext2;
		in input(1) {forceLive};
		in inputs(uint(64), uint(64), uint(64), uint(1)) {forceLive};
	end = external "03" with inputs = Main.outp1;
	
	module VarToLog : begin
		interface slave : Ext3;
		in input(1) {forceLive};
		in inputs(uint(10), uint(64), uint(64)) {forceLive};
	end = external "04" with inputs = Main.outpVars;

end;

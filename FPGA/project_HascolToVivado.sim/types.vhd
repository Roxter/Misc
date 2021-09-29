library work;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.IOShuvalkin.all;
use work.runtime.all;
use work.bincompl.all;
package types is
  type recinp is record 
                   p0 :  std_logic_vector (10-1 downto 0);
                 end record;
  type recinp2 is record 
                    p0 :  std_logic_vector (16-1 downto 0);
                  end record;
  type arrticoefmult1 is array(integer range <>) of  std_logic_vector (13-1 downto 0);
  type arrtsums1 is array(integer range <>) of  std_logic_vector (24-1 downto 0);
  type arrtsumsqs1 is array(integer range <>) of  std_logic_vector (32-1 downto 0);
  type arrtvarLeft1 is array(integer range <>) of  std_logic_vector (64-1 downto 0);
  type arrtvarLeft11 is array(integer range <>) of  std_logic_vector (48-1 downto 0);
  type arrtvarRight11 is array(integer range <>) of  std_logic_vector (72-1 downto 0);
  type recoutp is record 
                    p0 :  std_logic_vector (64-1 downto 0);
                    p1 :  std_logic_vector (64-1 downto 0);
                    p2 :  std_logic_vector (64-1 downto 0);
                    p3 : std_logic_vector (0 downto 0);
                  end record;
  type recoutpVars is record 
                        p0 :  std_logic_vector (10-1 downto 0);
                        p1 :  std_logic_vector (64-1 downto 0);
                        p2 :  std_logic_vector (64-1 downto 0);
                      end record;
  type recslave_output_ena is record 
                                p0 : std_logic_vector (0 downto 0);
                              end record;
  function conv_std_logic_vector(struc : recinp) return std_logic_vector;
  function zero(example : arrtvarLeft11) return arrtvarLeft11;
  function zero(example : recoutp) return recoutp;
  function halfMux(x : stlv00; y : recinp2) return recinp2;
  function toString(x : in arrtsums1) return stringPtr;
  function disjunction(x, y : recinp) return recinp;
  function toString(x : in arrticoefmult1) return stringPtr;
  function disjunction(x, y : arrtsums1) return arrtsums1;
  function toString(x : in arrtvarLeft11) return stringPtr;
  function halfMux(x : stlv00; y : recslave_output_ena) return recslave_output_ena;
  function halfMux(x : stlv00; y : arrtsums1) return arrtsums1;
  function disjunction(x, y : recslave_output_ena) return recslave_output_ena;
  function toString(x : in recoutpVars) return stringPtr;
  function toString(x : in arrtvarLeft1) return stringPtr;
  function disjunction(x, y : arrticoefmult1) return arrticoefmult1;
  function conv_std_logic_vector(arr : arrtsums1) return std_logic_vector;
  function zero(example : recinp) return recinp;
  function zero(example : recslave_output_ena) return recslave_output_ena;
  function conv_std_logic_vector(arr : arrtvarLeft11) return std_logic_vector;
  function zero(example : arrtvarLeft1) return arrtvarLeft1;
  function disjunction(x, y : arrtvarRight11) return arrtvarRight11;
  function conv_std_logic_vector(struc : recoutp) return std_logic_vector;
  function conv_std_logic_vector(arr : arrticoefmult1) return std_logic_vector;
  function disjunction(x, y : arrtsumsqs1) return arrtsumsqs1;
  function disjunction(x, y : recoutp) return recoutp;
  function zero(example : recoutpVars) return recoutpVars;
  function halfMux(x : stlv00; y : arrtvarRight11) return arrtvarRight11;
  function zero(example : arrtsumsqs1) return arrtsumsqs1;
  function disjunction(x, y : recinp2) return recinp2;
  function halfMux(x : stlv00; y : recinp) return recinp;
  function toString(x : in arrtsumsqs1) return stringPtr;
  function disjunction(x, y : arrtvarLeft1) return arrtvarLeft1;
  function zero(example : arrtvarRight11) return arrtvarRight11;
  function toString(x : in recslave_output_ena) return stringPtr;
  function halfMux(x : stlv00; y : arrtsumsqs1) return arrtsumsqs1;
  function toString(x : in recoutp) return stringPtr;
  function toString(x : in recinp2) return stringPtr;
  function halfMux(x : stlv00; y : arrtvarLeft1) return arrtvarLeft1;
  function conv_std_logic_vector(arr : arrtsumsqs1) return std_logic_vector;
  function zero(example : arrticoefmult1) return arrticoefmult1;
  function halfMux(x : stlv00; y : recoutpVars) return recoutpVars;
  function toString(x : in recinp) return stringPtr;
  function conv_std_logic_vector(arr : arrtvarRight11) return std_logic_vector;
  function disjunction(x, y : recoutpVars) return recoutpVars;
  function zero(example : arrtsums1) return arrtsums1;
  function toString(x : in arrtvarRight11) return stringPtr;
  function zero(example : recinp2) return recinp2;
  function halfMux(x : stlv00; y : arrticoefmult1) return arrticoefmult1;
  function conv_std_logic_vector(struc : recoutpVars) return std_logic_vector;
  function halfMux(x : stlv00; y : recoutp) return recoutp;
  function conv_std_logic_vector(arr : arrtvarLeft1) return std_logic_vector;
  function conv_std_logic_vector(struc : recslave_output_ena) return std_logic_vector;
  function conv_std_logic_vector(struc : recinp2) return std_logic_vector;
  function halfMux(x : stlv00; y : arrtvarLeft11) return arrtvarLeft11;
  function disjunction(x, y : arrtvarLeft11) return arrtvarLeft11;
  function arrayTrim(data : arrtsums1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector;
  function arrayTrim(data : arrticoefmult1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector;
  function arrayTrim(data : arrtsumsqs1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector;
  function arrayTrim(data : arrtvarLeft1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector;
  procedure ofScalearrticoefmult1(vector : std_logic_vector; result : out arrticoefmult1);
  procedure toStringList(prefix : string; width : integer; x : arrtsums1; variable l0 : inout stringPtrListPtr);
  procedure toStringList(prefix : string; width : integer; x : recoutpVars; variable res : inout stringPtrListPtr);
  procedure ofScalearrtvarLeft1(vector : std_logic_vector; result : out arrtvarLeft1);
  procedure ofScalearrtvarLeft11(vector : std_logic_vector; result : out arrtvarLeft11);
  procedure toStringList(prefix : string; width : integer; x : recinp2; variable res : inout stringPtrListPtr);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recoutpVars);
  procedure fromFile(file f : char_file; variable result : out recinp2);
  procedure toStringList(prefix : string; width : integer; x : recslave_output_ena; variable res : inout stringPtrListPtr);
  procedure toStringList(prefix : string; width : integer; x : arrticoefmult1; variable l0 : inout stringPtrListPtr);
  procedure ofScalerecoutp(vector : std_logic_vector; result : out recoutp);
  procedure ofScalerecoutpVars(vector : std_logic_vector; result : out recoutpVars);
  procedure fromFile(file f : char_file; variable result : out arrticoefmult1);
  procedure toStringList(prefix : string; width : integer; x : arrtvarLeft11; variable l0 : inout stringPtrListPtr);
  procedure toStringList(prefix : string; width : integer; x : arrtvarRight11; variable l0 : inout stringPtrListPtr);
  procedure fromFile(file f : char_file; variable result : out arrtvarLeft11);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtsumsqs1);
  procedure toStringList(prefix : string; width : integer; x : recoutp; variable res : inout stringPtrListPtr);
  procedure ofScalearrtsumsqs1(vector : std_logic_vector; result : out arrtsumsqs1);
  procedure fromFile(file f : char_file; variable result : out arrtvarRight11);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtsums1);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recoutp);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recslave_output_ena);
  procedure toStringList(prefix : string; width : integer; x : arrtsumsqs1; variable l0 : inout stringPtrListPtr);
  procedure ofScalearrtsums1(vector : std_logic_vector; result : out arrtsums1);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtvarLeft1);
  procedure fromFile(file f : char_file; variable result : out arrtsums1);
  procedure ofScalearrtvarRight11(vector : std_logic_vector; result : out arrtvarRight11);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtvarRight11);
  procedure fromFile(file f : char_file; variable result : out recslave_output_ena);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtvarLeft11);
  procedure fromFile(file f : char_file; variable result : out recinp);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recinp);
  procedure toStringList(prefix : string; width : integer; x : recinp; variable res : inout stringPtrListPtr);
  procedure fromFile(file f : char_file; variable result : out arrtsumsqs1);
  procedure ofScalerecinp2(vector : std_logic_vector; result : out recinp2);
  procedure fromFile(file f : char_file; variable result : out recoutp);
  procedure fromFile(file f : char_file; variable result : out arrtvarLeft1);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrticoefmult1);
  procedure toStringList(prefix : string; width : integer; x : arrtvarLeft1; variable l0 : inout stringPtrListPtr);
  procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recinp2);
  procedure fromFile(file f : char_file; variable result : out recoutpVars);
  procedure ofScalerecslave_output_ena(vector : std_logic_vector; result : out recslave_output_ena);
  procedure ofScalerecinp(vector : std_logic_vector; result : out recinp);
end package;
package body types is 

function toString(x : in recinp) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 1);
variable stringsOffs : integer := 0;
variable bufSize : integer := 4;
variable bufOffs : integer := 2;
variable buf : stringPtr;
begin
tmpStrings(0) :=  toStringUnsigned(x.p0);
for i in 0 to 1 - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high + 2;
end loop;
buf := new string(1 to bufSize);
buf.all(1) := '['; buf.all(bufSize) := ']';
for i in 0 to 1 - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all & "; ");
  bufOffs := bufOffs + tmpStrings(i).all'high + 2;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : recinp) return recinp is 

begin
return (p0 => zero(example.p0));
end zero;


function disjunction(x, y : recinp) return recinp is 

begin
return (p0 => disjunction(x.p0, y.p0));
end disjunction;


function halfMux(x : stlv00; y : recinp) return recinp is 

begin
return (p0 => halfMux(x, y.p0));
end halfMux;


function conv_std_logic_vector(struc : recinp) return std_logic_vector is 

begin
return   conv_std_logic_vector(struc.p0);
end conv_std_logic_vector;


function toString(x : in recinp2) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 1);
variable stringsOffs : integer := 0;
variable bufSize : integer := 4;
variable bufOffs : integer := 2;
variable buf : stringPtr;
begin
tmpStrings(0) :=  toStringSigned(x.p0);
for i in 0 to 1 - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high + 2;
end loop;
buf := new string(1 to bufSize);
buf.all(1) := '['; buf.all(bufSize) := ']';
for i in 0 to 1 - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all & "; ");
  bufOffs := bufOffs + tmpStrings(i).all'high + 2;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : recinp2) return recinp2 is 

begin
return (p0 => zero(example.p0));
end zero;


function disjunction(x, y : recinp2) return recinp2 is 

begin
return (p0 => disjunction(x.p0, y.p0));
end disjunction;


function halfMux(x : stlv00; y : recinp2) return recinp2 is 

begin
return (p0 => halfMux(x, y.p0));
end halfMux;


function conv_std_logic_vector(struc : recinp2) return std_logic_vector is 

begin
return   conv_std_logic_vector(struc.p0);
end conv_std_logic_vector;


function toString(x : in arrticoefmult1) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 3 * (x'high(1) - x'low(1) + 1));
variable buf : stringPtr;
variable stringsOffs : integer := 0;
variable stringsSize : integer := 0;
variable bufOffs : integer := 1;
variable bufSize : integer := 0;
begin
tmpStrings(stringsSize) := new string'("("); stringsSize := stringsSize + 1;
for i1 in x'low(1) to x'high(1) loop
  tmpStrings(stringsSize) :=  toStringUnsigned(x(i1));
  stringsSize := stringsSize + 1;
  if i1 /= x'high(1) then
    tmpStrings(stringsSize) := new string'(", ");stringsSize := stringsSize + 1;
  end if;
end loop;
tmpStrings(stringsSize) := new string'(")"); stringsSize := stringsSize + 1;
for i in 0 to stringsSize - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high;
end loop;
buf := new string(1 to bufSize);
for i in 0 to stringsSize - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all);
  bufOffs := bufOffs + tmpStrings(i).all'high;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : arrticoefmult1) return arrticoefmult1 is 
variable result : arrticoefmult1(example'range(1));
begin
result := (others => zero(example(example'low(1))));
return result;
end zero;


function disjunction(x, y : arrticoefmult1) return arrticoefmult1 is 
variable result : arrticoefmult1(x'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := disjunction(x(i1),  y(i1)) ;
end loop;
return result;
end disjunction;


function halfMux(x : stlv00; y : arrticoefmult1) return arrticoefmult1 is 
variable result : arrticoefmult1(y'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := halfMux(x,  y(i1)) ;
end loop;
return result;
end halfMux;


function conv_std_logic_vector(arr : arrticoefmult1) return std_logic_vector is 
variable result : std_logic_vector((arr'high(1) - arr'low(1) + 1)   *   
                                   13 - 1 downto 0);
variable offset : integer := 0;
begin
for i1 in arr'range(1) loop
  result(offset + 13 - 1 downto offset) := conv_std_logic_vector(arr(i1));
  offset := offset + 13;
end loop;
return result;
end conv_std_logic_vector;


function toString(x : in arrtsums1) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 3 * (x'high(1) - x'low(1) + 1));
variable buf : stringPtr;
variable stringsOffs : integer := 0;
variable stringsSize : integer := 0;
variable bufOffs : integer := 1;
variable bufSize : integer := 0;
begin
tmpStrings(stringsSize) := new string'("("); stringsSize := stringsSize + 1;
for i1 in x'low(1) to x'high(1) loop
  tmpStrings(stringsSize) :=  toStringSigned(x(i1));
  stringsSize := stringsSize + 1;
  if i1 /= x'high(1) then
    tmpStrings(stringsSize) := new string'(", ");stringsSize := stringsSize + 1;
  end if;
end loop;
tmpStrings(stringsSize) := new string'(")"); stringsSize := stringsSize + 1;
for i in 0 to stringsSize - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high;
end loop;
buf := new string(1 to bufSize);
for i in 0 to stringsSize - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all);
  bufOffs := bufOffs + tmpStrings(i).all'high;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : arrtsums1) return arrtsums1 is 
variable result : arrtsums1(example'range(1));
begin
result := (others => zero(example(example'low(1))));
return result;
end zero;


function disjunction(x, y : arrtsums1) return arrtsums1 is 
variable result : arrtsums1(x'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := disjunction(x(i1),  y(i1)) ;
end loop;
return result;
end disjunction;


function halfMux(x : stlv00; y : arrtsums1) return arrtsums1 is 
variable result : arrtsums1(y'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := halfMux(x,  y(i1)) ;
end loop;
return result;
end halfMux;


function conv_std_logic_vector(arr : arrtsums1) return std_logic_vector is 
variable result : std_logic_vector((arr'high(1) - arr'low(1) + 1)   *   
                                   24 - 1 downto 0);
variable offset : integer := 0;
begin
for i1 in arr'range(1) loop
  result(offset + 24 - 1 downto offset) := conv_std_logic_vector(arr(i1));
  offset := offset + 24;
end loop;
return result;
end conv_std_logic_vector;


function toString(x : in arrtsumsqs1) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 3 * (x'high(1) - x'low(1) + 1));
variable buf : stringPtr;
variable stringsOffs : integer := 0;
variable stringsSize : integer := 0;
variable bufOffs : integer := 1;
variable bufSize : integer := 0;
begin
tmpStrings(stringsSize) := new string'("("); stringsSize := stringsSize + 1;
for i1 in x'low(1) to x'high(1) loop
  tmpStrings(stringsSize) :=  toStringUnsigned(x(i1));
  stringsSize := stringsSize + 1;
  if i1 /= x'high(1) then
    tmpStrings(stringsSize) := new string'(", ");stringsSize := stringsSize + 1;
  end if;
end loop;
tmpStrings(stringsSize) := new string'(")"); stringsSize := stringsSize + 1;
for i in 0 to stringsSize - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high;
end loop;
buf := new string(1 to bufSize);
for i in 0 to stringsSize - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all);
  bufOffs := bufOffs + tmpStrings(i).all'high;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : arrtsumsqs1) return arrtsumsqs1 is 
variable result : arrtsumsqs1(example'range(1));
begin
result := (others => zero(example(example'low(1))));
return result;
end zero;


function disjunction(x, y : arrtsumsqs1) return arrtsumsqs1 is 
variable result : arrtsumsqs1(x'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := disjunction(x(i1),  y(i1)) ;
end loop;
return result;
end disjunction;


function halfMux(x : stlv00; y : arrtsumsqs1) return arrtsumsqs1 is 
variable result : arrtsumsqs1(y'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := halfMux(x,  y(i1)) ;
end loop;
return result;
end halfMux;


function conv_std_logic_vector(arr : arrtsumsqs1) return std_logic_vector is 
variable result : std_logic_vector((arr'high(1) - arr'low(1) + 1)   *   
                                   32 - 1 downto 0);
variable offset : integer := 0;
begin
for i1 in arr'range(1) loop
  result(offset + 32 - 1 downto offset) := conv_std_logic_vector(arr(i1));
  offset := offset + 32;
end loop;
return result;
end conv_std_logic_vector;


function toString(x : in arrtvarLeft1) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 3 * (x'high(1) - x'low(1) + 1));
variable buf : stringPtr;
variable stringsOffs : integer := 0;
variable stringsSize : integer := 0;
variable bufOffs : integer := 1;
variable bufSize : integer := 0;
begin
tmpStrings(stringsSize) := new string'("("); stringsSize := stringsSize + 1;
for i1 in x'low(1) to x'high(1) loop
  tmpStrings(stringsSize) :=  toStringUnsigned(x(i1));
  stringsSize := stringsSize + 1;
  if i1 /= x'high(1) then
    tmpStrings(stringsSize) := new string'(", ");stringsSize := stringsSize + 1;
  end if;
end loop;
tmpStrings(stringsSize) := new string'(")"); stringsSize := stringsSize + 1;
for i in 0 to stringsSize - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high;
end loop;
buf := new string(1 to bufSize);
for i in 0 to stringsSize - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all);
  bufOffs := bufOffs + tmpStrings(i).all'high;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : arrtvarLeft1) return arrtvarLeft1 is 
variable result : arrtvarLeft1(example'range(1));
begin
result := (others => zero(example(example'low(1))));
return result;
end zero;


function disjunction(x, y : arrtvarLeft1) return arrtvarLeft1 is 
variable result : arrtvarLeft1(x'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := disjunction(x(i1),  y(i1)) ;
end loop;
return result;
end disjunction;


function halfMux(x : stlv00; y : arrtvarLeft1) return arrtvarLeft1 is 
variable result : arrtvarLeft1(y'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := halfMux(x,  y(i1)) ;
end loop;
return result;
end halfMux;


function conv_std_logic_vector(arr : arrtvarLeft1) return std_logic_vector is 
variable result : std_logic_vector((arr'high(1) - arr'low(1) + 1)   *   
                                   64 - 1 downto 0);
variable offset : integer := 0;
begin
for i1 in arr'range(1) loop
  result(offset + 64 - 1 downto offset) := conv_std_logic_vector(arr(i1));
  offset := offset + 64;
end loop;
return result;
end conv_std_logic_vector;


function toString(x : in arrtvarLeft11) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 3 * (x'high(1) - x'low(1) + 1));
variable buf : stringPtr;
variable stringsOffs : integer := 0;
variable stringsSize : integer := 0;
variable bufOffs : integer := 1;
variable bufSize : integer := 0;
begin
tmpStrings(stringsSize) := new string'("("); stringsSize := stringsSize + 1;
for i1 in x'low(1) to x'high(1) loop
  tmpStrings(stringsSize) :=  toStringUnsigned(x(i1));
  stringsSize := stringsSize + 1;
  if i1 /= x'high(1) then
    tmpStrings(stringsSize) := new string'(", ");stringsSize := stringsSize + 1;
  end if;
end loop;
tmpStrings(stringsSize) := new string'(")"); stringsSize := stringsSize + 1;
for i in 0 to stringsSize - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high;
end loop;
buf := new string(1 to bufSize);
for i in 0 to stringsSize - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all);
  bufOffs := bufOffs + tmpStrings(i).all'high;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : arrtvarLeft11) return arrtvarLeft11 is 
variable result : arrtvarLeft11(example'range(1));
begin
result := (others => zero(example(example'low(1))));
return result;
end zero;


function disjunction(x, y : arrtvarLeft11) return arrtvarLeft11 is 
variable result : arrtvarLeft11(x'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := disjunction(x(i1),  y(i1)) ;
end loop;
return result;
end disjunction;


function halfMux(x : stlv00; y : arrtvarLeft11) return arrtvarLeft11 is 
variable result : arrtvarLeft11(y'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := halfMux(x,  y(i1)) ;
end loop;
return result;
end halfMux;


function conv_std_logic_vector(arr : arrtvarLeft11) return std_logic_vector is 
variable result : std_logic_vector((arr'high(1) - arr'low(1) + 1)   *   
                                   48 - 1 downto 0);
variable offset : integer := 0;
begin
for i1 in arr'range(1) loop
  result(offset + 48 - 1 downto offset) := conv_std_logic_vector(arr(i1));
  offset := offset + 48;
end loop;
return result;
end conv_std_logic_vector;


function toString(x : in arrtvarRight11) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 3 * (x'high(1) - x'low(1) + 1));
variable buf : stringPtr;
variable stringsOffs : integer := 0;
variable stringsSize : integer := 0;
variable bufOffs : integer := 1;
variable bufSize : integer := 0;
begin
tmpStrings(stringsSize) := new string'("("); stringsSize := stringsSize + 1;
for i1 in x'low(1) to x'high(1) loop
  tmpStrings(stringsSize) :=  toStringUnsigned(x(i1));
  stringsSize := stringsSize + 1;
  if i1 /= x'high(1) then
    tmpStrings(stringsSize) := new string'(", ");stringsSize := stringsSize + 1;
  end if;
end loop;
tmpStrings(stringsSize) := new string'(")"); stringsSize := stringsSize + 1;
for i in 0 to stringsSize - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high;
end loop;
buf := new string(1 to bufSize);
for i in 0 to stringsSize - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all);
  bufOffs := bufOffs + tmpStrings(i).all'high;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : arrtvarRight11) return arrtvarRight11 is 
variable result : arrtvarRight11(example'range(1));
begin
result := (others => zero(example(example'low(1))));
return result;
end zero;


function disjunction(x, y : arrtvarRight11) return arrtvarRight11 is 
variable result : arrtvarRight11(x'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := disjunction(x(i1),  y(i1)) ;
end loop;
return result;
end disjunction;


function halfMux(x : stlv00; y : arrtvarRight11) return arrtvarRight11 is 
variable result : arrtvarRight11(y'range(1));
begin
for i1 in result'range(1) loop
  result(i1) := halfMux(x,  y(i1)) ;
end loop;
return result;
end halfMux;


function conv_std_logic_vector(arr : arrtvarRight11) return std_logic_vector is 
variable result : std_logic_vector((arr'high(1) - arr'low(1) + 1)   *   
                                   72 - 1 downto 0);
variable offset : integer := 0;
begin
for i1 in arr'range(1) loop
  result(offset + 72 - 1 downto offset) := conv_std_logic_vector(arr(i1));
  offset := offset + 72;
end loop;
return result;
end conv_std_logic_vector;


function toString(x : in recoutp) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 4);
variable stringsOffs : integer := 0;
variable bufSize : integer := 4;
variable bufOffs : integer := 2;
variable buf : stringPtr;
begin
tmpStrings(3) :=  toStringUnsigned(x.p3);
tmpStrings(2) :=  toStringUnsigned(x.p2);
tmpStrings(1) :=  toStringUnsigned(x.p1);
tmpStrings(0) :=  toStringUnsigned(x.p0);
for i in 0 to 4 - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high + 2;
end loop;
buf := new string(1 to bufSize);
buf.all(1) := '['; buf.all(bufSize) := ']';
for i in 0 to 4 - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all & "; ");
  bufOffs := bufOffs + tmpStrings(i).all'high + 2;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : recoutp) return recoutp is 

begin
return (p0 => zero(example.p0),  p1 => zero(example.p1),  p2 => zero(example.p2),  p3 => zero(example.p3));
end zero;


function disjunction(x, y : recoutp) return recoutp is 

begin
return (p0 => disjunction(x.p0, y.p0),  p1 => disjunction(x.p1, y.p1),  p2 => disjunction(x.p2, y.p2),  p3 => disjunction(x.p3, y.p3));
end disjunction;


function halfMux(x : stlv00; y : recoutp) return recoutp is 

begin
return (p0 => halfMux(x, y.p0),  p1 => halfMux(x, y.p1),  p2 => halfMux(x, y.p2),  p3 => halfMux(x, y.p3));
end halfMux;


function conv_std_logic_vector(struc : recoutp) return std_logic_vector is 

begin
return   
conv_std_logic_vector(struc.p0)   &   conv_std_logic_vector(struc.p1)
   &   conv_std_logic_vector(struc.p2)   &   conv_std_logic_vector(struc.p3);
end conv_std_logic_vector;


function toString(x : in recoutpVars) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 3);
variable stringsOffs : integer := 0;
variable bufSize : integer := 4;
variable bufOffs : integer := 2;
variable buf : stringPtr;
begin
tmpStrings(2) :=  toStringUnsigned(x.p2);
tmpStrings(1) :=  toStringUnsigned(x.p1);
tmpStrings(0) :=  toStringUnsigned(x.p0);
for i in 0 to 3 - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high + 2;
end loop;
buf := new string(1 to bufSize);
buf.all(1) := '['; buf.all(bufSize) := ']';
for i in 0 to 3 - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all & "; ");
  bufOffs := bufOffs + tmpStrings(i).all'high + 2;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : recoutpVars) return recoutpVars is 

begin
return (p0 => zero(example.p0),  p1 => zero(example.p1),  p2 => zero(example.p2));
end zero;


function disjunction(x, y : recoutpVars) return recoutpVars is 

begin
return (p0 => disjunction(x.p0, y.p0),  p1 => disjunction(x.p1, y.p1),  p2 => disjunction(x.p2, y.p2));
end disjunction;


function halfMux(x : stlv00; y : recoutpVars) return recoutpVars is 

begin
return (p0 => halfMux(x, y.p0),  p1 => halfMux(x, y.p1),  p2 => halfMux(x, y.p2));
end halfMux;


function conv_std_logic_vector(struc : recoutpVars) return std_logic_vector is 

begin
return   
conv_std_logic_vector(struc.p0)   &   conv_std_logic_vector(struc.p1)
   &   conv_std_logic_vector(struc.p2);
end conv_std_logic_vector;


function toString(x : in recslave_output_ena) return stringPtr is 
variable tmpStrings : stringPtrArray(0 to 1);
variable stringsOffs : integer := 0;
variable bufSize : integer := 4;
variable bufOffs : integer := 2;
variable buf : stringPtr;
begin
tmpStrings(0) := toString(x.p0);
for i in 0 to 1 - 1 loop
  bufSize := bufSize + tmpStrings(i).all'high + 2;
end loop;
buf := new string(1 to bufSize);
buf.all(1) := '['; buf.all(bufSize) := ']';
for i in 0 to 1 - 1 loop
  strcpy(buf, bufOffs, tmpStrings(i).all & "; ");
  bufOffs := bufOffs + tmpStrings(i).all'high + 2;
  deallocate(tmpStrings(i));
end loop;
return buf;
end toString;


function zero(example : recslave_output_ena) return recslave_output_ena is 

begin
return (p0 => zero(example.p0));
end zero;


function disjunction(x, y : recslave_output_ena) return recslave_output_ena is 

begin
return (p0 => disjunction(x.p0, y.p0));
end disjunction;


function halfMux(x : stlv00; y : recslave_output_ena) return recslave_output_ena is 

begin
return (p0 => halfMux(x, y.p0));
end halfMux;


function conv_std_logic_vector(struc : recslave_output_ena) return std_logic_vector is 

begin
return   conv_std_logic_vector(struc.p0);
end conv_std_logic_vector;


function arrayTrim(data : arrticoefmult1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector is 
variable result :  std_logic_vector (13-1 downto 0);
begin
result := data(notCheck(0 +  conv_integer_bound_unsigned(p0,  0),  0,  63));return result;
end arrayTrim;
function arrayTrim(data : arrtsumsqs1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector is 
variable result :  std_logic_vector (32-1 downto 0);
begin
result := data(notCheck(0 +  conv_integer_bound_unsigned(p0,  0),  0,  63));return result;
end arrayTrim;
function arrayTrim(data : arrtsums1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector is 
variable result :  std_logic_vector (24-1 downto 0);
begin
result := data(notCheck(0 +  conv_integer_bound_unsigned(p0,  0),  0,  63));return result;
end arrayTrim;
function arrayTrim(data : arrtvarLeft1(0 to 63); p0 :  std_logic_vector (10-1 downto 0)) return  std_logic_vector is 
variable result :  std_logic_vector (64-1 downto 0);
begin
result := data(notCheck(0 +  conv_integer_bound_unsigned(p0,  0),  0,  63));return result;
end arrayTrim;
procedure fromFile(file f : char_file; variable result : out recinp) is 

begin
fromFile(f,  result.p0);
end fromFile;


procedure toStringList(prefix : string; width : integer; x : recinp; variable res : inout stringPtrListPtr) is 
variable t : stringPtrListPtr;
begin
cons("",  res);
toStringList(prefix & "." & "p0",  width,  x.p0,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p0",  "p0",  width,  true);
res := t ;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recinp) is 
variable scale : std_logic_vector(9 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalerecinp(scale, data);
end shiftRight;


procedure ofScalerecinp(vector : std_logic_vector; result : out recinp) is 

begin
result.p0 := conv_std_logic_vector(vector(9 downto 0));
end ofScalerecinp;


procedure fromFile(file f : char_file; variable result : out recinp2) is 

begin
fromFile(f,  result.p0);
end fromFile;


procedure toStringList(prefix : string; width : integer; x : recinp2; variable res : inout stringPtrListPtr) is 
variable t : stringPtrListPtr;
begin
cons("",  res);
toStringList(prefix & "." & "p0",  width,  x.p0,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p0",  "p0",  width,  true);
res := t ;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recinp2) is 
variable scale : std_logic_vector(15 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalerecinp2(scale, data);
end shiftRight;


procedure ofScalerecinp2(vector : std_logic_vector; result : out recinp2) is 

begin
result.p0 := conv_std_logic_vector(vector(15 downto 0));
end ofScalerecinp2;


procedure fromFile(file f : char_file; variable result : out arrticoefmult1) is 

begin
for i1 in result'range(1) loop
  fromFile(f,  result(i1));
end loop;
end fromFile;


procedure toStringList(prefix : string; width : integer; x : arrticoefmult1; variable l0 : inout stringPtrListPtr) is 
variable l1 : stringPtrListPtr ;
variable s1 : stringPtr ;
variable pref1 : stringPtr ;
begin
cons("",  l0);
for i1 in x'range(1) loop
  s1 := toString(i1) ;
  pref1 := new string'(prefix & "[" & s1.all & "]") ;
  toStringList(pref1.all,  width,  x(i1),  l1);
  printingStep(l1,  l0,  prefix,  pref1.all,  s1.all,  width,  i1=x'high(1));
  l0 := l1 ;
  deallocate(s1);
  deallocate(pref1);
end loop;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrticoefmult1) is 
variable scale : std_logic_vector((data'high - data'low + 1) * 13 - 1 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalearrticoefmult1(scale, data);
end shiftRight;


procedure ofScalearrticoefmult1(vector : std_logic_vector; result : out arrticoefmult1) is 
variable offset : integer := 0;
variable isDown : boolean; 
variable slice : std_logic_vector(13 - 1 downto 0);
begin
isDown := vector'left > vector'right; 
for i1 in result'range(1) loop
  if isDown then
    slice := vector(offset + 13 - 1 downto offset) ;
  else
    slice := vector(offset to offset + 13 - 1) ;
  end if;
  result(i1) := conv_std_logic_vector(slice);
  offset := offset + 13;
end loop;
end ofScalearrticoefmult1;


procedure fromFile(file f : char_file; variable result : out arrtsums1) is 

begin
for i1 in result'range(1) loop
  fromFile(f,  result(i1));
end loop;
end fromFile;


procedure toStringList(prefix : string; width : integer; x : arrtsums1; variable l0 : inout stringPtrListPtr) is 
variable l1 : stringPtrListPtr ;
variable s1 : stringPtr ;
variable pref1 : stringPtr ;
begin
cons("",  l0);
for i1 in x'range(1) loop
  s1 := toString(i1) ;
  pref1 := new string'(prefix & "[" & s1.all & "]") ;
  toStringList(pref1.all,  width,  x(i1),  l1);
  printingStep(l1,  l0,  prefix,  pref1.all,  s1.all,  width,  i1=x'high(1));
  l0 := l1 ;
  deallocate(s1);
  deallocate(pref1);
end loop;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtsums1) is 
variable scale : std_logic_vector((data'high - data'low + 1) * 24 - 1 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalearrtsums1(scale, data);
end shiftRight;


procedure ofScalearrtsums1(vector : std_logic_vector; result : out arrtsums1) is 
variable offset : integer := 0;
variable isDown : boolean; 
variable slice : std_logic_vector(24 - 1 downto 0);
begin
isDown := vector'left > vector'right; 
for i1 in result'range(1) loop
  if isDown then
    slice := vector(offset + 24 - 1 downto offset) ;
  else
    slice := vector(offset to offset + 24 - 1) ;
  end if;
  result(i1) := conv_std_logic_vector(slice);
  offset := offset + 24;
end loop;
end ofScalearrtsums1;


procedure fromFile(file f : char_file; variable result : out arrtsumsqs1) is 

begin
for i1 in result'range(1) loop
  fromFile(f,  result(i1));
end loop;
end fromFile;


procedure toStringList(prefix : string; width : integer; x : arrtsumsqs1; variable l0 : inout stringPtrListPtr) is 
variable l1 : stringPtrListPtr ;
variable s1 : stringPtr ;
variable pref1 : stringPtr ;
begin
cons("",  l0);
for i1 in x'range(1) loop
  s1 := toString(i1) ;
  pref1 := new string'(prefix & "[" & s1.all & "]") ;
  toStringList(pref1.all,  width,  x(i1),  l1);
  printingStep(l1,  l0,  prefix,  pref1.all,  s1.all,  width,  i1=x'high(1));
  l0 := l1 ;
  deallocate(s1);
  deallocate(pref1);
end loop;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtsumsqs1) is 
variable scale : std_logic_vector((data'high - data'low + 1) * 32 - 1 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalearrtsumsqs1(scale, data);
end shiftRight;


procedure ofScalearrtsumsqs1(vector : std_logic_vector; result : out arrtsumsqs1) is 
variable offset : integer := 0;
variable isDown : boolean; 
variable slice : std_logic_vector(32 - 1 downto 0);
begin
isDown := vector'left > vector'right; 
for i1 in result'range(1) loop
  if isDown then
    slice := vector(offset + 32 - 1 downto offset) ;
  else
    slice := vector(offset to offset + 32 - 1) ;
  end if;
  result(i1) := conv_std_logic_vector(slice);
  offset := offset + 32;
end loop;
end ofScalearrtsumsqs1;


procedure fromFile(file f : char_file; variable result : out arrtvarLeft1) is 

begin
for i1 in result'range(1) loop
  fromFile(f,  result(i1));
end loop;
end fromFile;


procedure toStringList(prefix : string; width : integer; x : arrtvarLeft1; variable l0 : inout stringPtrListPtr) is 
variable l1 : stringPtrListPtr ;
variable s1 : stringPtr ;
variable pref1 : stringPtr ;
begin
cons("",  l0);
for i1 in x'range(1) loop
  s1 := toString(i1) ;
  pref1 := new string'(prefix & "[" & s1.all & "]") ;
  toStringList(pref1.all,  width,  x(i1),  l1);
  printingStep(l1,  l0,  prefix,  pref1.all,  s1.all,  width,  i1=x'high(1));
  l0 := l1 ;
  deallocate(s1);
  deallocate(pref1);
end loop;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtvarLeft1) is 
variable scale : std_logic_vector((data'high - data'low + 1) * 64 - 1 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalearrtvarLeft1(scale, data);
end shiftRight;


procedure ofScalearrtvarLeft1(vector : std_logic_vector; result : out arrtvarLeft1) is 
variable offset : integer := 0;
variable isDown : boolean; 
variable slice : std_logic_vector(64 - 1 downto 0);
begin
isDown := vector'left > vector'right; 
for i1 in result'range(1) loop
  if isDown then
    slice := vector(offset + 64 - 1 downto offset) ;
  else
    slice := vector(offset to offset + 64 - 1) ;
  end if;
  result(i1) := conv_std_logic_vector(slice);
  offset := offset + 64;
end loop;
end ofScalearrtvarLeft1;


procedure fromFile(file f : char_file; variable result : out arrtvarLeft11) is 

begin
for i1 in result'range(1) loop
  fromFile(f,  result(i1));
end loop;
end fromFile;


procedure toStringList(prefix : string; width : integer; x : arrtvarLeft11; variable l0 : inout stringPtrListPtr) is 
variable l1 : stringPtrListPtr ;
variable s1 : stringPtr ;
variable pref1 : stringPtr ;
begin
cons("",  l0);
for i1 in x'range(1) loop
  s1 := toString(i1) ;
  pref1 := new string'(prefix & "[" & s1.all & "]") ;
  toStringList(pref1.all,  width,  x(i1),  l1);
  printingStep(l1,  l0,  prefix,  pref1.all,  s1.all,  width,  i1=x'high(1));
  l0 := l1 ;
  deallocate(s1);
  deallocate(pref1);
end loop;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtvarLeft11) is 
variable scale : std_logic_vector((data'high - data'low + 1) * 48 - 1 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalearrtvarLeft11(scale, data);
end shiftRight;


procedure ofScalearrtvarLeft11(vector : std_logic_vector; result : out arrtvarLeft11) is 
variable offset : integer := 0;
variable isDown : boolean; 
variable slice : std_logic_vector(48 - 1 downto 0);
begin
isDown := vector'left > vector'right; 
for i1 in result'range(1) loop
  if isDown then
    slice := vector(offset + 48 - 1 downto offset) ;
  else
    slice := vector(offset to offset + 48 - 1) ;
  end if;
  result(i1) := conv_std_logic_vector(slice);
  offset := offset + 48;
end loop;
end ofScalearrtvarLeft11;


procedure fromFile(file f : char_file; variable result : out arrtvarRight11) is 

begin
for i1 in result'range(1) loop
  fromFile(f,  result(i1));
end loop;
end fromFile;


procedure toStringList(prefix : string; width : integer; x : arrtvarRight11; variable l0 : inout stringPtrListPtr) is 
variable l1 : stringPtrListPtr ;
variable s1 : stringPtr ;
variable pref1 : stringPtr ;
begin
cons("",  l0);
for i1 in x'range(1) loop
  s1 := toString(i1) ;
  pref1 := new string'(prefix & "[" & s1.all & "]") ;
  toStringList(pref1.all,  width,  x(i1),  l1);
  printingStep(l1,  l0,  prefix,  pref1.all,  s1.all,  width,  i1=x'high(1));
  l0 := l1 ;
  deallocate(s1);
  deallocate(pref1);
end loop;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout arrtvarRight11) is 
variable scale : std_logic_vector((data'high - data'low + 1) * 72 - 1 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalearrtvarRight11(scale, data);
end shiftRight;


procedure ofScalearrtvarRight11(vector : std_logic_vector; result : out arrtvarRight11) is 
variable offset : integer := 0;
variable isDown : boolean; 
variable slice : std_logic_vector(72 - 1 downto 0);
begin
isDown := vector'left > vector'right; 
for i1 in result'range(1) loop
  if isDown then
    slice := vector(offset + 72 - 1 downto offset) ;
  else
    slice := vector(offset to offset + 72 - 1) ;
  end if;
  result(i1) := conv_std_logic_vector(slice);
  offset := offset + 72;
end loop;
end ofScalearrtvarRight11;


procedure fromFile(file f : char_file; variable result : out recoutp) is 

begin
fromFile(f,  result.p0);
fromFile(f,  result.p1);
fromFile(f,  result.p2);
fromFile(f,  result.p3);
end fromFile;


procedure toStringList(prefix : string; width : integer; x : recoutp; variable res : inout stringPtrListPtr) is 
variable t : stringPtrListPtr;
begin
cons("",  res);
toStringList(prefix & "." & "p0",  width,  x.p0,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p0",  "p0",  width,  false);
res := t ;
toStringList(prefix & "." & "p1",  width,  x.p1,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p1",  "p1",  width,  false);
res := t ;
toStringList(prefix & "." & "p2",  width,  x.p2,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p2",  "p2",  width,  false);
res := t ;
toStringList(prefix & "." & "p3",  width,  x.p3,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p3",  "p3",  width,  true);
res := t ;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recoutp) is 
variable scale : std_logic_vector(192 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalerecoutp(scale, data);
end shiftRight;


procedure ofScalerecoutp(vector : std_logic_vector; result : out recoutp) is 

begin
result.p0 := conv_std_logic_vector(vector(192 downto 129));
result.p1 := conv_std_logic_vector(vector(128 downto 65));
result.p2 := conv_std_logic_vector(vector(64 downto 1));
result.p3 := conv_std_logic_vector(vector(0 downto 0));
end ofScalerecoutp;


procedure fromFile(file f : char_file; variable result : out recoutpVars) is 

begin
fromFile(f,  result.p0);
fromFile(f,  result.p1);
fromFile(f,  result.p2);
end fromFile;


procedure toStringList(prefix : string; width : integer; x : recoutpVars; variable res : inout stringPtrListPtr) is 
variable t : stringPtrListPtr;
begin
cons("",  res);
toStringList(prefix & "." & "p0",  width,  x.p0,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p0",  "p0",  width,  false);
res := t ;
toStringList(prefix & "." & "p1",  width,  x.p1,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p1",  "p1",  width,  false);
res := t ;
toStringList(prefix & "." & "p2",  width,  x.p2,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p2",  "p2",  width,  true);
res := t ;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recoutpVars) is 
variable scale : std_logic_vector(137 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(scale'high - 2 downto 0) := scale(scale'high - 1 downto 1);
scale(scale'high - 1) := dataIn;
ofScalerecoutpVars(scale, data);
end shiftRight;


procedure ofScalerecoutpVars(vector : std_logic_vector; result : out recoutpVars) is 

begin
result.p0 := conv_std_logic_vector(vector(137 downto 128));
result.p1 := conv_std_logic_vector(vector(127 downto 64));
result.p2 := conv_std_logic_vector(vector(63 downto 0));
end ofScalerecoutpVars;


procedure fromFile(file f : char_file; variable result : out recslave_output_ena) is 

begin
fromFile(f,  result.p0);
end fromFile;


procedure toStringList(prefix : string; width : integer; x : recslave_output_ena; variable res : inout stringPtrListPtr) is 
variable t : stringPtrListPtr;
begin
cons("",  res);
toStringList(prefix & "." & "p0",  width,  x.p0,  t);
printingStep(t,  res,  prefix,  prefix & "." & "p0",  "p0",  width,  true);
res := t ;
end toStringList;


procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout recslave_output_ena) is 
variable scale : std_logic_vector(0 downto 0);
begin
scale := conv_std_logic_vector(data);
dataOut := scale(0);
scale(0) := dataIn;
ofScalerecslave_output_ena(scale, data);
end shiftRight;


procedure ofScalerecslave_output_ena(vector : std_logic_vector; result : out recslave_output_ena) is 

begin
result.p0 := conv_std_logic_vector(vector(0 downto 0));
end ofScalerecslave_output_ena;


end types;
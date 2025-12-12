# datastructs.py:  Generates the include files for the data structures

from xilinxutils.dsgen import DataStructGen, FieldInfo, IntType, EnumType

# Stream bit widths to support
stream_bus_widths = [32, 64]

# Command structure
fields = [
    FieldInfo("trans_id", IntType(16), descr="Transaction ID"),
    FieldInfo("a", IntType(32), descr="Operand A"),
    FieldInfo("b", IntType(32), descr="Operand B")]
cmd_struct = DataStructGen("Cmd", fields)
cmd_struct.stream_bus_widths = stream_bus_widths
cmd_struct.gen_include(include_file="cmd.h")



# Response structure
err_codes = ['NO_ERR', 'SYNC_ERR']
fields = [
    FieldInfo("trans_id", IntType(16), descr="Transaction ID"),
    FieldInfo("c", IntType(32), descr="Operand C"),
    FieldInfo("d", IntType(32), descr="Operand D"),
    FieldInfo("err_code", EnumType("ErrCode", err_codes, 8), descr="Error Code")]
resp_struct = DataStructGen("Resp", fields)
resp_struct.stream_bus_widths = stream_bus_widths
resp_struct.gen_include(include_file="resp.h")
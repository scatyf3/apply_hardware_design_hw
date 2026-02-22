import pandas as pd

def to_unsigned(val, wid=16):
    """Convert signed int to unsigned representation"""
    if val < 0:
        return (1 << wid) + val
    return val

# Generate integer test vectors for both F=8 and F=12
for fbits in [8, 12]:
    wid = 16
    csv_file = f'test_outputs/tv_w{wid}_f{fbits}.csv'
    txt_file = f'test_outputs/tv_w{wid}_f{fbits}_int.txt'
    
    df = pd.read_csv(csv_file)
    
    with open(txt_file, 'w') as f:
        for _, row in df.iterrows():
            # Convert to unsigned for easier reading in SystemVerilog
            xint_u = to_unsigned(int(row["xint"]), wid)
            aint0_u = to_unsigned(int(row["aint0"]), wid)
            aint1_u = to_unsigned(int(row["aint1"]), wid)
            aint2_u = to_unsigned(int(row["aint2"]), wid)
            yint_u = to_unsigned(int(row["yint"]), wid)
            f.write(f'{xint_u} {aint0_u} {aint1_u} {aint2_u} {yint_u}\n')
    
    print(f'Generated {len(df)} test vectors for W={wid}, F={fbits} -> {txt_file}')

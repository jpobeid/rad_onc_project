import os
import numpy as np
import pandas as pd

def is_start_dense(ser_i):
    n_threshold = 0.1
    return (ser_i.argmax() / len(ser_i)) > n_threshold

def write_df_trim(df_filename, max_pdd_points):
    df = pd.read_csv(df_filename)
    df = df.set_index(df.columns[df.columns.str.startswith('Depth')][0], drop=True)

    df_trim = df.applymap(lambda x: np.nan)

    for k in df.columns:
        ser_k_0 = df[str(k)]
        ser_k = ser_k_0.copy()

        if not is_start_dense(ser_k):
            i_max = ser_k.argmax()
            ser_k = ser_k.iloc[i_max:]
        else:
            i_max = 0

        j = 1
        while (i_max + len(ser_k) / j) > max_pdd_points:
            j += 1

        ser_k = ser_k.iloc[0::j]
        ser_k_final = pd.concat([ser_k_0.iloc[0:i_max], ser_k])
        df_trim[k] = ser_k_final

        # Ensure end value isnt NaN (to retain depth-axis relationship)
        if df_trim[k].isna().iloc[-1]:
            df_trim[k].iloc[-1] = ser_k_0.iloc[-1]
    
    df_trim.to_csv(''.join(df_filename.split('_Full')))

if __name__ == '__main__':
    v_csv_full = np.array(os.listdir())[np.array(list(map(lambda x: x.endswith('_Full.csv'), os.listdir())))]

    for e in v_csv_full:
        write_df_trim(e, 50)
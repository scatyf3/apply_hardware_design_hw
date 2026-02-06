
import os
import pandas as pd
import numpy as np
import json
import zipfile
import os
import shutil

"""
Test 1:  Read the python test vector file 
"""
tv_dir = os.path.join(os.getcwd(), 'test_outputs')

def test_python():
    score = 0
    feedback = ""
    try:
        fn = os.path.join(tv_dir, 'tv_python.csv')
        df = pd.read_csv(fn)
    except Exception as e:
        feedback = f"Failed to read test vector file tv_python.csv: {e}"
        return score, feedback

    a = df['a'].to_numpy()
    b = df['b'].to_numpy()
    nbits = df['nbits'].to_numpy()
    z = df['z'].to_numpy()

    # Check that sufficient number of tests
    ntest = len(a)
    if ntest < 100:
        feedback += f"Insufficient number of tests: {ntest} found, at least 100 required.\n"
        return score, feedback

    # Check that z is correct
    qhat = z / (2**nbits)
    zpass = np.abs((a / b) - qhat) < (1 / (2**nbits))
    correct = np.mean( zpass )
    if np.all( zpass ):
        feedback += f"All tests passed the error criterion.\n"
    else:
        feedback += f"Some tests failed the error criterion.\n"

    score = correct 
    return score, feedback
    
"""
Test 2:  Hardware Implementation
"""
def test_hardware():
    score = 0
    feedback = ""
    try:
        fn = os.path.join(tv_dir, 'tv_sv.csv')
        df = pd.read_csv(fn)
    except Exception as e:
        feedback = f"Failed to read test vector file tv_sv.csv: {e}"
        return score, feedback
    
    z = df['z'].to_numpy(dtype=np.uint32)
    z_exp = df['z_exp'].to_numpy(dtype=np.uint32)
    cycles = df['cycles'].to_numpy(dtype=np.int32)
    nbits = df['nbits'].to_numpy(dtype=np.int32)

    # Check expected values are corrected
    zpass = (z == z_exp)
    if np.all( zpass ):
        feedback += f"All tests produced correct quotient values.\n"
    else:
        print(df[['z', 'z_exp']])
        feedback += f"Some tests produced incorrect quotient values.\n"

    # Check that cycles are within expected range
    cycle_pass = (cycles <= nbits + 2)  # Allow some margin
    if np.all( cycle_pass ):
        feedback += f"All tests completed within expected cycle range.\n"
    else:
        feedback += f"Some tests exceeded expected cycle range.\n"
    
    score = (np.mean(zpass) + np.mean(cycle_pass)) / 2
    return score, feedback

tests = []
npoints_python = 10
npoints_hw = 20


# Check if required files exist
zip_files = [ os.path.join(os.getcwd(),'subc_divide.py'),\
              os.path.join(os.getcwd(),'subc_divide.sv'),\
              os.path.join(tv_dir, 'tv_python.csv'),\
              os.path.join(tv_dir, 'tv_sv.csv')]
for f in zip_files:
    if not os.path.isfile(f):
        print(f"Error: Required file {f} not found in current directory.")
        exit(1)


print('Test 1:  Python Implementation')
score, feedback = test_python()
score = int( np.round(score * npoints_python) ) 
print(f"Score: {score}/{npoints_python}")
print(f"Feedback: {feedback}")
r = {'name': 'Python Implementation', 'score': score, 'max_score': npoints_python, 'output': feedback}
tests.append(r)

print('Test 2:  Hardware Implementation')
score, feedback = test_hardware()
score = int( np.round(score * npoints_hw) ) 
print(f"Score: {score}/{npoints_hw}")
print(f"Feedback: {feedback}")
r = {'name': 'Hardware Implementation', 'score': score, 'max_score': npoints_hw, 'output': feedback}
tests.append(r)

# Compute total score
total_score = sum(test['score'] for test in tests)

# Build results in new format
results = {
    'tests': tests,
    'score': total_score
}


# Write results to a JSON file
with open('submitted_results.json', 'w') as f:
    json.dump(results, f, indent=4)

# Create submission directory
submission_dir = 'submission'
if os.path.exists(submission_dir):
    shutil.rmtree(submission_dir)
os.makedirs(submission_dir)

# Copy files to submission directory
shutil.copy('submitted_results.json', os.path.join(submission_dir, 'submitted_results.json'))
for f in zip_files:
    shutil.copy(f, os.path.join(submission_dir, os.path.basename(f)))

# Create submission.zip containing the results and required source files
with zipfile.ZipFile('submission.zip', 'w') as zipf:
    zipf.write('submitted_results.json', arcname='submitted_results.json')
    for f in zip_files:
        zipf.write(f, arcname=os.path.basename(f))

print("Submission package created: submission.zip")
print("Submission directory created: submission/")
print("Upload submission.zip to Gradescope.")

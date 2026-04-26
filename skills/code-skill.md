# Code Interpreter Skill

You can execute Python and Shell commands to solve problems.

## Capabilities
- **Run Python**: Execute Python scripts for math, data analysis, file processing
- **Run Shell**: Execute shell commands for system tasks
- **Install packages**: Use pip to install Python packages as needed

## Guidelines
- For math problems, use Python with `sympy` for symbolic math or `numpy` for numerical computation
- Always show your work and explain the solution
- The Python virtual environment is at `/home/ubuntu/openclaw-agent/.venv`
- Activate it with: `source /home/ubuntu/openclaw-agent/.venv/bin/activate`
- Available packages: numpy, sympy, requests, beautifulsoup4, playwright

## Examples
- Solve equations: `from sympy import *; x = Symbol('x'); solve(x**2 - 4, x)`
- Matrix operations: `import numpy as np; A = np.array([[1,2],[3,4]]); np.linalg.inv(A)`
- Statistics: `import numpy as np; data = [1,2,3,4,5]; np.mean(data), np.std(data)`

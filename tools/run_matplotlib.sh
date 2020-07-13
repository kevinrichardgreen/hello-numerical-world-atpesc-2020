#!/bin/sh

tmpfil=$1/$1_soln_final.curve
lenx=$(tail -1 $1/$1_soln_final.curve | tr -s ' ' | cut -d' ' -f2)

# Compute midpoint of wall
lenx2=$(
dc << EOF
4
k
$lenx
2.0
/
p
EOF
)

# Compute left end of pipe
p0=$(
dc << EOF
4
k
$lenx2
0.05
-
p
EOF
)

# Compute right end of pipe
p1=$(
dc << EOF
4
k
$lenx2
0.05
+
p
EOF
)

python -t << EOF 2>/dev/null
import matplotlib.pyplot as plt
import sys, time
x = []
y = []
with open("$1/$1_soln_final.curve") as f:
    for line in f.readlines():
        words = line.split()
        if '#' in words[0:2]:
            continue
        x.append(words[0])
        y.append(words[1])
plt.xlabel('Distance (meters)')
plt.ylabel('Temperature (Kelvin)')
plt.plot(x,y)
plt.plot([$p0,$p1],[273,273],"k",linewidth=4)
plt.show()
sys.exit(0)
EOF
exit 0

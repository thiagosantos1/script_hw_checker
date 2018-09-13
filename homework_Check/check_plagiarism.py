#!/usr/bin/env python3
#chmod u+x

import os
import sys
import hashlib

if __name__ == "__main__":

    if len(sys.argv) != 2:
        sys.stderr.write("Usage: {} <folder>\n".format(sys.argv[0]))
        sys.exit(69)

    
    files = []
    for dirpath, dirnames, filenames in os.walk(sys.argv[1]):
        for f in filenames:
            if f.endswith(".c"):
                files.append(os.path.join(dirpath, f))

    hashes = {}
    collisions = []
    for f in files:
        with open(f, "r") as fd:
            content = "".join(fd.read().split()).encode()
            md5 = hashlib.md5(content).hexdigest()
            if md5 not in hashes:
                hashes[md5] = [f]
            else:
                hashes[md5].append(f)
                collisions.append(md5)

    if len(collisions) == 0:
        print("All clean.")
    else:
        print("Collisions:")
        for c in collisions:
            print(hashes[c]) 
            

            


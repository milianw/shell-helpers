#!/usr/bin/env python
#
# licensed under the http://creativecommons.org/licenses/by-sa/2.5/
#
# created by: http://stackoverflow.com/questions/28101243/how-to-find-global-static-initializations/28146199?noredirect=1#28146199
#

import os
import sys

# Load .init_array section
objdump_output = os.popen("objdump -s '%s' -j .init_array" % (sys.argv[1].replace("'", r"\'"),)).read()
is_64bit = "x86-64" in objdump_output
init_array = objdump_output[objdump_output.find("Contents of section .init_array:") + 33:]
initializers = []
for line in init_array.split("\n"):
    parts = line.split()
    if not parts:
        continue
    parts.pop(0)  # Remove offset
    parts.pop(-1) # Remove ascii representation

    if is_64bit:
        # 64bit pointers are 8 bytes long
        parts = [ "".join(parts[i:i+2]) for i in range(0, len(parts), 2) ]

    # Fix endianess
    parts = [ "".join(reversed([ x[i:i+2] for i in range(0, len(x), 2) ])) for x in parts ]

    initializers += parts

# Load disassembly for c++ constructors
dis_output = os.popen("objdump -Cd '%s'" % (sys.argv[1].replace("'", r"\'"), )).read()
def find_associated_constructor(disassembly, symbol):
    # Find associated __static_initialization function
    loc = disassembly.find("<%s>" % symbol)
    if loc < 0:
        return False
    loc = disassembly.find(" <", loc)
    if loc < 0:
        return False
    symbol = disassembly[loc+2:disassembly.find("\n", loc)][:-1]
    if not symbol.startswith("__static_initialization") and not symbol.startswith("__cxx_global_var_init"):
        return False
    address = disassembly[disassembly.rfind(" ", 0, loc)+1:loc]
    loc = disassembly.find("%s <%s>" % (address, symbol))
    if loc < 0:
        return False
    # Find all callq's in that function
    end_of_function = disassembly.find("\n\n", loc)
    symbols = []
    while loc < end_of_function:
        loc = disassembly.find("callq", loc)
        if loc < 0 or loc > end_of_function:
            break
        loc = disassembly.find("<", loc)
        symbol = disassembly[loc+1:disassembly.find("\n", loc)][:-1]
        if "__cxa_atexit" in symbol or "::~" in symbol:
            continue
        symbols.append(symbol)
    return symbols

# Load symbol names, if available
nm_output = os.popen("nm '%s'" % (sys.argv[1].replace("'", r"\'"), )).read()
nm_symbols = {}
for line in nm_output.split("\n"):
    parts = line.split()
    if not parts:
        continue
    nm_symbols[parts[0]] = parts[-1]

# Output a list of initializers
print("Initializers:")
for initializer in initializers:
    symbol = nm_symbols[initializer] if initializer in nm_symbols else "???"
    constructor = find_associated_constructor(dis_output, symbol)
    if constructor:
        for function in constructor:
            print("%s %s -> %s" % (initializer, symbol, function))
    else:
        print("%s %s" % (initializer, symbol))

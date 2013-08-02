#!/usr/bin/env python

import argparse
import base64
import os
import sys

# bytearray



    
def arguments():
    parser = argparse.ArgumentParser(description="Create or use a one time pad.")
    parser.add_argument("--input", type=str, nargs='?', metavar="input_file.txt", dest="IN", help="The input file.  If a key is specifed, this is assumed to be base64 encoded.  If this argument is not specified, stdin is assumed.")
    parser.add_argument("--key", type=str, required=True, metavar="key_file.otp", help="The key file.  If this file does not exist, it is created and encryption occurs.")
    parser.add_argument("--output", type=str, nargs='?', metavar="output_file.txt", dest="OUT", help="The output file.  Output is base64 encoded.  If this is not specified, stdout is assumed.")
    

    args = parser.parse_args()
    return args


def encrypt(IN, key, OUT):
    instr = read_input(IN)
    
    inbytes = bytearray(instr)
    
    keybytes = bytearray(os.urandom(len(inbytes)))

    outbytes = xor(inbytes, keybytes)
    
    outstr = base64.b64encode(outbytes)
    
    write_output(OUT, outstr)
    write_output(key, keybytes, mode='wb')
            

def decrypt(IN, key, OUT):
    instr = read_input(IN)

    instr = base64.b64decode(instr)
    inbytes = bytearray(instr)
    
    keybytes = read_key(key)

    outbytes = xor(inbytes, keybytes)
    outstr = str(outbytes)
    
    write_output(OUT, outstr)


def xor(inbytes, keybytes):
    assert(len(inbytes) == len(keybytes))

    outbytes = bytearray(len(inbytes))
    
    for i in range(len(inbytes)):
        outbytes[i] = inbytes[i] ^ keybytes[i]
        
    return outbytes



def read_key(key):
    try:
        keystr = open(key).read()
    except:
        sys.stderr.write("Error reading keyfile: " + key)
        sys.exit(2)
        
    return bytearray(keystr)


def read_input(IN):
    if IN is None:
        instr = sys.stdin.read()
    else:
        try:
            instr = open(IN).read()
        except:
            sys.stderr.write("Error: input file " + IN + " not a valid file.")
            sys.exit(1)
            
    return instr


def write_output(OUT, outstr, mode="w"):
    if OUT is None:
        print outstr
    else:
        try:
            f = open(OUT, mode)
            f.write(outstr)
            f.close()
        except:
            sys.stderr.write("Error writing file: " + OUT)
            sys.exit(3)
    


def main():
    args = arguments()
    
    if os.path.exists(args.key):
        decrypt(IN = args.IN, key = args.key, OUT = args.OUT)
    else:
        encrypt(IN = args.IN, key = args.key, OUT = args.OUT)


if __name__ == "__main__":
    main()

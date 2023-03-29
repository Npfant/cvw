#!/usr/bin/env python3

# Authors: Limnanthes Serafini (lserafini@hmc.edu) and Alec Vercruysse (avercruysse@hmc.edu)
# TODO: add better (more formal?) attribution, commenting, improve output
# maybe TODO: edit __repr__ of the classes?
# it would also be nice if we could log evictions in Wally's caches

import sys
import math
import argparse
import os

class CacheLine:
    def __init__(self):
        self.tag = 0
        self.valid = False
        self.dirty = False
    
    def __str__(self):
        string = "(V: " + str(self.valid) + ", D: " + str(self.dirty)
        string +=  ", Tag: " + str(hex(self.tag)) + ")"
        return string
    
    def __repr__(self):
        return self.__str__()
    


class Cache:
    def __init__(self, numsets, numways, addrlen, taglen):
        self.numways = numways
        self.numsets = numsets

        self.addrlen = addrlen
        self.taglen = taglen
        self.setlen = int(math.log(numsets, 2))
        self.offsetlen = self.addrlen - self.taglen - self.setlen

        self.ways = []
        for i in range(numways):
            self.ways.append([])
            for j in range(numsets):
                self.ways[i].append(CacheLine())
        
        self.pLRU = []
        for i in range(numsets):
            self.pLRU.append([0]*(self.numways-1))
    
    def flush(self):
        for way in self.ways:
            for line in way:
                line.dirty = False
    
    def invalidate(self):
        for way in self.ways:
            for line in way:
                line.valid = False
    
    def splitaddr(self, addr):
        # no need for offset in the sim
        setnum = (addr >> self.offsetlen) - ((addr >> (self.setlen + self.offsetlen)) << self.setlen)
        tag = addr >> (self.setlen + self.offsetlen)
        return tag, setnum
    
    def cacheaccess(self, addr, write=False):
        tag, setnum = self.splitaddr(addr)

        # check our ways to see if we have a hit
        for waynum in range(self.numways):
            line = self.ways[waynum][setnum]
            if line.tag == tag and line.valid:
                if write:
                    line.dirty = True
                self.update_pLRU(waynum, setnum)
                return 'H'

        # we didn't hit, but we may not need to evict.
        # check for an empty way line.
        for waynum in range(self.numways):
            line = self.ways[waynum][setnum]
            if not line.valid:
                line.tag = tag
                line.valid = True
                if write:
                    line.dirty = True
                else:
                    line.dirty = False
                self.update_pLRU(waynum, setnum)
                return 'M'
        
        # we need to evict. Select a victim and overwrite.
        victim = self.getvictimway(setnum)
        line = self.ways[victim][setnum]
        #print("Evicting tag", line.tag, "from set", setnum, "way", victim)
        #print("replacing with", tag)
        line.tag = tag
        line.valid = True   # technically redundant
        if write:
            line.dirty = True
        else:
            line.dirty = False
        self.update_pLRU(waynum, setnum)
        return 'M' # update this to 'E' if we get evictions loggable

    def update_pLRU(self, waynum, setnum):
        if self.numways == 1:
            return
        
        tree = self.pLRU[setnum]
        bottomrow = (self.numways - 1)//2
        index = (waynum // 2) + bottomrow
        tree[index] = int(not (waynum % 2))
        #print("changing index", index, "to", int(not (waynum % 2)))
        while index > 0:
            parent = (index-1) // 2
            tree[parent] = index % 2
            #print("changing index", parent, "to", index%2)
            index = parent

    def getvictimway(self, setnum):
        if self.numways == 1:
            return 0
        
        tree = self.pLRU[setnum]
        index = 0
        bottomrow = (self.numways - 1) // 2 #first index on the bottom row of the tree
        while index < bottomrow:
            if tree[index] == 0:
                index = index*2 + 1
            else:
                index = index*2 + 2
        
        victim = (index - bottomrow)*2
        if tree[index] == 1:
            victim += 1
        
        return victim
    
    def __str__(self):
        string = ""
        for i in range(self.numways):
            string += "Way " + str(i) + ": "
            for line in self.ways[i]:
                string += str(line) + ", "
            string += "\n\n"
        return string

    def __repr__(self):
        return self.__str__()
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Simulates a L1 cache.")
    parser.add_argument('numlines', type=int, help="The number of lines per way (a power of 2)", metavar="L")
    parser.add_argument('numways', type=int, help="The number of ways (a power of 2)", metavar='W')
    parser.add_argument('addrlen', type=int, help="Length of the address in bits (a power of 2)", metavar="A")
    parser.add_argument('taglen', type=int, help="Length of the tag in bits", metavar="T")
    parser.add_argument('-f', "--file", required=True, help="Log file to simulate from")

    args = parser.parse_args()
    cache = Cache(args.numlines, args.numways, args.addrlen, args.taglen)
    
    # go looking in the sim directory for the file if it doesn't exist
    if not os.path.isfile(args.file):
        args.file = os.path.expanduser("~/cvw/sim/" + args.file)
    
    with open(args.file, "r") as f:
        for ln in f:
            ln = ln.strip()
            lninfo = ln.split()
            if len(lninfo) < 3: #non-address line
                if lninfo[0] == 'END':
                    cache.invalidate() # a new test is starting, so 'empty' the cache
            else:
                if lninfo[1] == 'F':
                    cache.flush()
                else:
                    addr = int(lninfo[0], 16)
                    result = cache.cacheaccess(addr, lninfo[1] == 'W') # add support for A
                    #tag, setnum = cache.splitaddr(addr)
                    #print(tag, setnum, lninfo[2], result)
                    if not result == lninfo[2]:
                        print("Result mismatch at address", lninfo[0], ". Wally:", lninfo[2],", Sim:", result)
                    #print()
                        
                        

    


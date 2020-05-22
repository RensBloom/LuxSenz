/* This mem2file.c program is a modified version of devmem2 by Jan-Derk Bakker
 * as referenced below. This program was modified by Derek Molloy for the book
 * Exploring BeagleBone. It is used in Chapter 13 to dump the DDR External Memory
 * pool to a file. See: www.exploringbeaglebone.com/chapter13/
 *
 * devmem2.c: Simple program to read/write from/to any location in memory.
 *
 *  Copyright (C) 2000, Jan-Derk Bakker (J.D.Bakker@its.tudelft.nl)
 *
 *
 * This software has been developed for the LART computing board
 * (http://www.lart.tudelft.nl/). The development has been sponsored by
 * the Mobile MultiMedia Communications (http://www.mmc.tudelft.nl/)
 * and Ubiquitous Communications (http://www.ubicom.tudelft.nl/)
 * projects.
 *
 * The author can be reached at:
 *
 *  Jan-Derk Bakker
 *  Information and Communication Theory Group
 *  Faculty of Information Technology and Systems
 *  Delft University of Technology
 *  P.O. Box 5031
 *  2600 GA Delft
 *  The Netherlands
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <fcntl.h>
#include <ctype.h>
#include <termios.h>
#include <sys/types.h>
#include <sys/mman.h>

#define MAP_SIZE 0x0FFFFFFF
#define MAP_MASK (MAP_SIZE - 1)
#define MMAP_LOC   "/sys/class/uio/uio0/maps/map1/"

unsigned int readFileValue(char filename[]){
   FILE* fp;
   unsigned int value = 0;
   fp = fopen(filename, "rt");
   fscanf(fp, "%x", &value);
   fclose(fp);
   return value;
}

int main(int argc, char **argv) {
    int fd;
    void *map_base, *virt_addr, *pointer_addr;
    unsigned long read_result, writeval, target_written;
    unsigned int addr = readFileValue(MMAP_LOC "addr");
    unsigned int dataSize = readFileValue(MMAP_LOC "size");
    unsigned int numberOutputSamples = dataSize / 2;
    off_t target = addr;

	int s_max = 512;
	int s_min = 256;
	int symbol = 0;
	int prev_symbol = 0;
	int last_symbol = 0;
	int count = 0;
	int change_count = 0;
	int delta_min = -1;
	int delta_max = -1;
	int delta;
	int threshold = 0;
	int bc_pos = 0;
	int bc_timings[2][512]; //maximum 1024 transitions in the barcode
	int bc_index = 0;

    if(argc>1){     // There is an argument -- lists number of samples to dump
                    // this defaults to the total DDR Memory Pool x 2 (16-bit samples) 
	numberOutputSamples = atoi(argv[1]);
    }

    if((fd = open("/dev/mem", O_RDWR | O_SYNC)) == -1){
	printf("Failed to open memory!");
	return -1;
    }
    fflush(stdout);

    map_base = mmap(0, MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, target & ~MAP_MASK);
    if(map_base == (void *) -1) {
       printf("Failed to map base address");
       return -1;
    }
    fflush(stdout);
	printf("\e[1;1H\e[2J");
	printf("\033[2;4HCurrent light intensity:");
	printf("Size: %d = 0x%X", dataSize, dataSize);
	while (1) {
		int i=2;
		int j =0;
		target = addr + 4;
		pointer_addr = map_base + (addr & MAP_MASK);
		while (i < numberOutputSamples) {
			target_written = *((uint32_t *) pointer_addr);
			while (target_written != target) {
				if (i == numberOutputSamples) {
					printf("Reset!");
					break;
				}
				virt_addr = map_base + (target & MAP_MASK);
				read_result = *((uint16_t *) virt_addr);
				//printf("%d\n", read_result);
				target+=2;                   // 2 bytes per sample
				i++;
				count++;
				if (read_result > s_max) {
					s_max = (read_result + s_max * 3 + 2)/4; 
				} else if (read_result < s_min) {
					s_min = (read_result + s_min * 3) /4;
				}
				if ((count % 250) == 0 && s_max - s_min > 4) {
					s_max--;
					s_min++;
				}
				threshold = (s_min + s_max) / 2;
				symbol =(int) (read_result > threshold);
				if (target_written == target) {
					printf("\033[%d;%dH0x%X: %d  \n", 3, 4, target, read_result);
					printf("\033[%d;%dH%d ", read_result/32, (read_result % 32)*4+1, read_result);
					printf("\033[7;5H%03d -%03d- %03d   %04d -%04d- %04d    ", s_min, threshold, s_max, delta_min, delta, delta_max);
				}
				if (symbol == prev_symbol && symbol != last_symbol) {
					delta = count - change_count;
					change_count = count;
					last_symbol = symbol;
					if (bc_index > 0 || symbol == 0) {
						bc_timings[symbol][bc_index++/2] = delta;
						if (delta > 1000) {
							for (j = 0; j < bc_index/2; j++) {
								printf("\033[11;%dH%d      ", j*4+1, bc_timings[0][j]);
								printf("\033[12;%dH%d      ", j*4+1, bc_timings[1][j]);
							}
							bc_index = 0;
						}
					}
					if (delta > 10000) {
						//reset
						bc_pos = 0;
						delta_min = -1;
						delta_max = -1;
						//break;
					}
					if (bc_pos > 0 || symbol == 0) {
						printf("\033[%d;%dH%d                  ", 8+symbol, bc_pos*5/2+1, delta);
						if (delta_max == -1) {
							delta_max = delta;
							printf("\033[5;%dH%d     ", bc_pos++, last_symbol);
						} else if (delta > delta_max / 2 + delta_max * 2) {
							bc_pos = 0; //reset
							delta_min = -1;
							delta_max = -1;
						} else if (delta > delta_max) {
							delta_max = delta;
							printf("\033[5;%dH%d     ", bc_pos++, last_symbol);
						} else if (delta < delta_min) {
							delta_min = delta;
						} else if (delta_min == -1) {
							if (delta > delta_max * 2 / 3) {
								printf("\033[5;%dH%d     ", bc_pos++, last_symbol);
							} else {
								delta_min = delta;
							}
						} else if (delta > (delta_min + delta_max)/2) {
							printf("\033[5;%dH%d     ", bc_pos++, last_symbol);
						}
					}
					printf("\033[5;%dH%d   ", bc_pos++, last_symbol);
				}
				prev_symbol = symbol;
			}
		}
		fflush(stdout);
	}
    if(munmap(map_base, MAP_SIZE) == -1) {
       printf("Failed to unmap memory");
       return -1;
    }
    close(fd);
    return 0;
}

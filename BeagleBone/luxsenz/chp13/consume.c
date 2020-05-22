/* This mem2file.c program is a modified version of devmem2 by Jan-Derk Bakker
 * as referenced below. This program was modified by Derek Molloy for the book
 * Exploring BeagleBone. It is used in Chapter 13 to dump the DDR External Memory
 * pool to a file. See: www.exploringbeaglebone.com/chapter13/
 *
 *
 * Copyright (C) 2000, Jan-Derk Bakker (J.D.Bakker@its.tudelft.nl)
 * Copyright (C) 2017	Rens Bloom
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
	unsigned long sample, writeval, target_written;
	unsigned int addr = readFileValue(MMAP_LOC "addr");
	unsigned int dataSize = readFileValue(MMAP_LOC "size");
	unsigned int numberOutputSamples = dataSize / 2;
	off_t target = addr;

	int s_max = 512;
	int s_min = 256;
	int symbol = 0;
	int prev_symbol = 0;
	int count = 0;
	int change_count = 0;
	int delta_min = -1;
	int delta_max = -1;
	int delta;
	int threshold_white = 0;
	int threshold_black = 0;
	int quiet_threshold = 10000;
	int bc_pos = 0;
	int bc_timings[2][1024]; //maximum 1024 transitions in the barcode
	int bc_index = 0;
	int detected_count = 0;
	int start_decoding = 0;

	if(argc>1){	 // There is an argument -- lists number of samples to dump
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
	printf("\033[2;40HSize: %d = 0x%X", dataSize, dataSize);
	while (1) {
		int i=2;
		int j =0;
		target = addr + 4;
		pointer_addr = map_base + (addr & MAP_MASK);
		while (i < numberOutputSamples) {
			target_written = *((uint32_t *) pointer_addr);
			while (target_written != target) {
				if (i == numberOutputSamples) {
					printf("Reset!\r");
					break;
				}
				i++;
				virt_addr = map_base + (target & MAP_MASK);
				sample = *((uint16_t *) virt_addr);			
				target+=2; // 2 bytes per sample
				start_decoding = 0;
				count++;
				
				/* Dynamic threshold determination
				 * 
				 * The algorithm keeps track of expected signal boundaries (s_min, s_max).
				 * If the signal is outside the range (s_min, s_max), a boundary is updated.
				 * As long as the signal is within the range, the values of s_min and s_max
				 * are converging with 16% both every 250 samples.
				 * A minimum range of 4 is maintained to be able to handle some quantization noise
				 * For low-frequency signals, The converging boundaries result into too fast
				 * updates of the expected signal boundaries. Then, transitions are always detected
				 * earlier than the midpoint of the transition.
				*/
				if ((count % 250) == 0) {
					delta = (s_max - s_min)/6; //delta is always rounded down; mainting range of at least 4
					s_max -= delta;
					s_min += delta;
				}
				if (sample >= s_max) {
					s_max = sample;
				} else if (sample <= s_min) {
					s_min = sample;
				}
				/* The threshold is determined by the average value of (s_min, s_max).
				 * Only if the sampled value differs at least 2 with the threshold value,
				 * the symbol value is updated. The minimum required amplitude of the
				 * signal is thus 4. This is implemented by actually having two thresholds.
				 * Sampled values are always integers, thus rounding is involved in 
				 * computing the thresholds.
				*/
				//threshold_black = (s_min + s_max) / 2 - 6;
				//threshold_white = (s_min + s_max +1) / 2 + 6;
				threshold_black = (s_min + s_max) / 2 - 12;
				threshold_white = (s_min + s_max) / 2 + 12;
				if (sample >= threshold_white)
					symbol = 1;
				else if (sample <= threshold_black)
					symbol = 0;
				
				/* Update screen with the most recent value when we have processed al stored values.
				*/
				if (target_written == target) {
					printf("\033[%d;%dH0x%X: %d  \n", 3, 4, target, sample);
//					printf("\033[%d;%dH%d", sample/64+1, (sample % 64)*3+1, sample % 1000);
					printf("\033[7;5H%03d -%03d- %03d   %04d -%04d- %04d    ", s_min, threshold_black, s_max, delta_min, delta, delta_max);
				}
				
				/* If the symbol has changed, there is a transition detected
				 * We will save the transition
				*/
				if (symbol != prev_symbol) {
					delta = count - change_count; //time duration of the previous detected stripe
					change_count = count; //save current time as transition time
					
					/*Save the previous stripe in the array bc_timings.
					 * Convention: a barcode always starts with a black stripe.
					 * The actual width of the first black stripe doesn't matter
					 * as it is defined to have the same width as the last black stripe
					 * Quiet zone:       bc_timings[1][0]
					 * 1st black stripe: bc_timings[0][0]
					 *
					 * 1st white stripe: bc_timings[1][1] 
					 * 2nd black stripe: bc_timings[0][1]
					 * etc...
					 * last (n)   white stripe: bc_timings[1][n]
					 * last (n+1) black stripe: bc_timings[0][n]
					*/
					bc_timings[prev_symbol][bc_index] = delta;
					if (!prev_symbol)
						bc_index++;	
					if (bc_index > 1023)
						bc_index = 0;
					prev_symbol = symbol;
				}
				
				//Check if a barcode is fully scanned, then finish decoding
				if (count - change_count > quiet_threshold) {
					start_decoding = 1;
				}
				
				
				/*Process the saved barcode edges if there are enough currently stored
				*/
				if (1 == 0 && (start_decoding || target_written == target) && bc_index > 3) {
					/* Let's decode the barcode!
					 * The barcde is always preceded by the quiet zone.
					 * The first saved black stripe can be something before the quiet zone,
					 * or the actual first stripe. In both cases we can't add value to the
					 * width of the first black stripe.
					*/
					
					//compute total barcode length.
					//bc_timings[0][0] contains timing information before the barcode actually started
					/*int total_duration = bc_timings[1][0];
					for (j = 1; j < bc_index; j++) {
						total_duration += bc_timings[0][j] + bc_timings[1][j];
					}
					
					//filtering of too fast transitions that we should consider as noise
					int min_length = total_duration / bc_index / 5;
					int have_filtered = 1;
					while (have_filtered) {
						have_filtered = 0;
						for (j = 0; j < bc_index; j++) {
							if (bc_timings[0][j] < min_length && j > 0 && bc_timings[0][j] > 0) {
								bc_timings[1][j-1] += bc_timings[0][j] + bc_timings[1][j];
								bc_timings[0][j] = 0;
								bc_timings[1][j] = 0;
								have_filtered = 1;
							} else if (bc_timings[1][j] < min_length && bc_timings[1][j] > 0) {
								bc_timings[0][j] += bc_timings[1][j] + bc_timings[0][j+1];
								bc_timings[1][j] = 0;
								bc_timings[0][j+1] = 0;
								have_filtered = 1;
							}
						}
					}*/
					
					/* Decoding is done by determining what parts are wide and what parts are narrow.
					 * Ink spread and saturation can cause black or white parts to be more present in
					 * our measurements (up to 50% change). Therefore, the decoding algorithm is done
					 * seperately for the white and the black parts of the barcode.
					*/
					
					//first, determine the minimum occuring widths in the barcode
					//Don't use the first and last stripe to do this.
					int minimum_white = 999999;
					int minimum_black = 999999;
					for (j = 1; j < bc_index-1; j++) {
						if (bc_timings[0][j] < minimum_black && bc_timings[0][j] > 0)
							minimum_black = bc_timings[0][j];
					}
					for (j = 1; j < bc_index-1; j++) {
						if (bc_timings[1][j] < minimum_white && bc_timings[1][j] > 0)
							minimum_white = bc_timings[1][j];
					}

					//Show the measured widths of the stripes Black stripes
/*					printf("\033[12;0H\033[2K\rBlack:  "); //clear line 12 and set cursor position
					for (j = 0; j < bc_index; j++) {
						printf("%04d ", bc_timings[0][j]);
					}
					printf("\033[11;0H\033[2K\rWhite:"); //clear line 11 and set cursor position
					for (j = 0; j < bc_index; j++) {
						printf("%04d ", bc_timings[1][j]);
					}*/
					//determine a simple threshold width to distinguish between narrow and wide
					threshold_white = minimum_white * 3 / 2;
					threshold_black = minimum_black * 3 / 2;
					
					//Determine the average widths of the stripes we now would classify as narrow.
					//
					int tt_white = 0;
					int tt_white_count = 0;
					int tt_black = 0;
					int tt_black_count = 0;
					for (j = 2; j < bc_index; j++) {
						if (bc_timings[0][j] > 0 && bc_timings[0][j] < threshold_black) {
							tt_black += bc_timings[0][j];
							tt_black_count++;
						}
					}
					for (j = 2; j < bc_index; j++) {
						if (bc_timings[1][j] > 0 && bc_timings[1][j] < threshold_white) {
							tt_white += bc_timings[1][j];
							tt_white_count++;
						}
					}
					
					//Check if it is a valid (part of a) barcode
					if (tt_white_count > 0 && tt_black_count > 0) {
					
						//re-evaluate the threshold based on the average width of narrow stripes
						int threshold_delta = (tt_white + tt_black) * 3 / (7 * (tt_white_count + tt_black_count)); //0.4 times the average width
						//threshold_white = tt_white * 10 / (tt_white_count * 7); //1.42 times the average narrow width = inaccurate
						//threshold_black = tt_black * 10 / (tt_black_count * 7); //1.42 times the average narrow width = inaccurate
						threshold_black = tt_black / tt_black_count + threshold_delta;
						threshold_white = tt_white / tt_white_count + threshold_delta;
						quiet_threshold = threshold_delta*8; //3.2 times the average width
						
						//Print determined thresholds
						printf("\033[14;0H\033[2K\r"); //clear line 14 and set cursor position
						printf("white: %d black: %d ; ", threshold_white, threshold_black);
						
						//print recognized barcode pattern
						for (j = 0; ; j++) {
							if (bc_timings[1][j] > 0) {
								printf("1");
								if (bc_timings[1][j] > threshold_white) {
									printf("1");
								}
							}
							if (bc_timings[0][j] > 0) {
								printf("0");
								if (bc_timings[0][j] > threshold_black) {
									printf("0");
								}
								if (j == bc_index -1) { //last stripe of the barcode
								
									break;
								}
							}

						}
						printf(" (%d)", detected_count++);
					}
					
					/*if (bc_pos > 0 || symbol == 0) {
						printf("\033[%d;%dH%d                    ", 8+symbol, bc_pos*5/2+1, delta);
						if (delta_max == -1) {
							delta_max = delta;
							printf("\033[5;%dH%d             ", bc_pos++, prev_symbol);
						} else if (delta > delta_max / 2 + delta_max * 2) {
							bc_pos = 0; //reset
							delta_min = -1;
							delta_max = -1;
						} else if (delta > delta_max) {
							delta_max = delta;
							printf("\033[5;%dH%d             ", bc_pos++, prev_symbol);
						} else if (delta < delta_min) {
							delta_min = delta;
						} else if (delta_min == -1) {
							if (delta > delta_max * 2 / 3) {
								printf("\033[5;%dH%d             ", bc_pos++, prev_symbol);
							} else {
								delta_min = delta;
							}
						} else if (delta > (delta_min + delta_max)/2) {
							printf("\033[5;%dH%d             ", bc_pos++, prev_symbol);
						}
					}*/
					printf("\033[5;%dH%d            ", bc_pos++, prev_symbol);
				}
				//Reset after decoding
				if (start_decoding) {
					bc_index = 0;
					bc_timings[1][0] = 0;
					bc_timings[0][0] = 0;
					start_decoding = 0;
					quiet_threshold = 10000;
				}
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

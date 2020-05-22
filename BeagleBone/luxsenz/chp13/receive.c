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
	
	int f_sample = 50000;                  // original sample frequency
	
	//Downsampling of the signal
	unsigned int ds_factor = 70;           //from 50 ksps to 714 sps. Downsampling performed by summing up samples (increases scale)
	unsigned int ds_division = 32;         //divide the summed samples by 32
	unsigned int oi = 0;                   //index variable for downsampling
	
	//FIR filter, to remove noise
	unsigned int fir_length = 21;                                   //length of the FIR filter
	//unsigned int fir_array[9] = {100,0,0,0,0,0,0,0,0};            //the FIR filter itself, this one does nothing
	//unsigned int fir_array[9] = {1, 4, 12, 21, 26, 21, 12, 4, 1}; //Low-pass FIR, cut-off frequency +/- 715 Hz (at sample rate of 5ksps)
	unsigned int fir_array[21] = {2,3,5,8,13,19,25,30,35,38,39,38,35,30,25,19,13,8,5,3,2}; //Low-pass FIR, cut off frequency +/- 36 Hz (sample rate 714sps)
	//unsigned int fir_division = 102;                             //sum of all coefficients of the FIR filter
	unsigned int fir_division = 395;                               //sum of all coefficients of the FIR filter
	unsigned int fir_buffer[22] = {0,0,0,0,0,0,0,0,0,0};           //a buffer that must be 1 longer than the fir array
	
	unsigned long signal = 1024;           // will contain the signal value after filtering
	
	
	//upper and lower bound of the signal (slowly converging)
	int s_max = 2048*ds_factor/ds_division;
	int s_min = 2048*ds_factor/ds_division;
	int minmax_count = 0;
	
	//Last minimum and maximum values
	int l_min =        2048*ds_factor/ds_division;
	int l_max =        2048*ds_factor/ds_division;
	int edge_threshold = 10;
	
	//Minimum and maximum timings
	int t_hi_min = 500;
	int t_hi_max = 1000;
	int t_hi_threshold = 750;
	int t_lo_min = 500;
	int t_lo_max = 1000;
	int t_lo_threshold = 750;
	
	int t_hi_min_display = 500;
	int t_hi_max_display = 1000;
	int t_lo_min_display = 500;
	int t_lo_max_display = 1000;
	int t_display_count = 0;
	
	int t_hi_n_min = 0;
	int t_hi_n_max = 0;
	int t_hi_w_min = 0;
	int t_hi_w_max = 0;
	int t_lo_n_min = 0;
	int t_lo_n_max = 0;
	int t_lo_w_min = 0;
	int t_lo_w_max = 0;
	int transition_count = 0;
	
	//Raw signal sequences
	int hilo_buf[640];
	int hilo_buf_i = 0;
	int hilo_buf_man_i = 0;
	
	//Manchester decoded data
	int man_buf[640];
	int man_buf_i = 0;
	int man_buf_ascii_i = 0;
	
	//ASCII encoded data to display
	char ascii_buf[256];
	int ascii_buf_i = 0;
	
	int status = 0;
	/* Status variable:
	 * -1 = Please reset everything
	 * 0 = No valid Manchester signal
	 * 1 = Valid Manchester signal found, trying to synchronize
	 * 2 = Valid synchronization performed, locking to this frequency
	 * 3 = Valid synchronization performed, waiting for start of text
	 * 4 = Receiving a text block (until ETX)
	*/
	
	int symbol = 0;
	int prev_symbol = 0;
	int count = 0;
	int change_count = 0;
	int delta;
	
	int dc = 0;

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
	
	//Print stuff on the screen, such that we have some information about the signal visible
	fflush(stdout);
	printf("\e[1;1H\e[2J");
	printf("\033[2;40HSampling buffer size: %d = 0x%X", dataSize, dataSize);
	printf("\033[2;4HData pointer:");
	printf("\033[3;4HRaw value:");
	printf("\033[4;4HFiltered signal:");
	printf("\033[5;4HLowest signal:");
	printf("\033[6;4HHighest signal:");
	printf("\033[7;4HAmplitude:");
	printf("\033[5;32HCurrent low:");
	printf("\033[6;32HCurrent high:");
	printf("\033[7;32HEdge threshold:");
	printf("\033[8;32HCurrent symbol:");
	printf("\033[9;4HLongest delta:");
	printf("\033[10;4HShortest delta:");
	printf("\033[11;4HDelta threshold:");
	printf("\033[10;42HMin Frequency:");
	printf("\033[11;42HMax Frequency:");
	printf("\033[13;4HTime locks hi:");
	printf("\033[14;4HTime locks lo:");
	printf("\033[16;4HData buffer:");
	printf("\033[17;4HManchester:");
	printf("\033[18;4HMessage buffer:");
	printf("\033[19;4HStatus:");
	printf("\033[24;0HReceived Message");
	printf("\033[25;0H==========================================================================");
	
	//Always loop
	while (1) {
		int i = 2; //iterate through the sensor samples
		int j = 0; //other iterator
		target = addr + 4;
		pointer_addr = map_base + (addr & MAP_MASK);
		while (i < numberOutputSamples) {
			target_written = *((uint32_t *) pointer_addr);
			while (target_written != target) {
				if (i == numberOutputSamples) {
					//printf("Reset!\r");
					break;
				}
				i++;
				//Get the memory address of the next ADC sample
				virt_addr = map_base + (target & MAP_MASK);
				//Perform downsampling by summing up multiple ADC samples
				if (oi == 0)
					sample = 0;
				sample += *((uint16_t *) virt_addr);
				//Increase counters
				oi++;
				target+=2; // 2 bytes per sample
				count++;
				if (oi == ds_factor) {
					oi = 0;
					/* Signal filtering with a low-pass FIR filter*/
					signal = 0;
					//discard last bits of summed samples, store it in the buffer
					fir_buffer[fir_length] = sample / ds_division;
					//shift the buffer
					for (j = 0; j < fir_length; j++) {
						fir_buffer[j] = fir_buffer[j+1];
						signal += fir_buffer[j]*fir_array[j];
					}
					//save the filtered signal value
					signal = signal / fir_division;
					// Keep track of signal minimum and maximum, slowly converging
					minmax_count++;
					if ((minmax_count % 250) == 0 && minmax_count > 10000) {
						if (s_max - signal > 4*ds_factor)
							s_max -= ds_factor*ds_factor;
						if (signal - s_min > 4*ds_factor)
							s_min += ds_factor*ds_factor;
					}
					if (signal > s_max) {
						s_max = signal;
						minmax_count = 0;
					} else if (signal < s_min) {
						s_min = signal;
						minmax_count = 0;
					}
					
					t_display_count++;
					if (t_display_count > 50) {//50000) {
						t_hi_min_display = t_hi_min;
						t_hi_max_display = t_hi_max;
						t_lo_min_display = t_lo_min;
						t_lo_max_display = t_lo_max;
						t_display_count = 0;
					}
					
					//Determine the edge threshold, should be between s_min and s_max
					//edge_threshold = 32*ds_factor; //(edge_threshold *3 + (s_max - s_min) / 4) / 4 + 1;
					
					if (signal > l_min + edge_threshold && symbol == 0) {
						symbol = 1;
						l_max = signal;
					} else if (signal < l_max - edge_threshold && symbol == 1) {
						symbol = 0;
						l_min = signal;
					}
					if (signal > l_max)
						l_max = signal;
					if (signal < l_min)
						l_min = signal;
					
					// Update screen with the most recent value when we have processed all values currently stored in memory.
					if (target_written == target) {
						printf("\033[%d;%dH0x%X  \n", 2, 22, target);
						printf("\033[%d;%dH%d   \n", 3, 22, sample);
						printf("\033[%d;%dH%d   \n", 4, 22, signal);
						
						printf("\033[%d;%dH%d   \n", 5, 22, s_min);
						printf("\033[%d;%dH%d   \n", 6, 22, s_max);
						printf("\033[%d;%dH%d   \n", 7, 22, s_max-s_min);
						
						printf("\033[%d;%dH%d   \n", 5, 50, l_min);
						printf("\033[%d;%dH%d   \n", 6, 50, l_max);
						printf("\033[%d;%dH%d   \n", 7, 50, edge_threshold);
						printf("\033[%d;%dH%d   \n", 8, 50, symbol);
						
						printf("\033[%d;%dH%d %d   \n", 9,  22, t_lo_max_display, t_hi_max_display);
						printf("\033[%d;%dH%d %d   \n", 10, 22, t_lo_min_display, t_hi_min_display);
						printf("\033[%d;%dH%d %d   \n", 11, 22, t_lo_threshold, t_hi_threshold);
						
						printf("\033[%d;%dH%d - %d  \n", 13, 22, t_hi_n_min, t_hi_n_max);
						printf("\033[%d;%dH%d - %d  \n", 14, 22, t_lo_n_min, t_lo_n_max);
						printf("\033[%d;%dH%d - %d  \n", 13, 37, t_hi_w_min, t_hi_w_max);
						printf("\033[%d;%dH%d - %d  \n", 14, 37, t_lo_w_min, t_lo_w_max);
						
						if (status <= 2) {
							printf("\033[%d;%dH%d/%d Hz \n", 10, 60, f_sample / t_lo_max_display, f_sample / t_hi_max_display);
							printf("\033[%d;%dH%d/%d Hz \n", 11, 60, f_sample / t_lo_min_display, f_sample / t_hi_min_display);
						} else {
							printf("\033[%d;%dH%d/%d Hz \n", 10, 60, f_sample / t_lo_w_max, f_sample / t_hi_w_max);
							printf("\033[%d;%dH%d/%d Hz \n", 11, 60, f_sample / t_lo_n_min, f_sample / t_hi_n_min);
						}
						if (status == 0)
							printf("\033[19;22HNo valid signal found   ");
						else if (status == 1)
							printf("\033[19;22HTrying to synchronize   ");
						else if (status == 2)
							printf("\033[19;22HLocking to the signal   ");
						else if (status == 3)
							printf("\033[19;22HReady to receive data   ");
						else if (status == 4)
							printf("\033[19;22HReceiving a message..   ");
						else if (status == -1)
							printf("\033[19;22HPerforming a reset...   ");
					}
					
					
					if (count - change_count > 300000)
						status = -1;
					/* If the symbol has changed, there is a transition detected
					 * We will save the transition
					*/
					if (symbol != prev_symbol) {

						delta = count - change_count; //time duration of the previous detected stripe
						change_count = count;         //save current time as last transition time
						
						
						if (prev_symbol == 1 && delta < t_hi_w_min && delta > t_hi_n_max) {
							//printf("\033[%d;%dH%d                \n", 22, 4*dc+1, delta/10);
							dc++;
						} else if (prev_symbol == 0 && delta < t_lo_w_min && delta > t_lo_n_max) {
							//printf("\033[%d;%dH%d               \n", 23, 4*dc+1, delta/10);
							dc++;
						}
						if (dc > 32)
							dc = 0;
						
						/*if (delta < t_min / 2) {
							status = 1;
								
						}
						if (delta > t_max * 2) {
							status = 1;
						}*/
						
						if (status == -1) {
							t_hi_min = delta;
							t_hi_max = delta;
							t_lo_min = delta;
							t_lo_max = delta;
							status = 0;
						}
						
						if (status <= 2) {
							if (prev_symbol == 1) {
								if (t_hi_max - t_hi_min > t_hi_min) {
									t_hi_min += 3;
									t_hi_max -= 3;
								}
								if (delta < t_hi_min) {
									t_hi_min = delta;
									if (t_hi_max > 8* t_hi_min) {
										t_hi_max = 2*t_hi_min + 10;
									}
								}
								if (delta > t_hi_max) {
									t_hi_max = delta;
									if (t_hi_min * 8 < t_hi_max) {
										t_hi_min = t_hi_max / 2 -10;
									}
								}
								t_hi_threshold = ( t_hi_threshold * 14 + (t_hi_min + t_hi_max) ) / 16;
							} else {
								if (t_lo_max - t_lo_min > t_lo_min) {
									t_lo_min += 3;
									t_lo_max -= 3;
								}
								if (delta < t_lo_min) {
									t_lo_min = delta;
									if (t_lo_max > 8* t_lo_min) {
										t_lo_max = 2*t_lo_min + 10;
									}
								}
								if (delta > t_lo_max) {
									t_lo_max = delta;
									if (t_lo_min * 8 < t_lo_max) {
										t_lo_min = t_lo_max / 2 -10;
									}
								}
								t_lo_threshold = ( t_lo_threshold * 14 + (t_lo_min + t_lo_max) ) / 16;

							}						
							if (status == 2) {
								//We synchronized to the Manchester signal, now stabilize the timing parameters
								if (transition_count == 0) {
									t_hi_n_min = t_hi_max*8;
									t_hi_w_min = t_hi_max*8;
									t_lo_n_min = t_hi_max*8;
									t_lo_w_min = t_hi_max*8;
									t_hi_n_max = 0;
									t_hi_w_max = 0;
									t_lo_n_max = 0;
									t_lo_w_max = 0;
								}
								transition_count++;
								if (prev_symbol) { //high
									if (delta < t_hi_threshold) {//narrow
										if (delta < t_hi_n_min)
											t_hi_n_min = delta;
										if (delta > t_hi_n_max)
											t_hi_n_max = delta;
									} else {//wide
										if (delta < t_hi_w_min)
											t_hi_w_min = delta;
										if (delta > t_hi_w_max)
											t_hi_w_max = delta;
									}							
								} else { //low
									if (delta < t_lo_threshold) {//narrow
										if (delta < t_lo_n_min)
											t_lo_n_min = delta;
										if (delta > t_lo_n_max)
											t_lo_n_max = delta;
									} else {//wide
										if (delta < t_lo_w_min)
											t_lo_w_min = delta;
										if (delta > t_lo_w_max)
											t_lo_w_max = delta;
									}	
								}
								
								if (transition_count > 120) {
									/*if (t_hi_w_min < t_lo_w_min)
										t_threshold = t_hi_w_min;
									else
										t_threshold = t_lo_w_min;
									if (t_hi_n_max > t_lo_n_max)
										t_threshold += t_hi_n_max;
									else
										t_threshold += t_lo_n_max;
									t_threshold /= 2;*/
									t_hi_threshold = (t_hi_w_min*2 + t_hi_n_max) / 3;
									t_lo_threshold = (t_lo_w_min*3 + t_lo_n_max) / 4;
									status = 3;
									
									printf("\033[22;0H\033[2K");
									printf("\033[23;0H\033[2K");
									dc = 0;
								}
								
							}
						} else {
							if (prev_symbol == 1) {
								if (delta > t_hi_threshold && delta < t_hi_w_min && delta *11 > t_hi_w_min*10)
									t_hi_w_min = delta;
								if (delta < t_hi_threshold && delta > t_hi_n_max && delta *10 < t_hi_n_max*11)
									t_hi_n_max = delta;
								
								t_hi_threshold = (t_hi_w_min*1 + t_hi_n_max) / 2;
							} else {
								
								if (delta > t_lo_threshold && delta < t_lo_w_min && delta *11 > t_lo_w_min*10)
									t_lo_w_min = delta;
								if (delta < t_lo_threshold && delta > t_lo_n_max && delta *10 < t_lo_n_max*11)
									t_lo_n_max = delta;
								t_lo_threshold = (t_lo_w_min*2 + t_lo_n_max) / 3;
								
							}
						}
						//Store High-Low symbol sequence
						if (prev_symbol == 1 && delta > t_hi_threshold)
							j = 0;
						else if (prev_symbol == 0 && delta > t_lo_threshold)
							j = 0;
						else
							j = 1;
						for (;j < 2; j++) {
							printf("\033[%d;%dH%d  ", 16, 22+(hilo_buf_i % 64), 1-prev_symbol);
							hilo_buf[hilo_buf_i++] = 1-prev_symbol;
							if (hilo_buf_i >= 640)
								hilo_buf_i -= 640;
						}
						
						//Try to decode the Manchester data
						while ((640 -2 + hilo_buf_i - hilo_buf_man_i) % 640 < 4) {
							if (hilo_buf[hilo_buf_man_i] == hilo_buf[(hilo_buf_man_i+1) % 640]) { //Invalid
								man_buf[man_buf_i++] = -1;
								printf("\033[%d;%dHX  ", 17, 22+(man_buf_i % 64));
								status = -1;
								//Try to repair the synchronization
								hilo_buf_man_i++;
							} else {
								//man_buf[man_buf_i++] = 1 - hilo_buf[hilo_buf_man_i]; // inverted Manchester (note that debug output is always non-inverted)
								man_buf[man_buf_i++] = hilo_buf[hilo_buf_man_i];   // non-inverted Manchester
								printf("\033[%d;%dH%d  ", 17, 22+(man_buf_i % 64), hilo_buf[hilo_buf_man_i]);
								hilo_buf_man_i += 2;
								if (status == 0) {
									status = 1;
									man_buf_ascii_i = man_buf_i % 640;
								}
							}
							if (hilo_buf_man_i >= 640)
								hilo_buf_man_i -= 640;
							if (man_buf_i >= 640)
								man_buf_i -= 640;
						}
						
						if (status > 0) {
							while ((640 - 8 + man_buf_i - man_buf_ascii_i) % 640 < 16) {
								unsigned char c = 0;
								for (j = 0; j < 8; j++) {
									c = (c<<1) | man_buf[(man_buf_ascii_i+j) % 640];
								}
								
								//printf("\033[%d;%dH%d %d   %d", 27, 22, 
								//(man_buf_ascii_i+j) % 640, man_buf[(man_buf_ascii_i+j) % 640], c);
								if (c > 128) {//no valid ASCII character
									status = 1;
								}
								if (c == 21 || c == 24) {//NAK or cancel
									status = 1;
								}
								if (status == 1) {
									if (c == 22 || c == 53) {
										status = 2;
										transition_count = 0;
									} else {
										man_buf_ascii_i++;
									}
								}
								if (status >= 2) {
									man_buf_ascii_i += 8;
									ascii_buf[ascii_buf_i++] = c;
									if (c == 2 && status >= 3) {//STX Start of text
										ascii_buf_i = 0;
										status = 4;
										printf("\033[26;0H\033[0J");
									}
									if (c < 128)
										printf("\033[%d;%dH%c  ", 18, 22+((ascii_buf_i % 32)), c);
									if (c == 22)
										printf("\033[%d;%dH.  ", 18, 22+((ascii_buf_i % 32)));
									if (ascii_buf_i > 255)
										ascii_buf_i = 0;
								}
								if (status == 4) {
									if (c == 3 || c == 4 || c == 22) {//ETX End of text or EOT End of transmission
										status = 3;
									}
									if (ascii_buf_i == 255 || status == 3) {
										printf("\033[26;0H\033[0J");
										for (j = 0; j < ascii_buf_i; j++) {
											printf("%c", ascii_buf[j]);
										}
										ascii_buf_i = 0;
									}
								}
								if (man_buf_ascii_i >= 640) {
									man_buf_ascii_i -= 640;
								}
								
							}
						}
						

					}
					prev_symbol = symbol;
				}
			}
		}
		//fflush(stdout);
	}
	if(munmap(map_base, MAP_SIZE) == -1) {
	   printf("Failed to unmap memory");
	   return -1;
	}
	close(fd);
	return 0;
}

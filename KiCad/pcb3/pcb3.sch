EESchema Schematic File Version 4
LIBS:pcb3-cache
EELAYER 26 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Amplifier_Operational:OPA2325 U1
U 1 1 5B6C60D9
P 3650 2050
F 0 "U1" H 3650 2417 50  0000 C CNN
F 1 "OPA2325" H 3650 2326 50  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 3800 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/opa2325.pdf" H 3650 2050 50  0001 C CNN
	1    3650 2050
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:OPA2325 U1
U 2 1 5B6C6156
P 5150 2050
F 0 "U1" H 5150 2417 50  0000 C CNN
F 1 "OPA2325" H 5150 2326 50  0000 C CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 5300 2400 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/opa2325.pdf" H 5150 2050 50  0001 C CNN
	2    5150 2050
	1    0    0    -1  
$EndComp
$Comp
L Amplifier_Operational:OPA2325 U1
U 3 1 5B6C61D1
P 2950 2500
F 0 "U1" H 2908 2546 50  0000 L CNN
F 1 "OPA2325" H 2908 2455 50  0000 L CNN
F 2 "Package_SO:SOIC-8_3.9x4.9mm_P1.27mm" H 3100 2850 50  0001 C CNN
F 3 "http://www.ti.com/lit/ds/symlink/opa2325.pdf" H 2950 2500 50  0001 C CNN
	3    2950 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3250 1950 3250 1600
Wire Wire Line
	3250 1600 4400 1600
Wire Wire Line
	4400 1600 4400 1950
Wire Wire Line
	4400 1950 4850 1950
Connection ~ 3250 1950
Wire Wire Line
	3250 1950 3350 1950
Wire Wire Line
	3350 2150 3250 2150
Wire Wire Line
	3250 2150 3250 2350
Wire Wire Line
	3250 2350 3350 2350
Wire Wire Line
	4400 2350 4400 2150
Wire Wire Line
	4400 2150 4850 2150
Wire Wire Line
	2600 2150 2600 2800
Wire Wire Line
	2600 2800 2850 2800
Wire Wire Line
	2850 2200 2850 2150
$Comp
L Connector:Conn_01x04_Female J2
U 1 1 5B6C68ED
P 6000 1850
F 0 "J2" H 6027 1826 50  0000 L CNN
F 1 "Conn_01x04_Female" H 6027 1735 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 6000 1850 50  0001 C CNN
F 3 "~" H 6000 1850 50  0001 C CNN
	1    6000 1850
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Female J3
U 1 1 5B6C69AC
P 6000 2500
F 0 "J3" H 6027 2476 50  0000 L CNN
F 1 "Conn_01x04_Female" H 6027 2385 50  0000 L CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 6000 2500 50  0001 C CNN
F 3 "~" H 6000 2500 50  0001 C CNN
	1    6000 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5800 1950 5650 1950
Wire Wire Line
	5650 1950 5650 2050
Wire Wire Line
	5650 2050 5450 2050
Wire Wire Line
	5650 2050 5800 2050
Connection ~ 5650 2050
Wire Wire Line
	3950 2050 4800 2050
Wire Wire Line
	4800 2050 4800 1600
Wire Wire Line
	4800 1600 5650 1600
Wire Wire Line
	5650 1600 5650 1750
Wire Wire Line
	5650 1850 5800 1850
Wire Wire Line
	5800 1750 5650 1750
Connection ~ 5650 1750
Wire Wire Line
	5650 1750 5650 1850
Wire Wire Line
	5800 2400 5700 2400
Wire Wire Line
	5700 2400 5700 2500
Wire Wire Line
	5700 2700 5800 2700
Wire Wire Line
	5800 2600 5700 2600
Connection ~ 5700 2600
Wire Wire Line
	5700 2600 5700 2700
Wire Wire Line
	5800 2500 5700 2500
Connection ~ 5700 2500
Wire Wire Line
	5700 2500 5700 2600
Wire Wire Line
	2850 2800 3350 2800
Wire Wire Line
	5700 2800 5700 2700
Connection ~ 2850 2800
Connection ~ 5700 2700
$Comp
L Device:R R2
U 1 1 5B6C877C
P 3350 2550
F 0 "R2" H 3420 2596 50  0000 L CNN
F 1 "1k5" H 3420 2505 50  0000 L CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad1.05x0.95mm_HandSolder" V 3280 2550 50  0001 C CNN
F 3 "~" H 3350 2550 50  0001 C CNN
	1    3350 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5B6C87FC
P 3050 2150
F 0 "R1" V 3150 2150 50  0000 C CNN
F 1 "1k5" V 2934 2150 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric_Pad1.05x0.95mm_HandSolder" V 2980 2150 50  0001 C CNN
F 3 "~" H 3050 2150 50  0001 C CNN
	1    3050 2150
	0    1    1    0   
$EndComp
Wire Wire Line
	3200 2150 3250 2150
Connection ~ 3250 2150
Wire Wire Line
	2900 2150 2850 2150
Wire Wire Line
	3350 2350 3350 2400
Connection ~ 3350 2350
Wire Wire Line
	3350 2350 4400 2350
Wire Wire Line
	3350 2700 3350 2800
Wire Wire Line
	3350 2800 5700 2800
Connection ~ 3350 2800
$Comp
L Connector:Conn_01x08_Female J1
U 1 1 5B6CD379
P 2050 2250
F 0 "J1" H 1944 2735 50  0000 C CNN
F 1 "Conn_01x08_Female" H 2200 2650 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x08_P2.54mm_Vertical" H 2050 2250 50  0001 C CNN
F 3 "~" H 2050 2250 50  0001 C CNN
	1    2050 2250
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2250 1950 3250 1950
Wire Wire Line
	2250 2150 2450 2150
Text Label 2250 1950 0    50   ~ 0
PD2
Text Label 2250 2150 0    50   ~ 0
G
Text Label 2250 2650 0    50   ~ 0
5V
$Comp
L Connector:Conn_01x02_Male J4
U 1 1 5B6CF0FB
P 2650 2000
F 0 "J4" H 2623 1973 50  0000 R CNN
F 1 "Conn_01x02_Male" H 2800 2150 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical" H 2650 2000 50  0001 C CNN
F 3 "~" H 2650 2000 50  0001 C CNN
	1    2650 2000
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2850 2150 2700 2150
Wire Wire Line
	2700 2150 2700 2650
Connection ~ 2850 2150
Wire Wire Line
	2450 2100 2450 2150
Connection ~ 2450 2150
Wire Wire Line
	2450 2150 2600 2150
Wire Wire Line
	2450 2000 2250 2000
Wire Wire Line
	2250 2000 2250 2050
$Comp
L Device:C C1
U 1 1 5B6D1045
P 2450 2900
F 0 "C1" H 2565 2946 50  0000 L CNN
F 1 "1u" H 2565 2855 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.05x0.95mm_HandSolder" H 2488 2750 50  0001 C CNN
F 3 "~" H 2450 2900 50  0001 C CNN
	1    2450 2900
	1    0    0    -1  
$EndComp
Wire Wire Line
	2850 3050 2850 2800
$Comp
L USB-A-S-X-X-TH:USB-A-S-X-X-TH J6
U 1 1 5B6C71D9
P 4050 3650
F 0 "J6" H 4579 3396 50  0000 L CNN
F 1 "USB-A-S-X-X-TH" H 4579 3305 50  0000 L CNN
F 2 "USB-A-S-X-X-TH:USB-A-S-X-X-TH" H 4050 3650 50  0001 L BNN
F 3 "Samtec" H 4050 3650 50  0001 L BNN
F 4 "SAM10373-ND" H 4050 3650 50  0001 L BNN "Field4"
F 5 "None" H 4050 3650 50  0001 L BNN "Field5"
F 6 "https://www.digikey.nl/product-detail/en/samtec-inc/USB-A-S-S-W-TH/SAM10373-ND/6679110?utm_source=snapeda&utm_medium=aggregator&utm_campaign=symbol" H 4050 3650 50  0001 L BNN "Field6"
F 7 "USB-A-S-S-W-TH" H 4050 3650 50  0001 L BNN "Field7"
F 8 "Conn USB 2.0 Type A F 4 POS Solder RA Thru-Hole 4 Terminal 1 Port Tray" H 4050 3650 50  0001 L BNN "Field8"
	1    4050 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 3950 4050 3950
Wire Wire Line
	4050 4150 3650 4150
Connection ~ 3650 4150
Wire Wire Line
	3650 4150 3650 3950
Wire Wire Line
	4050 4250 3650 4250
Wire Wire Line
	3650 4250 3650 4150
Wire Wire Line
	3650 3950 2850 3950
Wire Wire Line
	2850 3950 2850 3050
Connection ~ 3650 3950
Connection ~ 2850 3050
Wire Wire Line
	2450 3050 2850 3050
Wire Wire Line
	2450 2750 2450 2650
Wire Wire Line
	2250 2650 2300 2650
Connection ~ 2450 2650
Wire Wire Line
	2450 2650 2700 2650
Wire Wire Line
	2300 2650 2300 3650
Wire Wire Line
	2300 3650 4050 3650
Connection ~ 2300 2650
Wire Wire Line
	2300 2650 2450 2650
$Comp
L Connector:Conn_01x02_Female J5
U 1 1 5B6D57D1
P 3050 3750
F 0 "J5" H 2944 3935 50  0000 C CNN
F 1 "Conn_01x02_Female" H 3050 3500 50  0000 C CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x02_P2.54mm_Vertical" H 3050 3750 50  0001 C CNN
F 3 "~" H 3050 3750 50  0001 C CNN
	1    3050 3750
	-1   0    0    -1  
$EndComp
Wire Wire Line
	3250 3750 4050 3750
Wire Wire Line
	3250 3850 4050 3850
Text Label 3450 3750 0    50   ~ 0
wit
Text Label 3450 3850 0    50   ~ 0
geel
Text Label 3450 3650 0    50   ~ 0
rood
Text Label 3450 3950 0    50   ~ 0
zwart
$EndSCHEMATC

# SHIP MODULES & SHIPS - KOMPLETTE DATENBANK

**Projekt:** Space Game  
**Version:** 1.0  
**Datum:** November 2025  
**Status:** Produktionsbereit  
**Einträge:** 300 Module + 155 Ships = 455 Gesamt

---

## INHALTSVERZEICHNIS

1. [Übersicht](#übersicht)
2. [Ship Modules (300)](#ship-modules)
   - [Shields & Armor (50)](#shields--armor)
   - [Engines & Power (50)](#engines--power)
   - [Cargo & Sensors (50)](#cargo--sensors)
   - [ECM & Mining (50)](#ecm--mining)
   - [Command & Medical (50)](#command--medical)
   - [Utility & Station (50)](#utility--station)
3. [Ships (155)](#ships)
   - [Frigates & Destroyers (40)](#frigates--destroyers)
   - [Cruisers & Battlecruisers (35)](#cruisers--battlecruisers)
   - [Battleships & Carriers (27)](#battleships--carriers)
   - [Dreadnoughts & Titans (18)](#dreadnoughts--titans)
   - [Industrial, Special & Civilian (35)](#industrial-special--civilian)
4. [Verwendung in Godot](#verwendung-in-godot)
5. [Balancing-Übersicht](#balancing-übersicht)

---

## ÜBERSICHT

### Modul-Kategorien

| Kategorie | Anzahl | Tier-Range | Preis-Range | Verwendung |
|-----------|--------|------------|-------------|------------|
| **Shields** | 25 | 1-5 | 4k - 2.2M | Verteidigung, HP-Regeneration |
| **Armor** | 25 | 1-5 | 4k - 2.4M | Panzerung, Reparatur |
| **Engines** | 25 | 1-5 | 5k - 2.6M | Antrieb, Geschwindigkeit |
| **Power** | 25 | 1-5 | 5.5k - 3.2M | Energie-Erzeugung, Speicher |
| **Cargo** | 25 | 1-5 | 3.2k - 2.4M | Lagerung, Transport |
| **Sensors** | 25 | 1-5 | 3k - 2M | Erfassung, Scan |
| **ECM** | 21 | 2-5 | 12k - 2.1M | Elektronische Kriegsführung |
| **Mining** | 29 | 2-5 | 15k - 2.8M | Ressourcen-Abbau |
| **Command** | 22 | 2-5 | 22k - 2.6M | Flottenführung |
| **Medical** | 28 | 1-5 | 5k - 2.7M | Crew-Versorgung |
| **Utility** | 25 | 2-5 | 15k - 4.5M | Reparatur, Salvage |
| **Station** | 25 | 3-5 | 145k - 4.5M | Stations-Module |

### Schiffs-Kategorien

| Kategorie | Anzahl | Tier-Range | Größe | Preis-Range |
|-----------|--------|------------|-------|-------------|
| **Frigates** | 20 | 1-5 | S | 50k - 225k |
| **Destroyers** | 20 | 1-5 | M | 150k - 420k |
| **Cruisers** | 20 | 2-4 | M-L | 200k - 520k |
| **Battlecruisers** | 15 | 4-5 | L | 650k - 1M |
| **Battleships** | 15 | 5 | L-XL | 1.2M - 2.2M |
| **Carriers** | 7 | 4-5 | XL | 2M - 3M |
| **Dreadnoughts** | 10 | 5 | XL | 4M - 5.1M |
| **Titans** | 8 | 5 | XL | 10M - 14M |
| **Industrial** | 30 | 2-5 | S-XL | 80k - 6.5M |
| **Special** | 5 | 3 | S | 110k - 120k |
| **Civilian** | 5 | 1 | S | 1k - 5.3k |

---

## SHIP MODULES

### SHIELDS & ARMOR

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
MODULE	MOD_001	Basic Shield Generator	1	Shield	S	Defense	120	1.2	5000	600	MAT_T1_001	50	MAT_T1_002	30	COMP_001	5	Entry-level shield
MODULE	MOD_002	Standard Shield Generator	1	Shield	S	Defense	150	1.5	6500	720	MAT_T1_001	60	MAT_T2_008	25	COMP_001	6	Improved basic shield
MODULE	MOD_003	Small Shield Booster	1	Shield	S	Amplifier	80	0.8	4000	480	MAT_T1_002	40	MAT_T2_013	20	COMP_002	4	Shield boost 15%
MODULE	MOD_004	Light Shield Extender	1	Shield	S	Capacity	100	1.0	5500	600	MAT_T1_001	55	MAT_T1_003	25	COMP_003	5	+500 HP capacity
MODULE	MOD_005	Basic Hardener	1	Shield	S	Resistance	90	0.9	4500	540	MAT_T2_008	35	MAT_T2_009	20	COMP_001	4	+12% resistance all
MODULE	MOD_006	Improved Shield Generator	2	Shield	M	Defense	450	4.5	18000	1200	MAT_T2_008	120	MAT_T2_010	80	COMP_005	15	Mid-tier shielding
MODULE	MOD_007	Enhanced Shield Generator	2	Shield	M	Defense	520	5.2	22000	1440	MAT_T2_008	140	MAT_T2_010	90	COMP_006	18	Better recharge rate
MODULE	MOD_008	Medium Shield Booster	2	Shield	M	Amplifier	380	3.8	16000	1080	MAT_T2_009	100	MAT_T2_013	60	COMP_007	12	Shield boost 25%
MODULE	MOD_009	Medium Shield Extender	2	Shield	M	Capacity	420	4.2	19000	1200	MAT_T2_010	110	MAT_T2_013	70	COMP_008	14	+2500 HP capacity
MODULE	MOD_010	Advanced Hardener	2	Shield	M	Resistance	400	4.0	17000	1140	MAT_T2_008	95	MAT_T2_011	65	COMP_009	13	+18% resistance all
MODULE	MOD_011	Elite Shield Generator	3	Shield	M	Defense	850	8.5	75000	2400	MAT_T3_016	200	MAT_T3_018	120	COMP_015	30	Heavy-duty shield
MODULE	MOD_012	Combat Shield Generator	3	Shield	M	Defense	920	9.2	85000	2640	MAT_T3_016	220	MAT_T3_020	140	COMP_016	35	Combat-optimized
MODULE	MOD_013	Tactical Shield Generator	3	Shield	L	Defense	1100	11.0	95000	2880	MAT_T3_016	250	MAT_T3_021	150	COMP_017	38	Capital-grade basic
MODULE	MOD_014	Heavy Shield Booster	3	Shield	M	Amplifier	780	7.8	68000	2280	MAT_T3_016	180	MAT_T3_019	110	COMP_018	28	Shield boost 35%
MODULE	MOD_015	Large Shield Extender	3	Shield	L	Capacity	950	9.5	80000	2520	MAT_T3_018	200	MAT_T3_021	130	COMP_019	32	+8000 HP capacity
MODULE	MOD_016	Elite Hardener	3	Shield	M	Resistance	820	8.2	72000	2400	MAT_T3_020	190	MAT_T3_022	125	COMP_020	30	+25% resistance all
MODULE	MOD_017	Adaptive Shield System	3	Shield	L	Smart	1050	10.5	90000	2760	MAT_T3_016	230	MAT_T3_018	145	COMP_021	36	Auto-adapts damage type
MODULE	MOD_018	Quantum Shield Generator	4	Shield	L	Defense	3200	32.0	280000	4800	MAT_T4_023	600	MAT_T4_025	400	COMP_045	80	Capital shield system
MODULE	MOD_019	Capital Shield Generator	4	Shield	L	Defense	3600	36.0	320000	5400	MAT_T4_023	680	MAT_T4_026	450	COMP_046	90	Battleship-grade
MODULE	MOD_020	Siege Shield Booster	4	Shield	L	Amplifier	2800	28.0	250000	4500	MAT_T4_024	550	MAT_T4_025	380	COMP_047	75	Shield boost 50%
MODULE	MOD_021	Capital Shield Extender	4	Shield	XL	Capacity	3400	34.0	300000	5100	MAT_T4_025	650	MAT_T4_027	420	COMP_048	85	+30000 HP capacity
MODULE	MOD_022	Quantum Hardener	4	Shield	L	Resistance	3000	30.0	265000	4800	MAT_T4_026	580	MAT_T4_027	400	COMP_049	78	+35% resistance all
MODULE	MOD_023	Titan Shield Generator	5	Shield	XL	Defense	12000	120.0	1800000	9600	MAT_T5_028	2000	MAT_T5_031	1200	COMP_090	200	Titan-class shielding
MODULE	MOD_024	Mega Shield Booster	5	Shield	XL	Amplifier	10000	100.0	1500000	8400	MAT_T5_029	1800	MAT_T5_032	1000	COMP_091	180	Shield boost 70%
MODULE	MOD_025	Ultimate Shield Extender	5	Shield	Station	Capacity	15000	150.0	2200000	10800	MAT_T5_030	2400	MAT_T5_033	1400	COMP_092	220	+120000 HP capacity
MODULE	MOD_026	Basic Armor Plate	1	Armor	S	Plating	180	1.8	4500	600	MAT_T1_001	70	MAT_T2_008	40	COMP_001	5	Entry armor layer
MODULE	MOD_027	Standard Armor Plate	1	Armor	S	Plating	220	2.2	6000	720	MAT_T1_001	85	MAT_T2_008	50	COMP_002	6	Basic protection
MODULE	MOD_028	Small Armor Hardener	1	Armor	S	Resistance	140	1.4	4000	540	MAT_T2_009	50	MAT_T2_010	30	COMP_003	4	+10% armor resist
MODULE	MOD_029	Light Armor Repair	1	Armor	S	Repair	160	1.6	5000	600	MAT_T1_002	60	MAT_T2_013	35	COMP_004	5	Repairs 50 HP/s
MODULE	MOD_030	Reactive Plating	1	Armor	S	Reactive	150	1.5	5500	660	MAT_T2_008	65	MAT_T2_014	38	COMP_005	5	Adapts to damage
MODULE	MOD_031	Improved Armor Plate	2	Armor	M	Plating	680	6.8	20000	1200	MAT_T2_008	180	MAT_T2_010	120	COMP_010	15	Mid-tier armor
MODULE	MOD_032	Enhanced Armor Plate	2	Armor	M	Plating	780	7.8	24000	1440	MAT_T2_008	200	MAT_T2_010	140	COMP_011	18	Reinforced plating
MODULE	MOD_033	Medium Armor Hardener	2	Armor	M	Resistance	580	5.8	18000	1080	MAT_T2_009	150	MAT_T2_011	100	COMP_012	12	+16% armor resist
MODULE	MOD_034	Medium Armor Repair	2	Armor	M	Repair	620	6.2	19000	1200	MAT_T2_010	160	MAT_T2_013	110	COMP_013	14	Repairs 200 HP/s
MODULE	MOD_035	Composite Armor	2	Armor	M	Composite	720	7.2	22000	1320	MAT_T2_014	170	MAT_T2_015	115	COMP_014	16	Layered protection
MODULE	MOD_036	Elite Armor Plate	3	Armor	L	Plating	1300	13.0	80000	2400	MAT_T3_016	350	MAT_T3_018	220	COMP_025	35	Heavy armor plating
MODULE	MOD_037	Combat Armor Plate	3	Armor	M	Plating	1150	11.5	72000	2280	MAT_T3_016	320	MAT_T3_020	200	COMP_026	32	Combat-optimized
MODULE	MOD_038	Tactical Armor System	3	Armor	L	System	1450	14.5	90000	2640	MAT_T3_021	380	MAT_T3_022	240	COMP_027	38	Integrated armor
MODULE	MOD_039	Heavy Armor Hardener	3	Armor	M	Resistance	1100	11.0	68000	2280	MAT_T3_018	300	MAT_T3_019	190	COMP_028	30	+24% armor resist
MODULE	MOD_040	Large Armor Repair	3	Armor	L	Repair	1250	12.5	75000	2520	MAT_T3_016	340	MAT_T3_020	210	COMP_029	34	Repairs 800 HP/s
MODULE	MOD_041	Nanofiber Armor	3	Armor	M	Nanotech	1200	12.0	78000	2400	MAT_T3_021	330	MAT_T2_014	205	COMP_030	33	Self-repairing
MODULE	MOD_042	Crystalline Armor	3	Armor	L	Exotic	1350	13.5	85000	2760	MAT_T3_018	360	MAT_T3_022	225	COMP_031	36	Energy-absorbing
MODULE	MOD_043	Quantum Armor Plate	4	Armor	XL	Plating	4800	48.0	320000	4800	MAT_T4_023	900	MAT_T4_025	600	COMP_055	90	Capital armor
MODULE	MOD_044	Capital Armor Plate	4	Armor	L	Plating	4200	42.0	280000	4500	MAT_T4_023	800	MAT_T4_026	550	COMP_056	85	Battleship armor
MODULE	MOD_045	Siege Armor System	4	Armor	XL	System	5200	52.0	350000	5400	MAT_T4_024	1000	MAT_T4_027	650	COMP_057	95	Siege-grade protection
MODULE	MOD_046	Capital Armor Hardener	4	Armor	L	Resistance	4000	40.0	265000	4500	MAT_T4_025	850	MAT_T4_026	580	COMP_058	82	+32% armor resist
MODULE	MOD_047	Capital Armor Repair	4	Armor	L	Repair	4400	44.0	300000	5100	MAT_T4_023	920	MAT_T4_027	620	COMP_059	88	Repairs 3000 HP/s
MODULE	MOD_048	Titan Armor Plate	5	Armor	Station	Plating	18000	180.0	2000000	9600	MAT_T5_028	3000	MAT_T5_031	1800	COMP_095	220	Titan-class armor
MODULE	MOD_049	Mega Armor System	5	Armor	XL	System	16000	160.0	1800000	8400	MAT_T5_029	2800	MAT_T5_032	1600	COMP_096	200	Ultimate protection
MODULE	MOD_050	Ultimate Armor Repair	5	Armor	Station	Repair	20000	200.0	2400000	10800	MAT_T5_030	3500	MAT_T5_033	2000	COMP_097	250	Repairs 12000 HP/s
```

### ENGINES & POWER

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
MODULE	MOD_051	Basic Thruster	1	Engines	S	Propulsion	200	2.0	6000	720	MAT_T1_001	80	MAT_T1_002	50	COMP_010	6	Entry propulsion
MODULE	MOD_052	Standard Engine	1	Engines	S	Propulsion	250	2.5	7500	840	MAT_T1_001	100	MAT_T2_009	60	COMP_011	7	Basic movement
MODULE	MOD_053	Light Afterburner	1	Engines	S	Speed Boost	180	1.8	5500	660	MAT_T1_002	70	MAT_T2_013	45	COMP_012	6	+150% speed 10sec
MODULE	MOD_054	Small Microwarpdrive	1	Engines	S	Warp	220	2.2	8000	900	MAT_T2_010	90	MAT_T2_013	55	COMP_013	7	500% speed boost
MODULE	MOD_055	Basic Gyrostabilizer	1	Engines	S	Agility	160	1.6	5000	600	MAT_T1_003	65	MAT_T2_008	40	COMP_014	5	+15% turn rate
MODULE	MOD_056	Improved Thruster	2	Engines	M	Propulsion	750	7.5	25000	1440	MAT_T2_008	200	MAT_T2_010	140	COMP_020	18	Mid-tier propulsion
MODULE	MOD_057	Enhanced Engine	2	Engines	M	Propulsion	850	8.5	28000	1560	MAT_T2_009	220	MAT_T2_010	160	COMP_021	20	Better acceleration
MODULE	MOD_058	Medium Afterburner	2	Engines	M	Speed Boost	680	6.8	22000	1320	MAT_T2_010	180	MAT_T2_013	120	COMP_022	16	+180% speed 15sec
MODULE	MOD_059	Medium Microwarpdrive	2	Engines	M	Warp	820	8.2	30000	1680	MAT_T2_010	230	MAT_T2_014	150	COMP_023	19	600% speed boost
MODULE	MOD_060	Improved Gyrostabilizer	2	Engines	M	Agility	720	7.2	24000	1380	MAT_T2_008	190	MAT_T2_011	130	COMP_024	17	+22% turn rate
MODULE	MOD_061	Elite Thruster	3	Engines	L	Propulsion	1600	16.0	95000	2640	MAT_T3_016	400	MAT_T3_018	280	COMP_040	40	Heavy propulsion
MODULE	MOD_062	Combat Engine	3	Engines	M	Propulsion	1400	14.0	85000	2400	MAT_T3_016	360	MAT_T3_020	260	COMP_041	38	Combat-optimized
MODULE	MOD_063	Tactical Thruster	3	Engines	L	Propulsion	1750	17.5	105000	2880	MAT_T3_021	450	MAT_T3_022	300	COMP_042	42	Capital-grade thrust
MODULE	MOD_064	Heavy Afterburner	3	Engines	M	Speed Boost	1350	13.5	82000	2520	MAT_T3_018	340	MAT_T3_019	240	COMP_043	36	+220% speed 20sec
MODULE	MOD_065	Large Microwarpdrive	3	Engines	L	Warp	1650	16.5	98000	2760	MAT_T3_016	420	MAT_T3_021	290	COMP_044	40	750% speed boost
MODULE	MOD_066	Elite Gyrostabilizer	3	Engines	M	Agility	1300	13.0	80000	2400	MAT_T3_020	350	MAT_T3_022	250	COMP_045	35	+30% turn rate
MODULE	MOD_067	Ion Drive System	3	Engines	L	Ion	1800	18.0	110000	3000	MAT_T3_016	480	MAT_T3_018	320	COMP_046	44	High efficiency ion
MODULE	MOD_068	Quantum Thruster	4	Engines	XL	Propulsion	5500	55.0	350000	5400	MAT_T4_023	1100	MAT_T4_025	750	COMP_065	100	Capital propulsion
MODULE	MOD_069	Capital Engine	4	Engines	L	Propulsion	4800	48.0	310000	4800	MAT_T4_023	980	MAT_T4_026	680	COMP_066	95	Battleship engines
MODULE	MOD_070	Siege Afterburner	4	Engines	L	Speed Boost	4500	45.0	285000	4650	MAT_T4_024	920	MAT_T4_025	640	COMP_067	88	+270% speed 30sec
MODULE	MOD_071	Capital Microwarpdrive	4	Engines	XL	Warp	5800	58.0	380000	5700	MAT_T4_025	1200	MAT_T4_027	800	COMP_068	105	900% speed boost
MODULE	MOD_072	Quantum Gyrostabilizer	4	Engines	L	Agility	4700	47.0	295000	4800	MAT_T4_026	960	MAT_T4_027	670	COMP_069	92	+40% turn rate
MODULE	MOD_073	Titan Thruster	5	Engines	Station	Propulsion	22000	220.0	2200000	10800	MAT_T5_028	3800	MAT_T5_031	2400	COMP_098	280	Titan-class thrust
MODULE	MOD_074	Mega Drive System	5	Engines	XL	Propulsion	19000	190.0	1900000	9600	MAT_T5_029	3400	MAT_T5_032	2100	COMP_099	250	Ultimate propulsion
MODULE	MOD_075	Ultimate Warp Drive	5	Engines	Station	Warp	25000	250.0	2600000	11400	MAT_T5_030	4200	MAT_T5_033	2800	COMP_100	300	Instant warp capability
MODULE	MOD_076	Basic Reactor	1	Power	S	Generation	280	2.8	7000	840	MAT_T1_001	110	MAT_T1_004	70	COMP_015	8	Entry power gen
MODULE	MOD_077	Standard Power Core	1	Power	S	Generation	320	3.2	8500	960	MAT_T1_001	130	MAT_T2_009	80	COMP_016	9	Basic energy
MODULE	MOD_078	Small Capacitor	1	Power	S	Storage	240	2.4	6500	780	MAT_T1_002	95	MAT_T2_013	60	COMP_017	7	Energy storage 5000 GJ
MODULE	MOD_079	Light Power Relay	1	Power	S	Distribution	200	2.0	5500	660	MAT_T1_003	80	MAT_T2_008	50	COMP_018	6	Efficient distribution
MODULE	MOD_080	Basic Energy Regulator	1	Power	S	Control	220	2.2	6000	720	MAT_T2_010	90	MAT_T2_013	55	COMP_019	7	Stable output
MODULE	MOD_081	Improved Reactor	2	Power	M	Generation	950	9.5	30000	1680	MAT_T2_008	240	MAT_T2_010	180	COMP_030	22	Mid-tier reactor
MODULE	MOD_082	Enhanced Power Core	2	Power	M	Generation	1100	11.0	35000	1860	MAT_T2_009	280	MAT_T2_010	200	COMP_031	25	More power output
MODULE	MOD_083	Medium Capacitor	2	Power	M	Storage	880	8.8	28000	1560	MAT_T2_010	230	MAT_T2_013	160	COMP_032	20	Energy storage 20000 GJ
MODULE	MOD_084	Medium Power Relay	2	Power	M	Distribution	820	8.2	26000	1440	MAT_T2_008	210	MAT_T2_011	150	COMP_033	19	Better efficiency
MODULE	MOD_085	Improved Energy Regulator	2	Power	M	Control	900	9.0	29000	1620	MAT_T2_010	235	MAT_T2_014	165	COMP_034	21	Enhanced stability
MODULE	MOD_086	Elite Reactor	3	Power	L	Generation	2000	20.0	120000	2880	MAT_T3_016	520	MAT_T3_018	380	COMP_050	50	Heavy power gen
MODULE	MOD_087	Combat Power Core	3	Power	M	Generation	1750	17.5	105000	2640	MAT_T3_016	480	MAT_T3_020	350	COMP_051	48	Combat-grade power
MODULE	MOD_088	Tactical Reactor	3	Power	L	Generation	2200	22.0	135000	3120	MAT_T3_021	580	MAT_T3_022	420	COMP_052	55	Capital power system
MODULE	MOD_089	Large Capacitor	3	Power	L	Storage	1900	19.0	115000	2760	MAT_T3_018	500	MAT_T3_019	370	COMP_053	47	Energy storage 80000 GJ
MODULE	MOD_090	Heavy Power Relay	3	Power	M	Distribution	1800	18.0	110000	2640	MAT_T3_016	490	MAT_T3_021	360	COMP_054	46	High-capacity relay
MODULE	MOD_091	Elite Energy Regulator	3	Power	M	Control	1850	18.5	112000	2700	MAT_T3_020	510	MAT_T3_022	375	COMP_055	48	Advanced regulation
MODULE	MOD_092	Fusion Reactor	3	Power	L	Fusion	2150	21.5	130000	3000	MAT_T3_016	560	MAT_T3_018	410	COMP_056	52	Fusion-based power
MODULE	MOD_093	Quantum Reactor	4	Power	XL	Generation	7000	70.0	420000	6000	MAT_T4_023	1400	MAT_T4_025	1000	COMP_075	120	Capital reactor
MODULE	MOD_094	Capital Power Core	4	Power	L	Generation	6200	62.0	380000	5400	MAT_T4_023	1250	MAT_T4_026	900	COMP_076	115	Battleship power
MODULE	MOD_095	Siege Reactor	4	Power	XL	Generation	7500	75.0	450000	6600	MAT_T4_024	1550	MAT_T4_027	1100	COMP_077	125	Siege-grade power
MODULE	MOD_096	Capital Capacitor	4	Power	L	Storage	6500	65.0	395000	5700	MAT_T4_025	1300	MAT_T4_026	950	COMP_078	118	Energy storage 300000 GJ
MODULE	MOD_097	Quantum Power Relay	4	Power	L	Distribution	6000	60.0	365000	5400	MAT_T4_026	1200	MAT_T4_027	880	COMP_079	112	Quantum distribution
MODULE	MOD_098	Titan Reactor	5	Power	Station	Generation	28000	280.0	2800000	12000	MAT_T5_028	5000	MAT_T5_031	3200	COMP_098	350	Titan-class reactor
MODULE	MOD_099	Mega Power Core	5	Power	XL	Generation	24000	240.0	2400000	10800	MAT_T5_029	4500	MAT_T5_032	2900	COMP_099	320	Ultimate power gen
MODULE	MOD_100	Ultimate Capacitor	5	Power	Station	Storage	30000	300.0	3200000	13200	MAT_T5_030	5500	MAT_T5_033	3600	COMP_100	380	Energy storage 1500000 GJ
```

### CARGO & SENSORS

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
MODULE	MOD_101	Basic Cargo Bay	1	Cargo	S	Storage	150	1.5	4000	600	MAT_T1_001	60	MAT_T1_003	40	COMP_005	5	+500 m³ cargo
MODULE	MOD_102	Standard Cargo Bay	1	Cargo	S	Storage	180	1.8	5000	720	MAT_T1_001	75	MAT_T2_008	45	COMP_006	6	+650 m³ cargo
MODULE	MOD_103	Small Ore Hold	1	Cargo	S	Specialized	200	2.0	5500	780	MAT_T1_002	80	MAT_T2_009	50	COMP_007	6	+800 m³ ore only
MODULE	MOD_104	Light Cargo Optimizer	1	Cargo	S	Enhancement	140	1.4	4500	660	MAT_T1_003	55	MAT_T2_013	35	COMP_008	5	+10% cargo capacity
MODULE	MOD_105	Basic Cargo Scanner	1	Cargo	S	Detection	120	1.2	3800	540	MAT_T2_010	50	MAT_T2_013	30	COMP_009	4	Scans cargo 10km
MODULE	MOD_106	Improved Cargo Bay	2	Cargo	M	Storage	650	6.5	18000	1200	MAT_T2_008	170	MAT_T2_010	120	COMP_015	15	+2500 m³ cargo
MODULE	MOD_107	Enhanced Cargo Bay	2	Cargo	M	Storage	750	7.5	22000	1440	MAT_T2_009	200	MAT_T2_010	140	COMP_016	18	+3200 m³ cargo
MODULE	MOD_108	Medium Ore Hold	2	Cargo	M	Specialized	820	8.2	24000	1560	MAT_T2_010	220	MAT_T2_014	150	COMP_017	19	+4000 m³ ore only
MODULE	MOD_109	Medium Gas Hold	2	Cargo	M	Specialized	780	7.8	23000	1500	MAT_T2_009	210	MAT_T2_013	145	COMP_018	18	+3800 m³ gas only
MODULE	MOD_110	Improved Cargo Optimizer	2	Cargo	M	Enhancement	680	6.8	20000	1320	MAT_T2_008	180	MAT_T2_011	125	COMP_019	16	+15% cargo capacity
MODULE	MOD_111	Elite Cargo Bay	3	Cargo	L	Storage	1500	15.0	85000	2640	MAT_T3_016	380	MAT_T3_018	270	COMP_035	38	+10000 m³ cargo
MODULE	MOD_112	Combat Cargo Bay	3	Cargo	M	Storage	1350	13.5	78000	2400	MAT_T3_016	350	MAT_T3_020	250	COMP_036	35	+8500 m³ reinforced
MODULE	MOD_113	Tactical Cargo System	3	Cargo	L	System	1650	16.5	95000	2880	MAT_T3_021	420	MAT_T3_022	300	COMP_037	42	+12000 m³ modular
MODULE	MOD_114	Large Ore Hold	3	Cargo	L	Specialized	1700	17.0	98000	2760	MAT_T3_018	440	MAT_T3_019	310	COMP_038	40	+15000 m³ ore only
MODULE	MOD_115	Large Gas Hold	3	Cargo	L	Specialized	1600	16.0	92000	2700	MAT_T3_016	410	MAT_T3_021	290	COMP_039	39	+14000 m³ gas only
MODULE	MOD_116	Elite Cargo Optimizer	3	Cargo	M	Enhancement	1400	14.0	82000	2520	MAT_T3_020	370	MAT_T3_022	265	COMP_040	36	+22% cargo capacity
MODULE	MOD_117	Compression Module	3	Cargo	L	Compression	1750	17.5	105000	3000	MAT_T3_016	460	MAT_T3_018	330	COMP_041	44	Compresses ore -50% volume
MODULE	MOD_118	Quantum Cargo Bay	4	Cargo	XL	Storage	5200	52.0	330000	5400	MAT_T4_023	1050	MAT_T4_025	750	COMP_070	105	+40000 m³ cargo
MODULE	MOD_119	Capital Cargo Bay	4	Cargo	L	Storage	4600	46.0	295000	4800	MAT_T4_023	920	MAT_T4_026	680	COMP_071	98	+35000 m³ cargo
MODULE	MOD_120	Siege Cargo System	4	Cargo	XL	System	5600	56.0	360000	5700	MAT_T4_024	1150	MAT_T4_027	820	COMP_072	110	+45000 m³ armored
MODULE	MOD_121	Capital Ore Hold	4	Cargo	XL	Specialized	5800	58.0	375000	6000	MAT_T4_025	1200	MAT_T4_026	860	COMP_073	115	+60000 m³ ore only
MODULE	MOD_122	Quantum Cargo Optimizer	4	Cargo	L	Enhancement	4800	48.0	310000	5100	MAT_T4_026	980	MAT_T4_027	710	COMP_074	102	+30% cargo capacity
MODULE	MOD_123	Titan Cargo Bay	5	Cargo	Station	Storage	20000	200.0	2000000	10800	MAT_T5_028	3600	MAT_T5_031	2400	COMP_098	300	+180000 m³ cargo
MODULE	MOD_124	Mega Cargo System	5	Cargo	XL	System	18000	180.0	1800000	9600	MAT_T5_029	3200	MAT_T5_032	2100	COMP_099	280	+160000 m³ modular
MODULE	MOD_125	Ultimate Ore Hold	5	Cargo	Station	Specialized	22000	220.0	2400000	11400	MAT_T5_030	4000	MAT_T5_033	2700	COMP_100	320	+250000 m³ ore only
MODULE	MOD_126	Basic Scanner	1	Sensors	S	Detection	110	1.1	3500	540	MAT_T1_002	45	MAT_T2_013	28	COMP_010	4	Scans 15km radius
MODULE	MOD_127	Standard Sensor Array	1	Sensors	S	Detection	130	1.3	4200	660	MAT_T1_003	55	MAT_T2_013	35	COMP_011	5	Scans 20km radius
MODULE	MOD_128	Small Radar	1	Sensors	S	Tracking	100	1.0	3200	480	MAT_T2_008	40	MAT_T2_009	25	COMP_012	4	Tracks 10 targets
MODULE	MOD_129	Light Analyser	1	Sensors	S	Analysis	120	1.2	3800	600	MAT_T2_010	48	MAT_T2_013	30	COMP_013	4	Material analysis
MODULE	MOD_130	Basic Signal Booster	1	Sensors	S	Amplifier	90	0.9	3000	480	MAT_T1_002	38	MAT_T2_008	23	COMP_014	3	+20% sensor range
MODULE	MOD_131	Improved Scanner	2	Sensors	M	Detection	480	4.8	16000	1200	MAT_T2_008	130	MAT_T2_010	90	COMP_020	14	Scans 50km radius
MODULE	MOD_132	Enhanced Sensor Array	2	Sensors	M	Detection	550	5.5	19000	1380	MAT_T2_009	150	MAT_T2_010	105	COMP_021	16	Scans 65km radius
MODULE	MOD_133	Medium Radar	2	Sensors	M	Tracking	450	4.5	15000	1140	MAT_T2_010	125	MAT_T2_013	85	COMP_022	13	Tracks 30 targets
MODULE	MOD_134	Medium Analyser	2	Sensors	M	Analysis	500	5.0	17000	1260	MAT_T2_008	135	MAT_T2_014	95	COMP_023	15	Advanced analysis
MODULE	MOD_135	Improved Signal Booster	2	Sensors	M	Amplifier	420	4.2	14000	1080	MAT_T2_009	115	MAT_T2_011	80	COMP_024	12	+30% sensor range
MODULE	MOD_136	Elite Scanner	3	Sensors	L	Detection	1100	11.0	72000	2400	MAT_T3_016	290	MAT_T3_018	210	COMP_045	34	Scans 150km radius
MODULE	MOD_137	Combat Sensor Array	3	Sensors	M	Detection	980	9.8	68000	2280	MAT_T3_016	270	MAT_T3_020	195	COMP_046	32	Scans 130km combat
MODULE	MOD_138	Tactical Scanner	3	Sensors	L	Detection	1200	12.0	78000	2640	MAT_T3_021	320	MAT_T3_022	230	COMP_047	36	Scans 180km tactical
MODULE	MOD_139	Heavy Radar	3	Sensors	M	Tracking	1050	10.5	70000	2340	MAT_T3_018	280	MAT_T3_019	205	COMP_048	33	Tracks 80 targets
MODULE	MOD_140	Large Analyser	3	Sensors	L	Analysis	1150	11.5	75000	2520	MAT_T3_016	300	MAT_T3_021	220	COMP_049	35	Deep material scan
MODULE	MOD_141	Elite Signal Booster	3	Sensors	M	Amplifier	1000	10.0	68000	2280	MAT_T3_020	275	MAT_T3_022	200	COMP_050	32	+45% sensor range
MODULE	MOD_142	Quantum Scanner Array	3	Sensors	L	Quantum	1250	12.5	82000	2760	MAT_T3_016	330	MAT_T3_018	240	COMP_051	38	Quantum detection
MODULE	MOD_143	Quantum Scanner	4	Sensors	XL	Detection	4000	40.0	280000	4800	MAT_T4_023	820	MAT_T4_025	600	COMP_080	95	Scans 500km radius
MODULE	MOD_144	Capital Sensor Array	4	Sensors	L	Detection	3600	36.0	255000	4500	MAT_T4_023	750	MAT_T4_026	550	COMP_081	90	Scans 450km radius
MODULE	MOD_145	Siege Scanner	4	Sensors	XL	Detection	4200	42.0	295000	5100	MAT_T4_024	880	MAT_T4_027	640	COMP_082	100	Scans 550km siege
MODULE	MOD_146	Capital Radar	4	Sensors	L	Tracking	3800	38.0	265000	4800	MAT_T4_025	790	MAT_T4_026	580	COMP_083	92	Tracks 250 targets
MODULE	MOD_147	Quantum Signal Booster	4	Sensors	L	Amplifier	3500	35.0	245000	4500	MAT_T4_026	730	MAT_T4_027	540	COMP_084	88	+60% sensor range
MODULE	MOD_148	Titan Scanner	5	Sensors	Station	Detection	16000	160.0	1800000	9600	MAT_T5_028	2900	MAT_T5_031	2000	COMP_098	280	Scans 2000km radius
MODULE	MOD_149	Mega Sensor Array	5	Sensors	XL	Detection	14000	140.0	1600000	8400	MAT_T5_029	2600	MAT_T5_032	1800	COMP_099	260	Scans 1800km radius
MODULE	MOD_150	Ultimate Signal Booster	5	Sensors	Station	Amplifier	18000	180.0	2000000	10800	MAT_T5_030	3300	MAT_T5_033	2200	COMP_100	300	+100% sensor range
```

### ECM & MINING

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
MODULE	MOD_151	Basic ECM Jammer	2	ECM	S	Jamming	180	1.8	12000	900	MAT_T2_008	85	MAT_T2_013	55	COMP_020	8	Jams 1 target
MODULE	MOD_152	Standard ECM Suite	2	ECM	S	Electronic	220	2.2	15000	1080	MAT_T2_009	100	MAT_T2_013	65	COMP_021	9	Multi-spectrum ECM
MODULE	MOD_153	Small Cloaking Device	2	ECM	M	Stealth	450	4.5	28000	1560	MAT_T2_010	180	MAT_T2_014	120	COMP_022	15	Basic cloaking
MODULE	MOD_154	Light Dampener	2	ECM	S	Dampening	200	2.0	13000	960	MAT_T2_008	90	MAT_T2_011	60	COMP_023	8	-30% enemy sensors
MODULE	MOD_155	Basic Target Painter	2	ECM	S	Targeting	190	1.9	12500	920	MAT_T2_009	88	MAT_T2_013	58	COMP_024	8	+25% target signature
MODULE	MOD_156	Improved ECM Jammer	3	ECM	M	Jamming	780	7.8	65000	2280	MAT_T3_016	260	MAT_T3_018	190	COMP_045	30	Jams 3 targets
MODULE	MOD_157	Enhanced ECM Suite	3	ECM	M	Electronic	850	8.5	72000	2520	MAT_T3_016	280	MAT_T3_020	205	COMP_046	32	Advanced ECM warfare
MODULE	MOD_158	Medium Cloaking Device	3	ECM	M	Stealth	950	9.5	78000	2640	MAT_T3_021	310	MAT_T3_022	225	COMP_047	35	Improved cloaking
MODULE	MOD_159	Heavy Dampener	3	ECM	M	Dampening	820	8.2	68000	2400	MAT_T3_018	270	MAT_T3_019	200	COMP_048	31	-50% enemy sensors
MODULE	MOD_160	Elite Target Painter	3	ECM	M	Targeting	800	8.0	66000	2340	MAT_T3_016	265	MAT_T3_021	195	COMP_049	30	+40% target signature
MODULE	MOD_161	Tactical ECM Suite	3	ECM	L	Electronic	1100	11.0	85000	2760	MAT_T3_016	360	MAT_T3_018	260	COMP_050	38	Capital ECM system
MODULE	MOD_162	Warp Disruptor	3	ECM	M	Disruption	880	8.8	75000	2580	MAT_T3_020	290	MAT_T3_022	215	COMP_051	33	Prevents warp
MODULE	MOD_163	Sensor Booster	3	ECM	M	Enhancement	850	8.5	70000	2460	MAT_T3_016	280	MAT_T3_019	210	COMP_052	32	+35% scan resolution
MODULE	MOD_164	Quantum ECM Jammer	4	ECM	L	Jamming	3400	34.0	270000	4800	MAT_T4_023	710	MAT_T4_025	520	COMP_080	88	Jams 10 targets
MODULE	MOD_165	Capital ECM Suite	4	ECM	L	Electronic	3800	38.0	295000	5100	MAT_T4_023	790	MAT_T4_026	580	COMP_081	95	Capital-grade ECM
MODULE	MOD_166	Siege Cloaking Device	4	ECM	XL	Stealth	4200	42.0	320000	5400	MAT_T4_024	870	MAT_T4_027	640	COMP_082	100	Capital cloaking
MODULE	MOD_167	Quantum Dampener	4	ECM	L	Dampening	3600	36.0	280000	4950	MAT_T4_025	750	MAT_T4_026	560	COMP_083	92	-70% enemy sensors
MODULE	MOD_168	Capital Target Painter	4	ECM	L	Targeting	3500	35.0	275000	4800	MAT_T4_026	730	MAT_T4_027	540	COMP_084	90	+60% target signature
MODULE	MOD_169	Titan ECM Suite	5	ECM	Station	Electronic	15000	150.0	1700000	9600	MAT_T5_028	2700	MAT_T5_031	1900	COMP_098	270	Jams 50 targets
MODULE	MOD_170	Mega Cloaking Device	5	ECM	XL	Stealth	17000	170.0	1900000	10200	MAT_T5_029	3000	MAT_T5_032	2100	COMP_099	290	Ultimate cloaking
MODULE	MOD_171	Ultimate ECM System	5	ECM	Station	Electronic	19000	190.0	2100000	10800	MAT_T5_030	3400	MAT_T5_033	2400	COMP_100	310	Total electronic warfare
MODULE	MOD_172	Basic Mining Laser	2	Mining	S	Extraction	250	2.5	15000	1080	MAT_T2_008	95	MAT_T2_009	65	COMP_025	10	Mines 100 kg/min
MODULE	MOD_173	Standard Mining Laser	2	Mining	S	Extraction	280	2.8	17000	1200	MAT_T2_009	110	MAT_T2_010	75	COMP_026	11	Mines 120 kg/min
MODULE	MOD_174	Small Strip Miner	2	Mining	M	Strip	520	5.2	32000	1680	MAT_T2_010	200	MAT_T2_014	140	COMP_027	18	Mines 500 kg/min
MODULE	MOD_175	Light Ore Processor	2	Mining	S	Processing	300	3.0	18000	1260	MAT_T2_008	115	MAT_T2_013	80	COMP_028	12	+10% ore yield
MODULE	MOD_176	Basic Ice Harvester	2	Mining	M	Ice	480	4.8	28000	1560	MAT_T2_009	185	MAT_T2_014	130	COMP_029	16	Ice extraction
MODULE	MOD_177	Improved Mining Laser	3	Mining	M	Extraction	920	9.2	75000	2520	MAT_T3_016	300	MAT_T3_018	220	COMP_055	33	Mines 500 kg/min
MODULE	MOD_178	Enhanced Mining Laser	3	Mining	M	Extraction	1000	10.0	82000	2700	MAT_T3_016	330	MAT_T3_020	240	COMP_056	36	Mines 600 kg/min
MODULE	MOD_179	Medium Strip Miner	3	Mining	L	Strip	1450	14.5	105000	2880	MAT_T3_021	480	MAT_T3_022	340	COMP_057	45	Mines 2000 kg/min
MODULE	MOD_180	Heavy Ore Processor	3	Mining	M	Processing	950	9.5	78000	2580	MAT_T3_018	310	MAT_T3_019	230	COMP_058	34	+18% ore yield
MODULE	MOD_181	Elite Ice Harvester	3	Mining	L	Ice	1350	13.5	98000	2760	MAT_T3_016	440	MAT_T3_021	320	COMP_059	42	Advanced ice mining
MODULE	MOD_182	Deep Core Miner	3	Mining	L	Deep Core	1500	15.0	110000	3000	MAT_T3_016	490	MAT_T3_018	360	COMP_060	46	Deep asteroid mining
MODULE	MOD_183	Gas Harvester	3	Mining	M	Gas	1100	11.0	88000	2640	MAT_T3_020	360	MAT_T3_022	265	COMP_061	38	Gas cloud mining
MODULE	MOD_184	Quantum Mining Laser	4	Mining	L	Extraction	4100	41.0	310000	5100	MAT_T4_023	850	MAT_T4_025	630	COMP_085	98	Mines 2500 kg/min
MODULE	MOD_185	Capital Strip Miner	4	Mining	XL	Strip	5600	56.0	385000	5700	MAT_T4_024	1150	MAT_T4_027	850	COMP_086	115	Mines 10000 kg/min
MODULE	MOD_186	Siege Ore Processor	4	Mining	L	Processing	4300	43.0	325000	5250	MAT_T4_025	890	MAT_T4_026	660	COMP_087	102	+28% ore yield
MODULE	MOD_187	Capital Ice Harvester	4	Mining	XL	Ice	5200	52.0	365000	5550	MAT_T4_023	1080	MAT_T4_027	800	COMP_088	110	Industrial ice mining
MODULE	MOD_188	Quantum Gas Harvester	4	Mining	L	Gas	4500	45.0	340000	5400	MAT_T4_026	930	MAT_T4_027	690	COMP_089	105	Advanced gas extraction
MODULE	MOD_189	Titan Mining Laser	5	Mining	XL	Extraction	18000	180.0	1900000	10200	MAT_T5_028	3200	MAT_T5_031	2200	COMP_098	290	Mines 12000 kg/min
MODULE	MOD_190	Mega Strip Miner	5	Mining	Station	Strip	22000	220.0	2300000	11400	MAT_T5_029	4000	MAT_T5_032	2700	COMP_099	330	Mines 50000 kg/min
MODULE	MOD_191	Ultimate Ore Processor	5	Mining	XL	Processing	20000	200.0	2100000	10800	MAT_T5_030	3600	MAT_T5_033	2500	COMP_100	310	+40% ore yield
MODULE	MOD_192	Anomaly Extractor	5	Mining	Station	Exotic	24000	240.0	2600000	12000	MAT_T5_031	4400	MAT_T5_033	3000	COMP_100	350	Extracts anomaly materials
MODULE	MOD_193	Void Harvester	5	Mining	XL	Void	21000	210.0	2400000	11400	MAT_T5_032	3800	MAT_T5_031	2800	COMP_099	320	Void material extraction
MODULE	MOD_194	Quantum Refinery Module	5	Mining	Station	Refinery	25000	250.0	2800000	12600	MAT_T5_028	4600	MAT_T5_030	3200	COMP_098	360	On-board refining
MODULE	MOD_195	Mining Drone Bay	3	Mining	L	Drones	1200	12.0	92000	2700	MAT_T3_016	390	MAT_T3_021	290	COMP_062	40	Launches mining drones
MODULE	MOD_196	Survey Scanner Module	2	Mining	M	Survey	420	4.2	24000	1440	MAT_T2_010	160	MAT_T2_013	110	COMP_030	14	Surveys asteroid belts
MODULE	MOD_197	Ore Compression Module	3	Mining	L	Compression	1400	14.0	100000	2880	MAT_T3_018	460	MAT_T3_019	340	COMP_063	43	Compresses ore 70%
MODULE	MOD_198	Mining Foreman Link	4	Mining	L	Fleet	3900	39.0	305000	5100	MAT_T4_025	810	MAT_T4_026	600	COMP_090	96	Mining fleet bonus
MODULE	MOD_199	Industrial Core	4	Mining	XL	Industrial	5400	54.0	375000	5700	MAT_T4_023	1120	MAT_T4_027	830	COMP_091	112	Siege mode mining
MODULE	MOD_200	Mining Command Burst	5	Mining	Station	Command	19000	190.0	2000000	10800	MAT_T5_029	3400	MAT_T5_032	2400	COMP_099	300	Fleet-wide mining buff
```

### COMMAND & MEDICAL

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
MODULE	MOD_201	Basic Command Center	2	Command	M	Control	550	5.5	32000	1680	MAT_T2_008	210	MAT_T2_013	145	COMP_030	18	Commands 5 ships
MODULE	MOD_202	Standard Fleet Link	2	Command	M	Network	500	5.0	28000	1560	MAT_T2_009	190	MAT_T2_013	135	COMP_031	16	Fleet coordination
MODULE	MOD_203	Small Command Burst	2	Command	S	Buff	380	3.8	22000	1320	MAT_T2_010	150	MAT_T2_014	105	COMP_032	14	+10% fleet damage
MODULE	MOD_204	Light Wing Commander	2	Command	M	Wing	520	5.2	30000	1620	MAT_T2_008	200	MAT_T2_011	140	COMP_033	17	Commands wing 10 ships
MODULE	MOD_205	Basic Tactical Link	2	Command	M	Tactical	480	4.8	26000	1500	MAT_T2_010	185	MAT_T2_013	130	COMP_034	15	Tactical commands
MODULE	MOD_206	Improved Command Center	3	Command	L	Control	1350	13.5	95000	2760	MAT_T3_016	440	MAT_T3_018	320	COMP_055	42	Commands 15 ships
MODULE	MOD_207	Enhanced Fleet Link	3	Command	M	Network	1200	12.0	88000	2640	MAT_T3_016	400	MAT_T3_020	295	COMP_056	39	Advanced coordination
MODULE	MOD_208	Medium Command Burst	3	Command	M	Buff	1100	11.0	82000	2520	MAT_T3_021	360	MAT_T3_022	270	COMP_057	37	+18% fleet damage
MODULE	MOD_209	Heavy Wing Commander	3	Command	L	Wing	1400	14.0	98000	2820	MAT_T3_018	460	MAT_T3_019	340	COMP_058	43	Commands wing 25 ships
MODULE	MOD_210	Elite Tactical Link	3	Command	M	Tactical	1250	12.5	90000	2700	MAT_T3_016	420	MAT_T3_021	310	COMP_059	40	Advanced tactics
MODULE	MOD_211	Fleet Command Module	3	Command	L	Fleet	1500	15.0	105000	3000	MAT_T3_016	490	MAT_T3_018	360	COMP_060	45	Full fleet control
MODULE	MOD_212	Squadron Leader Module	3	Command	M	Squadron	1300	13.0	92000	2760	MAT_T3_020	430	MAT_T3_022	320	COMP_061	41	Squadron tactics
MODULE	MOD_213	Quantum Command Center	4	Command	XL	Control	5000	50.0	360000	5700	MAT_T4_023	1040	MAT_T4_025	770	COMP_090	108	Commands 50 ships
MODULE	MOD_214	Capital Fleet Link	4	Command	L	Network	4500	45.0	330000	5400	MAT_T4_023	940	MAT_T4_026	700	COMP_091	102	Capital coordination
MODULE	MOD_215	Siege Command Burst	4	Command	L	Buff	4200	42.0	310000	5100	MAT_T4_024	870	MAT_T4_027	650	COMP_092	98	+30% fleet damage
MODULE	MOD_216	Capital Wing Commander	4	Command	XL	Wing	5200	52.0	370000	5850	MAT_T4_025	1080	MAT_T4_026	800	COMP_093	112	Commands wing 100 ships
MODULE	MOD_217	Quantum Tactical Link	4	Command	L	Tactical	4800	48.0	345000	5550	MAT_T4_026	1000	MAT_T4_027	740	COMP_094	105	Quantum tactics
MODULE	MOD_218	Titan Command Center	5	Command	Station	Control	20000	200.0	2100000	10800	MAT_T5_028	3600	MAT_T5_031	2500	COMP_098	310	Commands 250 ships
MODULE	MOD_219	Mega Fleet Link	5	Command	XL	Network	18000	180.0	1900000	10200	MAT_T5_029	3200	MAT_T5_032	2300	COMP_099	290	Fleet-wide network
MODULE	MOD_220	Ultimate Command Burst	5	Command	Station	Buff	22000	220.0	2400000	11400	MAT_T5_030	4000	MAT_T5_033	2800	COMP_100	330	+50% fleet all stats
MODULE	MOD_221	Strategic Command Suite	5	Command	Station	Strategic	24000	240.0	2600000	12000	MAT_T5_031	4300	MAT_T5_028	3100	COMP_098	350	Strategic fleet control
MODULE	MOD_222	Armada Controller	5	Command	XL	Armada	21000	210.0	2300000	11400	MAT_T5_032	3800	MAT_T5_029	2700	COMP_099	320	Controls entire armada
MODULE	MOD_223	Basic Medical Bay	1	Medical	S	Treatment	200	2.0	5500	720	MAT_T1_001	75	MAT_T2_015	50	COMP_005	6	Treats 5 crew
MODULE	MOD_224	Standard Infirmary	1	Medical	M	Treatment	420	4.2	12000	1080	MAT_T1_001	140	MAT_T2_015	95	COMP_006	10	Treats 15 crew
MODULE	MOD_225	Small Clone Bay	2	Medical	M	Clone	650	6.5	28000	1560	MAT_T2_008	200	MAT_T2_015	140	COMP_020	16	Clone resurrection
MODULE	MOD_226	Light Life Support	1	Medical	S	Life Support	180	1.8	5000	660	MAT_T1_003	70	MAT_T2_009	45	COMP_007	5	Supports 20 crew
MODULE	MOD_227	Basic Crew Quarters	1	Medical	M	Quarters	350	3.5	10000	960	MAT_T1_001	120	MAT_T2_014	80	COMP_008	8	Houses 30 crew
MODULE	MOD_228	Improved Medical Bay	2	Medical	M	Treatment	720	7.2	35000	1800	MAT_T2_008	220	MAT_T2_015	155	COMP_025	19	Treats 40 crew
MODULE	MOD_229	Enhanced Infirmary	2	Medical	M	Treatment	800	8.0	40000	1980	MAT_T2_009	250	MAT_T2_015	175	COMP_026	21	Advanced treatment
MODULE	MOD_230	Medium Clone Bay	2	Medical	L	Clone	1100	11.0	55000	2280	MAT_T2_010	350	MAT_T2_015	245	COMP_027	26	Fast cloning
MODULE	MOD_231	Improved Life Support	2	Medical	M	Life Support	680	6.8	32000	1680	MAT_T2_008	210	MAT_T2_013	150	COMP_028	18	Supports 80 crew
MODULE	MOD_232	Enhanced Crew Quarters	2	Medical	M	Quarters	750	7.5	38000	1860	MAT_T2_009	230	MAT_T2_014	165	COMP_029	20	Houses 100 crew
MODULE	MOD_233	Elite Medical Bay	3	Medical	L	Treatment	1500	15.0	105000	3000	MAT_T3_016	490	MAT_T3_019	360	COMP_055	45	Treats 120 crew
MODULE	MOD_234	Combat Infirmary	3	Medical	M	Treatment	1350	13.5	95000	2820	MAT_T3_016	440	MAT_T3_020	325	COMP_056	42	Combat medical
MODULE	MOD_235	Large Clone Bay	3	Medical	L	Clone	1800	18.0	125000	3240	MAT_T3_021	590	MAT_T3_022	435	COMP_057	52	Advanced cloning
MODULE	MOD_236	Heavy Life Support	3	Medical	L	Life Support	1400	14.0	98000	2880	MAT_T3_018	460	MAT_T3_019	340	COMP_058	43	Supports 300 crew
MODULE	MOD_237	Elite Crew Quarters	3	Medical	L	Quarters	1600	16.0	110000	3120	MAT_T3_016	520	MAT_T3_021	385	COMP_059	48	Houses 400 crew
MODULE	MOD_238	Quantum Medical Bay	4	Medical	XL	Treatment	5500	55.0	380000	5850	MAT_T4_023	1140	MAT_T4_025	840	COMP_090	115	Treats 500 crew
MODULE	MOD_239	Capital Clone Bay	4	Medical	XL	Clone	6200	62.0	425000	6300	MAT_T4_024	1280	MAT_T4_027	950	COMP_091	125	Capital cloning
MODULE	MOD_240	Siege Life Support	4	Medical	L	Life Support	5000	50.0	360000	5700	MAT_T4_025	1040	MAT_T4_026	770	COMP_092	108	Supports 1200 crew
MODULE	MOD_241	Capital Crew Quarters	4	Medical	XL	Quarters	5800	58.0	405000	6150	MAT_T4_023	1200	MAT_T4_027	890	COMP_093	118	Houses 2000 crew
MODULE	MOD_242	Titan Medical Complex	5	Medical	Station	Treatment	22000	220.0	2400000	11400	MAT_T5_028	4000	MAT_T5_031	2800	COMP_098	330	Treats 2500 crew
MODULE	MOD_243	Mega Clone Facility	5	Medical	Station	Clone	25000	250.0	2700000	12000	MAT_T5_029	4500	MAT_T5_032	3200	COMP_099	360	Mass cloning facility
MODULE	MOD_244	Ultimate Life Support	5	Medical	Station	Life Support	23000	230.0	2500000	11700	MAT_T5_030	4200	MAT_T5_033	3000	COMP_100	340	Supports 6000 crew
MODULE	MOD_245	Mega Crew Complex	5	Medical	Station	Quarters	24000	240.0	2600000	12000	MAT_T5_031	4300	MAT_T5_028	3100	COMP_098	350	Houses 8000 crew
MODULE	MOD_246	Research Laboratory	3	Medical	L	Research	1700	17.0	120000	3180	MAT_T3_016	560	MAT_T3_018	410	COMP_060	50	Medical research
MODULE	MOD_247	Cryogenic Storage	3	Medical	M	Cryo	1250	12.5	88000	2700	MAT_T3_020	410	MAT_T3_022	305	COMP_061	39	Crew cryosleep
MODULE	MOD_248	Emergency Medical System	2	Medical	M	Emergency	580	5.8	30000	1620	MAT_T2_010	180	MAT_T2_015	130	COMP_030	15	Fast emergency care
MODULE	MOD_249	Genetic Modifier Bay	4	Medical	L	Genetic	4600	46.0	335000	5400	MAT_T4_025	960	MAT_T4_026	710	COMP_094	102	Crew enhancement
MODULE	MOD_250	Neural Interface Center	5	Medical	XL	Neural	20000	200.0	2200000	10800	MAT_T5_032	3600	MAT_T5_033	2600	COMP_099	310	Brain-ship interface
```

### UTILITY & STATION

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
MODULE	MOD_251	Basic Repair Module	2	Utility	M	Repair	480	4.8	26000	1500	MAT_T2_008	185	MAT_T2_013	130	COMP_030	15	Repairs 150 HP/s
MODULE	MOD_252	Standard Tractor Beam	2	Utility	S	Tractor	320	3.2	18000	1200	MAT_T2_009	125	MAT_T2_013	90	COMP_031	12	Pulls objects 5km
MODULE	MOD_253	Small Salvager	2	Utility	M	Salvage	420	4.2	24000	1380	MAT_T2_010	160	MAT_T2_014	115	COMP_032	14	Salvages wrecks
MODULE	MOD_254	Light Probe Launcher	2	Utility	S	Probe	280	2.8	15000	1080	MAT_T2_008	110	MAT_T2_009	75	COMP_033	11	Launches scan probes
MODULE	MOD_255	Basic Remote Repairer	2	Utility	M	Remote	450	4.5	25000	1440	MAT_T2_010	170	MAT_T2_013	120	COMP_034	14	Remote repairs 100 HP/s
MODULE	MOD_256	Improved Repair Module	3	Utility	L	Repair	1250	12.5	88000	2700	MAT_T3_016	410	MAT_T3_018	305	COMP_055	40	Repairs 600 HP/s
MODULE	MOD_257	Enhanced Tractor Beam	3	Utility	M	Tractor	950	9.5	72000	2520	MAT_T3_016	310	MAT_T3_020	230	COMP_056	35	Pulls objects 15km
MODULE	MOD_258	Medium Salvager	3	Utility	L	Salvage	1350	13.5	95000	2820	MAT_T3_021	440	MAT_T3_022	325	COMP_057	42	Advanced salvage
MODULE	MOD_259	Heavy Probe Launcher	3	Utility	M	Probe	1050	10.5	78000	2580	MAT_T3_018	345	MAT_T3_019	255	COMP_058	37	Launches combat probes
MODULE	MOD_260	Elite Remote Repairer	3	Utility	L	Remote	1400	14.0	98000	2880	MAT_T3_016	460	MAT_T3_021	340	COMP_059	43	Remote repairs 400 HP/s
MODULE	MOD_261	Energy Neutralizer	3	Utility	M	Neutralizer	1100	11.0	82000	2640	MAT_T3_020	360	MAT_T3_022	270	COMP_060	38	Drains enemy capacitor
MODULE	MOD_262	Energy Vampire	3	Utility	M	Vampire	1200	12.0	88000	2760	MAT_T3_016	390	MAT_T3_018	290	COMP_061	40	Steals enemy energy
MODULE	MOD_263	Quantum Repair Module	4	Utility	XL	Repair	4800	48.0	340000	5550	MAT_T4_023	1000	MAT_T4_025	740	COMP_090	105	Repairs 2500 HP/s
MODULE	MOD_264	Capital Tractor Beam	4	Utility	L	Tractor	3800	38.0	280000	4950	MAT_T4_023	790	MAT_T4_026	590	COMP_091	95	Pulls objects 50km
MODULE	MOD_265	Siege Salvager	4	Utility	XL	Salvage	5200	52.0	365000	5850	MAT_T4_024	1080	MAT_T4_027	800	COMP_092	112	Capital salvage
MODULE	MOD_266	Capital Remote Repairer	4	Utility	L	Remote	5000	50.0	355000	5700	MAT_T4_025	1040	MAT_T4_026	770	COMP_093	108	Remote repairs 1800 HP/s
MODULE	MOD_267	Quantum Neutralizer	4	Utility	L	Neutralizer	4500	45.0	330000	5400	MAT_T4_026	940	MAT_T4_027	700	COMP_094	102	Massive energy drain
MODULE	MOD_268	Titan Repair Module	5	Utility	Station	Repair	20000	200.0	2200000	10800	MAT_T5_028	3600	MAT_T5_031	2600	COMP_098	310	Repairs 10000 HP/s
MODULE	MOD_269	Mega Tractor Beam	5	Utility	XL	Tractor	18000	180.0	2000000	10200	MAT_T5_029	3200	MAT_T5_032	2300	COMP_099	290	Pulls objects 200km
MODULE	MOD_270	Ultimate Salvager	5	Utility	Station	Salvage	22000	220.0	2400000	11400	MAT_T5_030	4000	MAT_T5_033	2800	COMP_100	330	Complete wreck salvage
MODULE	MOD_271	Mega Remote Repairer	5	Utility	Station	Remote	21000	210.0	2300000	11100	MAT_T5_031	3800	MAT_T5_028	2700	COMP_098	320	Remote repairs 8000 HP/s
MODULE	MOD_272	Corporate Hangar Array	3	Station	L	Hangar	2200	22.0	150000	3600	MAT_T3_016	720	MAT_T3_018	530	COMP_062	62	Corp hangar access
MODULE	MOD_273	Manufacturing Array	3	Station	L	Production	2400	24.0	165000	3840	MAT_T3_021	790	MAT_T3_022	580	COMP_063	68	Ship manufacturing
MODULE	MOD_274	Research Laboratory	3	Station	L	Research	2100	21.0	145000	3480	MAT_T3_018	690	MAT_T3_019	510	COMP_064	60	Research facility
MODULE	MOD_275	Refinery Complex	3	Station	L	Refinery	2500	25.0	170000	3960	MAT_T3_016	820	MAT_T3_021	600	COMP_065	70	Ore refining
MODULE	MOD_276	Market Hub	4	Station	XL	Market	7500	75.0	520000	7200	MAT_T4_023	1550	MAT_T4_025	1150	COMP_095	145	Trading hub
MODULE	MOD_277	Defense Battery	4	Station	XL	Defense	8200	82.0	570000	7800	MAT_T4_024	1700	MAT_T4_027	1260	COMP_096	158	Station defenses
MODULE	MOD_278	Docking Bay	4	Station	XL	Docking	7800	78.0	540000	7500	MAT_T4_025	1610	MAT_T4_026	1200	COMP_097	150	Ships docking
MODULE	MOD_279	Cloning Facility	4	Station	L	Clone	6800	68.0	475000	6900	MAT_T4_023	1410	MAT_T4_027	1050	COMP_098	138	Mass cloning
MODULE	MOD_280	Mega Manufacturing Complex	5	Station	Station	Production	32000	320.0	3500000	14400	MAT_T5_028	5800	MAT_T5_031	4000	COMP_098	420	Capital ship production
MODULE	MOD_281	Titan Research Facility	5	Station	Station	Research	30000	300.0	3300000	13800	MAT_T5_029	5400	MAT_T5_032	3800	COMP_099	400	Advanced research
MODULE	MOD_282	Ultimate Refinery	5	Station	Station	Refinery	34000	340.0	3700000	15000	MAT_T5_030	6200	MAT_T5_033	4300	COMP_100	440	Perfect refining
MODULE	MOD_283	Mega Market Hub	5	Station	Station	Market	28000	280.0	3100000	13200	MAT_T5_031	5000	MAT_T5_028	3600	COMP_098	380	System-wide trading
MODULE	MOD_284	Fortress Defense Grid	5	Station	Station	Defense	36000	360.0	4000000	15600	MAT_T5_032	6600	MAT_T5_029	4600	COMP_099	460	Impenetrable defenses
MODULE	MOD_285	Capital Shipyard	5	Station	Station	Shipyard	38000	380.0	4200000	16200	MAT_T5_033	7000	MAT_T5_030	4900	COMP_100	480	Builds titans
MODULE	MOD_286	Banking Vault	4	Station	L	Banking	6500	65.0	455000	6600	MAT_T4_026	1350	MAT_T4_027	1000	COMP_099	135	Secure storage
MODULE	MOD_287	Station Jump Gate	5	Station	Station	Gate	40000	400.0	4500000	16800	MAT_T5_031	7400	MAT_T5_033	5200	COMP_100	500	Instant system jump
MODULE	MOD_288	Cynosural Field Gen	3	Utility	M	Cyno	1150	11.5	85000	2760	MAT_T3_016	380	MAT_T3_018	280	COMP_066	39	Capital jump beacon
MODULE	MOD_289	Jump Drive	4	Utility	XL	Jump	5500	55.0	385000	5850	MAT_T4_024	1140	MAT_T4_027	850	COMP_100	115	Capital jump drive
MODULE	MOD_290	Stasis Webifier	2	Utility	S	Web	340	3.4	19000	1260	MAT_T2_010	130	MAT_T2_013	95	COMP_035	12	Slows targets 60%
MODULE	MOD_291	Warp Scrambler	3	Utility	M	Scrambler	1000	10.0	75000	2520	MAT_T3_016	330	MAT_T3_020	245	COMP_067	36	Prevents warp 20km
MODULE	MOD_292	Siege Module	4	Utility	XL	Siege	6000	60.0	420000	6300	MAT_T4_023	1240	MAT_T4_025	920	COMP_100	122	Siege mode 5min
MODULE	MOD_293	Triage Module	4	Utility	L	Triage	5500	55.0	390000	6000	MAT_T4_026	1140	MAT_T4_027	850	COMP_099	118	Massive remote repairs
MODULE	MOD_294	Burst Projector	3	Utility	M	Projector	1100	11.0	82000	2640	MAT_T3_018	360	MAT_T3_019	270	COMP_068	38	Area effect weapon
MODULE	MOD_295	Bomb Launcher	3	Utility	M	Bomb	1200	12.0	88000	2760	MAT_T3_021	390	MAT_T3_022	290	COMP_069	40	Launches bombs
MODULE	MOD_296	Micro Jump Drive	3	Utility	M	MJD	1050	10.5	78000	2580	MAT_T3_016	345	MAT_T3_020	255	COMP_070	37	100km instant jump
MODULE	MOD_297	Command Processor	4	Utility	L	Processor	4700	47.0	340000	5550	MAT_T4_025	980	MAT_T4_026	730	COMP_100	105	Fleet command boost
MODULE	MOD_298	Entosis Link	3	Utility	M	Entosis	980	9.8	72000	2460	MAT_T3_020	320	MAT_T3_022	240	COMP_071	35	Structure capture
MODULE	MOD_299	Drone Link Augmentor	2	Utility	S	Drone Link	380	3.8	21000	1320	MAT_T2_010	145	MAT_T2_013	105	COMP_036	13	+30km drone range
MODULE	MOD_300	Ultimate Utility Core	5	Utility	Station	Core	35000	350.0	3800000	15300	MAT_T5_030	6400	MAT_T5_033	4500	COMP_100	450	All utilities integrated
```

---

## SHIPS

### FRIGATES & DESTROYERS

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
SHIP	SHIP_001	Sparrow Scout	1	Frigate	S	Scout	5000	500	50000	3600	MAT_T1_001	1000	MAT_T1_002	600	COMP_005	20	Fast exploration frigate
SHIP	SHIP_002	Falcon Interceptor	1	Frigate	S	Interceptor	5200	520	55000	3840	MAT_T1_001	1100	MAT_T2_008	650	COMP_006	22	High-speed combat
SHIP	SHIP_003	Hawk Combat	1	Frigate	S	Combat	5500	550	60000	4080	MAT_T1_001	1200	MAT_T2_009	700	COMP_007	24	Basic combat frigate
SHIP	SHIP_004	Eagle Assault	2	Frigate	S	Assault	6000	600	75000	4320	MAT_T2_008	1400	MAT_T2_010	850	COMP_015	28	Assault frigate
SHIP	SHIP_005	Raven Stealth	2	Frigate	S	Stealth	5800	580	72000	4200	MAT_T2_008	1350	MAT_T2_013	800	COMP_016	26	Cloaking capable
SHIP	SHIP_006	Condor Electronic	2	Frigate	S	Electronic	5600	560	68000	4080	MAT_T2_009	1300	MAT_T2_013	780	COMP_017	25	ECM frigate
SHIP	SHIP_007	Viper Logistics	2	Frigate	S	Logistics	5900	590	73000	4260	MAT_T2_010	1380	MAT_T2_014	820	COMP_018	27	Remote repair frigate
SHIP	SHIP_008	Merlin Tackle	1	Frigate	S	Tackle	5300	530	57000	3960	MAT_T1_001	1150	MAT_T2_009	680	COMP_008	23	Warp disruptor focused
SHIP	SHIP_009	Kestrel Missile	2	Frigate	S	Missile	6100	610	77000	4380	MAT_T2_008	1420	MAT_T2_015	860	COMP_019	29	Missile frigate
SHIP	SHIP_010	Phoenix Mining	1	Frigate	S	Mining	5400	540	58000	4020	MAT_T1_001	1180	MAT_T2_010	700	COMP_009	23	Entry mining frigate
SHIP	SHIP_011	Osprey Hauler	1	Frigate	S	Transport	5700	570	62000	4140	MAT_T1_001	1250	MAT_T2_008	740	COMP_010	24	Cargo frigate 8000m³
SHIP	SHIP_012	Swift Runner	3	Frigate	S	Speed	6500	650	95000	4800	MAT_T3_016	1600	MAT_T3_018	1000	COMP_035	35	Fastest frigate
SHIP	SHIP_013	Razor Interceptor	3	Frigate	S	Interceptor	6400	640	92000	4680	MAT_T3_016	1580	MAT_T3_020	980	COMP_036	34	Elite interception
SHIP	SHIP_014	Talon Assault	3	Frigate	S	Assault	6800	680	102000	5040	MAT_T3_021	1700	MAT_T3_022	1050	COMP_037	37	Heavy assault frigate
SHIP	SHIP_015	Ghost Stealth	4	Frigate	S	Stealth	7200	720	135000	5640	MAT_T4_023	1900	MAT_T4_025	1200	COMP_065	45	Advanced cloaking
SHIP	SHIP_016	Phantom Scout	4	Frigate	S	Scout	7000	700	128000	5520	MAT_T4_023	1850	MAT_T4_026	1150	COMP_066	43	Deep space scout
SHIP	SHIP_017	Wraith Electronic	4	Frigate	S	Electronic	7100	710	132000	5580	MAT_T4_024	1880	MAT_T4_027	1180	COMP_067	44	Advanced ECM
SHIP	SHIP_018	Spectre Logistics	3	Frigate	S	Logistics	6600	660	98000	4920	MAT_T3_018	1650	MAT_T3_019	1020	COMP_038	36	Elite repair frigate
SHIP	SHIP_019	Banshee Command	4	Frigate	S	Command	7300	730	138000	5700	MAT_T4_025	1920	MAT_T4_026	1210	COMP_068	46	Command frigate
SHIP	SHIP_020	Nova Interceptor	5	Frigate	S	Interceptor	8000	800	225000	6600	MAT_T5_028	2400	MAT_T5_031	1600	COMP_098	60	Ultimate speed
SHIP	SHIP_021	Sentinel Guardian	1	Destroyer	M	Defense	12000	1200	150000	5400	MAT_T1_001	2200	MAT_T2_008	1400	COMP_011	35	Entry destroyer
SHIP	SHIP_022	Guardian Defender	1	Destroyer	M	Defense	12500	1250	160000	5640	MAT_T1_001	2350	MAT_T2_009	1500	COMP_012	38	Basic defense
SHIP	SHIP_023	Warden Patrol	2	Destroyer	M	Patrol	13000	1300	180000	5880	MAT_T2_008	2600	MAT_T2_010	1700	COMP_020	42	Patrol destroyer
SHIP	SHIP_024	Lancer Strike	2	Destroyer	M	Strike	13500	1350	195000	6120	MAT_T2_009	2750	MAT_T2_010	1800	COMP_021	45	Strike capability
SHIP	SHIP_025	Claymore Heavy	2	Destroyer	M	Heavy	14000	1400	210000	6360	MAT_T2_010	2900	MAT_T2_014	1900	COMP_022	48	Heavy destroyer
SHIP	SHIP_026	Rapier Interdictor	2	Destroyer	M	Interdictor	13200	1320	185000	6000	MAT_T2_008	2650	MAT_T2_013	1750	COMP_023	43	Warp interdiction
SHIP	SHIP_027	Scimitar Logistics	2	Destroyer	M	Logistics	13400	1340	190000	6060	MAT_T2_009	2700	MAT_T2_015	1780	COMP_024	44	Repair destroyer
SHIP	SHIP_028	Broadsword Command	3	Destroyer	M	Command	14500	1450	230000	6600	MAT_T3_016	3100	MAT_T3_018	2100	COMP_040	52	Command destroyer
SHIP	SHIP_029	Halberd Assault	3	Destroyer	M	Assault	15000	1500	245000	6840	MAT_T3_016	3250	MAT_T3_020	2200	COMP_041	55	Assault destroyer
SHIP	SHIP_030	Javelin Missile	3	Destroyer	M	Missile	14800	1480	240000	6720	MAT_T3_021	3200	MAT_T3_022	2150	COMP_042	54	Missile platform
SHIP	SHIP_031	Corsair Pirate	3	Destroyer	M	Pirate	14200	1420	220000	6480	MAT_T3_018	3000	MAT_T3_019	2000	COMP_043	50	Pirate destroyer
SHIP	SHIP_032	Phantom Stealth	3	Destroyer	M	Stealth	14600	1460	235000	6600	MAT_T3_016	3150	MAT_T3_021	2120	COMP_044	53	Cloaked destroyer
SHIP	SHIP_033	Paladin Defense	4	Destroyer	M	Defense	15500	1550	285000	7200	MAT_T4_023	3600	MAT_T4_025	2500	COMP_070	65	Heavy defense
SHIP	SHIP_034	Champion Combat	4	Destroyer	M	Combat	16000	1600	300000	7440	MAT_T4_023	3750	MAT_T4_026	2600	COMP_071	68	Elite combat
SHIP	SHIP_035	Crusader Strike	4	Destroyer	M	Strike	15800	1580	295000	7320	MAT_T4_024	3700	MAT_T4_027	2550	COMP_072	67	Advanced strike
SHIP	SHIP_036	Templar Assault	4	Destroyer	M	Assault	16200	1620	310000	7560	MAT_T4_025	3800	MAT_T4_026	2650	COMP_073	70	Heavy assault
SHIP	SHIP_037	Executioner Electronic	4	Destroyer	M	Electronic	15600	1560	290000	7260	MAT_T4_026	3650	MAT_T4_027	2520	COMP_074	66	Advanced ECM
SHIP	SHIP_038	Reaper Interdictor	4	Destroyer	M	Interdictor	15900	1590	298000	7380	MAT_T4_023	3720	MAT_T4_027	2580	COMP_075	68	Heavy interdiction
SHIP	SHIP_039	Angel Logistics	3	Destroyer	M	Logistics	14400	1440	225000	6540	MAT_T3_020	3050	MAT_T3_022	2050	COMP_045	51	Advanced repair
SHIP	SHIP_040	Titan Destroyer	5	Destroyer	M	Ultimate	18000	1800	420000	8400	MAT_T5_028	4500	MAT_T5_031	3200	COMP_098	90	Ultimate destroyer
```

### CRUISERS & BATTLECRUISERS

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
SHIP	SHIP_041	Voyager Explorer	2	Cruiser	M	Explorer	18000	1800	200000	6600	MAT_T2_008	3500	MAT_T2_010	2400	COMP_025	55	Exploration cruiser
SHIP	SHIP_042	Pathfinder Scout	2	Cruiser	M	Scout	18500	1850	215000	6840	MAT_T2_009	3650	MAT_T2_010	2500	COMP_026	58	Deep space scout
SHIP	SHIP_043	Pioneer Mining	2	Cruiser	M	Mining	19000	1900	230000	7080	MAT_T2_010	3800	MAT_T2_014	2600	COMP_027	60	Mining cruiser
SHIP	SHIP_044	Crusader Combat	2	Cruiser	M	Combat	19500	1950	245000	7320	MAT_T2_008	3950	MAT_T2_010	2700	COMP_028	63	Combat cruiser
SHIP	SHIP_045	Templar Assault	3	Cruiser	L	Assault	22000	2200	320000	7920	MAT_T3_016	4800	MAT_T3_018	3400	COMP_045	75	Heavy assault
SHIP	SHIP_046	Centurion Heavy	3	Cruiser	L	Heavy	23000	2300	350000	8160	MAT_T3_016	5000	MAT_T3_020	3600	COMP_046	80	Heavy cruiser
SHIP	SHIP_047	Gladiator Combat	3	Cruiser	M	Combat	21000	2100	305000	7680	MAT_T3_021	4600	MAT_T3_022	3300	COMP_047	72	Elite combat
SHIP	SHIP_048	Praetorian Defense	3	Cruiser	L	Defense	22500	2250	335000	8040	MAT_T3_018	4900	MAT_T3_019	3500	COMP_048	77	Tank cruiser
SHIP	SHIP_049	Recon Stealth	3	Cruiser	M	Stealth	20500	2050	295000	7560	MAT_T3_016	4500	MAT_T3_021	3200	COMP_049	70	Covert ops
SHIP	SHIP_050	Force Recon	3	Cruiser	M	Recon	21500	2150	315000	7800	MAT_T3_020	4700	MAT_T3_022	3350	COMP_050	74	Combat recon
SHIP	SHIP_051	Harbinger Missile	3	Cruiser	L	Missile	23500	2350	365000	8280	MAT_T3_016	5100	MAT_T3_018	3700	COMP_051	82	Missile cruiser
SHIP	SHIP_052	Oracle Artillery	3	Cruiser	L	Artillery	24000	2400	380000	8400	MAT_T3_021	5250	MAT_T3_022	3800	COMP_052	85	Artillery platform
SHIP	SHIP_053	Guardian Logistics	2	Cruiser	M	Logistics	19200	1920	240000	7200	MAT_T2_009	3850	MAT_T2_015	2650	COMP_029	62	Logistics cruiser
SHIP	SHIP_054	Basilisk Remote Repair	3	Cruiser	M	Repair	20800	2080	300000	7620	MAT_T3_018	4550	MAT_T3_019	3250	COMP_053	71	Remote repairs
SHIP	SHIP_055	Oneiros Logistics	3	Cruiser	M	Logistics	21200	2120	310000	7740	MAT_T3_016	4650	MAT_T3_021	3300	COMP_054	73	Advanced logistics
SHIP	SHIP_056	Scythe Fleet	2	Cruiser	M	Fleet	18800	1880	225000	6960	MAT_T2_010	3750	MAT_T2_013	2580	COMP_030	59	Fleet support
SHIP	SHIP_057	Armageddon Heavy	4	Cruiser	L	Heavy	25000	2500	480000	9000	MAT_T4_023	6000	MAT_T4_025	4300	COMP_080	100	Capital-grade cruiser
SHIP	SHIP_058	Apocalypse Combat	4	Cruiser	L	Combat	24500	2450	465000	8880	MAT_T4_023	5850	MAT_T4_026	4200	COMP_081	98	Elite combat
SHIP	SHIP_059	Abaddon Assault	4	Cruiser	L	Assault	25500	2550	495000	9120	MAT_T4_024	6150	MAT_T4_027	4400	COMP_082	103	Heavy assault
SHIP	SHIP_060	Nightmare Faction	4	Cruiser	L	Faction	26000	2600	520000	9240	MAT_T4_025	6300	MAT_T4_026	4500	COMP_083	105	Pirate faction
SHIP	SHIP_061	Sentinel Battlecruiser	4	Battlecruiser	L	Combat	35000	3500	650000	10800	MAT_T4_023	8500	MAT_T4_025	6200	COMP_085	135	Entry battlecruiser
SHIP	SHIP_062	Drake Combat	4	Battlecruiser	L	Missile	36000	3600	680000	11040	MAT_T4_023	8800	MAT_T4_026	6400	COMP_086	140	Missile battlecruiser
SHIP	SHIP_063	Ferox Artillery	4	Battlecruiser	L	Artillery	35500	3550	665000	10920	MAT_T4_024	8650	MAT_T4_027	6300	COMP_087	138	Artillery platform
SHIP	SHIP_064	Hurricane Projectile	4	Battlecruiser	L	Projectile	36500	3650	695000	11160	MAT_T4_025	8950	MAT_T4_026	6500	COMP_088	142	Projectile platform
SHIP	SHIP_065	Prophecy Attack	4	Battlecruiser	L	Attack	37000	3700	710000	11280	MAT_T4_026	9100	MAT_T4_027	6600	COMP_089	145	Attack cruiser
SHIP	SHIP_066	Harbinger Assault	4	Battlecruiser	L	Assault	37500	3750	725000	11400	MAT_T4_023	9250	MAT_T4_027	6700	COMP_090	148	Assault battlecruiser
SHIP	SHIP_067	Myrmidon Heavy	4	Battlecruiser	L	Heavy	38000	3800	740000	11520	MAT_T4_024	9400	MAT_T4_025	6800	COMP_091	150	Heavy combat
SHIP	SHIP_068	Brutix Blaster	4	Battlecruiser	L	Blaster	38500	3850	755000	11640	MAT_T4_026	9550	MAT_T4_027	6900	COMP_092	153	Blaster platform
SHIP	SHIP_069	Cyclone Missile	5	Battlecruiser	L	Missile	40000	4000	850000	12600	MAT_T5_028	10500	MAT_T5_031	7600	COMP_098	170	Advanced missiles
SHIP	SHIP_070	Talos Artillery	5	Battlecruiser	L	Artillery	39500	3950	835000	12480	MAT_T5_029	10350	MAT_T5_032	7500	COMP_099	168	Long-range artillery
SHIP	SHIP_071	Naga Railgun	5	Battlecruiser	L	Railgun	40500	4050	865000	12720	MAT_T5_030	10650	MAT_T5_033	7700	COMP_100	173	Railgun sniping
SHIP	SHIP_072	Oracle Laser	5	Battlecruiser	L	Laser	41000	4100	880000	12840	MAT_T5_031	10800	MAT_T5_028	7800	COMP_098	175	Laser battlecruiser
SHIP	SHIP_073	Command Battlecruiser	5	Battlecruiser	L	Command	42000	4200	920000	13080	MAT_T5_028	11100	MAT_T5_031	8000	COMP_099	180	Fleet command ship
SHIP	SHIP_074	Siege Battlecruiser	5	Battlecruiser	L	Siege	43000	4300	965000	13320	MAT_T5_029	11400	MAT_T5_032	8200	COMP_100	185	Siege mode capable
SHIP	SHIP_075	Elite Battlecruiser	5	Battlecruiser	L	Elite	44000	4400	1000000	13560	MAT_T5_030	11700	MAT_T5_033	8400	COMP_098	190	Ultimate battlecruiser
```

### BATTLESHIPS & CARRIERS

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
SHIP	SHIP_076	Dominix Battleship	5	Battleship	L	Combat	55000	5500	1200000	14400	MAT_T5_028	15000	MAT_T5_031	10500	COMP_098	250	Entry battleship
SHIP	SHIP_077	Megathron Heavy	5	Battleship	L	Heavy	56000	5600	1250000	14640	MAT_T5_028	15500	MAT_T5_032	11000	COMP_099	260	Heavy battleship
SHIP	SHIP_078	Hyperion Assault	5	Battleship	L	Assault	57000	5700	1300000	14880	MAT_T5_029	16000	MAT_T5_033	11500	COMP_100	270	Assault battleship
SHIP	SHIP_079	Apocalypse Laser	5	Battleship	XL	Laser	60000	6000	1400000	15360	MAT_T5_030	17000	MAT_T5_031	12000	COMP_098	290	Laser battleship
SHIP	SHIP_080	Armageddon Energy	5	Battleship	XL	Energy	61000	6100	1450000	15600	MAT_T5_031	17500	MAT_T5_028	12500	COMP_099	300	Energy warfare
SHIP	SHIP_081	Abaddon Artillery	5	Battleship	XL	Artillery	62000	6200	1500000	15840	MAT_T5_028	18000	MAT_T5_032	13000	COMP_100	310	Artillery platform
SHIP	SHIP_082	Tempest Projectile	5	Battleship	L	Projectile	58000	5800	1350000	15120	MAT_T5_029	16500	MAT_T5_033	11750	COMP_098	280	Projectile battleship
SHIP	SHIP_083	Maelstrom Artillery	5	Battleship	XL	Artillery	63000	6300	1550000	16080	MAT_T5_030	18500	MAT_T5_031	13500	COMP_099	320	Heavy artillery
SHIP	SHIP_084	Typhoon Missile	5	Battleship	XL	Missile	64000	6400	1600000	16320	MAT_T5_031	19000	MAT_T5_028	14000	COMP_100	330	Missile battleship
SHIP	SHIP_085	Raven Cruise Missile	5	Battleship	XL	Cruise	65000	6500	1650000	16560	MAT_T5_028	19500	MAT_T5_032	14500	COMP_098	340	Cruise missiles
SHIP	SHIP_086	Scorpion ECM	5	Battleship	XL	ECM	66000	6600	1700000	16800	MAT_T5_029	20000	MAT_T5_033	15000	COMP_099	350	ECM battleship
SHIP	SHIP_087	Rokh Railgun	5	Battleship	XL	Railgun	64500	6450	1625000	16440	MAT_T5_030	19250	MAT_T5_031	14250	COMP_100	335	Railgun sniping
SHIP	SHIP_088	Hyperion Blaster	5	Battleship	L	Blaster	59000	5900	1375000	15240	MAT_T5_031	16750	MAT_T5_028	12250	COMP_098	285	Blaster platform
SHIP	SHIP_089	Kronos Marauder	5	Battleship	XL	Marauder	68000	6800	1900000	17400	MAT_T5_028	22000	MAT_T5_032	16000	COMP_100	380	Marauder battleship
SHIP	SHIP_090	Paladin Marauder	5	Battleship	XL	Marauder	67500	6750	1875000	17280	MAT_T5_029	21750	MAT_T5_033	15750	COMP_098	375	Laser marauder
SHIP	SHIP_091	Vargur Marauder	5	Battleship	XL	Marauder	68500	6850	1925000	17520	MAT_T5_030	22250	MAT_T5_031	16250	COMP_099	385	Projectile marauder
SHIP	SHIP_092	Golem Marauder	5	Battleship	XL	Marauder	69000	6900	1950000	17640	MAT_T5_031	22500	MAT_T5_028	16500	COMP_100	390	Missile marauder
SHIP	SHIP_093	Nightmare Faction	5	Battleship	XL	Faction	70000	7000	2100000	18000	MAT_T5_028	23500	MAT_T5_032	17000	COMP_098	410	Sansha faction
SHIP	SHIP_094	Vindicator Faction	5	Battleship	XL	Faction	70500	7050	2150000	18120	MAT_T5_029	24000	MAT_T5_033	17500	COMP_099	420	Serpentis faction
SHIP	SHIP_095	Machariel Faction	5	Battleship	XL	Faction	71000	7100	2200000	18240	MAT_T5_030	24500	MAT_T5_031	18000	COMP_100	430	Angel faction
SHIP	SHIP_096	Thanatos Carrier	4	Carrier	XL	Carrier	70000	7000	2000000	18000	MAT_T4_023	25000	MAT_T4_025	18000	COMP_090	400	Entry carrier
SHIP	SHIP_097	Archon Carrier	4	Carrier	XL	Carrier	72000	7200	2100000	18360	MAT_T4_024	26000	MAT_T4_026	19000	COMP_091	420	Repair carrier
SHIP	SHIP_098	Chimera Carrier	4	Carrier	XL	Carrier	71000	7100	2050000	18180	MAT_T4_025	25500	MAT_T4_027	18500	COMP_092	410	Shield carrier
SHIP	SHIP_099	Nidhoggur Carrier	5	Carrier	XL	Carrier	74000	7400	2300000	18720	MAT_T5_028	28000	MAT_T5_031	20000	COMP_098	450	Advanced carrier
SHIP	SHIP_100	Aeon Supercarrier	5	Carrier	XL	Super	78000	7800	2800000	19800	MAT_T5_029	32000	MAT_T5_032	23000	COMP_099	520	Supercarrier
SHIP	SHIP_101	Hel Supercarrier	5	Carrier	XL	Super	79000	7900	2900000	19980	MAT_T5_030	33000	MAT_T5_033	24000	COMP_100	540	Advanced super
SHIP	SHIP_102	Nyx Supercarrier	5	Carrier	XL	Super	80000	8000	3000000	20160	MAT_T5_031	34000	MAT_T5_028	25000	COMP_098	560	Elite supercarrier
```

### DREADNOUGHTS & TITANS

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
SHIP	SHIP_103	Phoenix Dreadnought	5	Dreadnought	XL	Siege	90000	9000	4000000	21600	MAT_T5_028	40000	MAT_T5_031	28000	COMP_098	650	Missile dreadnought
SHIP	SHIP_104	Moros Dreadnought	5	Dreadnought	XL	Siege	91000	9100	4100000	21840	MAT_T5_029	41000	MAT_T5_032	29000	COMP_099	670	Blaster dreadnought
SHIP	SHIP_105	Revelation Dreadnought	5	Dreadnought	XL	Siege	92000	9200	4200000	22080	MAT_T5_030	42000	MAT_T5_033	30000	COMP_100	690	Laser dreadnought
SHIP	SHIP_106	Naglfar Dreadnought	5	Dreadnought	XL	Siege	93000	9300	4300000	22320	MAT_T5_031	43000	MAT_T5_028	31000	COMP_098	710	Artillery dreadnought
SHIP	SHIP_107	Zirnitra Dreadnought	5	Dreadnought	XL	Pirate	95000	9500	4600000	22800	MAT_T5_028	45000	MAT_T5_032	32500	COMP_099	750	Guristas dreadnought
SHIP	SHIP_108	Chemosh Dreadnought	5	Dreadnought	XL	Pirate	94000	9400	4500000	22560	MAT_T5_029	44000	MAT_T5_033	32000	COMP_100	730	Blood dreadnought
SHIP	SHIP_109	Vehement Dreadnought	5	Dreadnought	XL	Faction	96000	9600	4800000	23040	MAT_T5_030	46000	MAT_T5_031	33000	COMP_098	780	Serpentis dreadnought
SHIP	SHIP_110	Caiman Dreadnought	5	Dreadnought	XL	Pirate	97000	9700	4900000	23280	MAT_T5_031	47000	MAT_T5_028	33500	COMP_099	800	Guristas faction
SHIP	SHIP_111	Molok Dreadnought	5	Dreadnought	XL	Pirate	98000	9800	5000000	23520	MAT_T5_028	48000	MAT_T5_032	34000	COMP_100	820	Blood faction
SHIP	SHIP_112	Komodo Dreadnought	5	Dreadnought	XL	Faction	99000	9900	5100000	23760	MAT_T5_029	49000	MAT_T5_033	34500	COMP_098	840	Guristas elite
SHIP	SHIP_113	Avatar Titan	5	Titan	XL	Titan	150000	15000	10000000	30000	MAT_T5_028	90000	MAT_T5_031	65000	COMP_098	1500	Amarr titan
SHIP	SHIP_114	Erebus Titan	5	Titan	XL	Titan	152000	15200	10500000	30600	MAT_T5_029	92000	MAT_T5_032	67000	COMP_099	1550	Gallente titan
SHIP	SHIP_115	Leviathan Titan	5	Titan	XL	Titan	154000	15400	11000000	31200	MAT_T5_030	94000	MAT_T5_033	69000	COMP_100	1600	Caldari titan
SHIP	SHIP_116	Ragnarok Titan	5	Titan	XL	Titan	156000	15600	11500000	31800	MAT_T5_031	96000	MAT_T5_028	71000	COMP_098	1650	Minmatar titan
SHIP	SHIP_117	Vendetta Titan	5	Titan	XL	Faction	160000	16000	12500000	33000	MAT_T5_028	100000	MAT_T5_032	75000	COMP_099	1750	Serpentis titan
SHIP	SHIP_118	Vanquisher Titan	5	Titan	XL	Faction	162000	16200	13000000	33600	MAT_T5_029	102000	MAT_T5_033	77000	COMP_100	1800	Sansha titan
SHIP	SHIP_119	Molok Titan	5	Titan	XL	Faction	164000	16400	13500000	34200	MAT_T5_030	104000	MAT_T5_031	79000	COMP_098	1850	Blood titan
SHIP	SHIP_120	Komodo Titan	5	Titan	XL	Faction	165000	16500	14000000	34800	MAT_T5_031	105000	MAT_T5_028	80000	COMP_099	1900	Guristas titan
```

### INDUSTRIAL SPECIAL CIVILIAN

```tsv
DATABASE	ID	NAME	TIER	CATEGORY	SIZE	SUBCATEGORY	MASS_KG	VOLUME_M3	BASE_PRICE	PRODUCTION_TIME_SEC	INPUT_1	INPUT_1_QTY	INPUT_2	INPUT_2_QTY	INPUT_3	INPUT_3_QTY	SPECIAL_NOTES
SHIP	SHIP_121	Venture Mining Frigate	2	Industrial	S	Mining	6500	650	80000	4560	MAT_T2_008	1500	MAT_T2_010	1000	COMP_020	30	Entry mining ship
SHIP	SHIP_122	Prospect Expedition	3	Industrial	S	Expedition	7500	750	120000	5280	MAT_T3_016	1850	MAT_T3_018	1300	COMP_045	40	Covert mining
SHIP	SHIP_123	Procurer Mining Barge	3	Industrial	M	Barge	18000	1800	280000	7680	MAT_T3_016	4200	MAT_T3_020	3000	COMP_050	70	Tank mining barge
SHIP	SHIP_124	Retriever Mining Barge	3	Industrial	M	Barge	19000	1900	300000	7920	MAT_T3_021	4500	MAT_T3_022	3200	COMP_051	75	Cargo mining barge
SHIP	SHIP_125	Covetor Mining Barge	3	Industrial	M	Barge	17500	1750	270000	7560	MAT_T3_018	4000	MAT_T3_019	2900	COMP_052	68	Yield mining barge
SHIP	SHIP_126	Skiff Exhumer	4	Industrial	M	Exhumer	22000	2200	450000	8640	MAT_T4_023	5800	MAT_T4_025	4200	COMP_085	95	Tank exhumer
SHIP	SHIP_127	Mackinaw Exhumer	4	Industrial	M	Exhumer	23000	2300	480000	8880	MAT_T4_024	6100	MAT_T4_026	4400	COMP_086	100	Cargo exhumer
SHIP	SHIP_128	Hulk Exhumer	4	Industrial	L	Exhumer	24000	2400	510000	9120	MAT_T4_025	6400	MAT_T4_027	4600	COMP_087	105	Yield exhumer
SHIP	SHIP_129	Orca Industrial Command	4	Industrial	XL	Command	65000	6500	1800000	16560	MAT_T4_023	22000	MAT_T4_025	16000	COMP_090	380	Mining fleet command
SHIP	SHIP_130	Rorqual Capital Industrial	5	Industrial	XL	Capital	85000	8500	3500000	20400	MAT_T5_028	38000	MAT_T5_031	27000	COMP_098	600	Capital mining ship
SHIP	SHIP_131	Badger Hauler	2	Industrial	M	Transport	15000	1500	160000	6240	MAT_T2_008	3000	MAT_T2_010	2100	COMP_025	48	Entry hauler 20000m³
SHIP	SHIP_132	Tayra Hauler	2	Industrial	M	Transport	16000	1600	180000	6480	MAT_T2_009	3200	MAT_T2_013	2300	COMP_026	52	Mid hauler 24000m³
SHIP	SHIP_133	Bestower Hauler	2	Industrial	M	Transport	15500	1550	170000	6360	MAT_T2_010	3100	MAT_T2_014	2200	COMP_027	50	Hauler 22000m³
SHIP	SHIP_134	Iteron V Hauler	3	Industrial	M	Transport	19500	1950	250000	7320	MAT_T3_016	4400	MAT_T3_018	3200	COMP_055	68	Large hauler 38000m³
SHIP	SHIP_135	Mammoth Hauler	3	Industrial	M	Transport	20000	2000	265000	7560	MAT_T3_021	4600	MAT_T3_022	3350	COMP_056	72	Heavy hauler 42000m³
SHIP	SHIP_136	Nereus Specialist	3	Industrial	M	Specialist	18500	1850	235000	7080	MAT_T3_018	4100	MAT_T3_019	3000	COMP_057	65	Specialist hauler
SHIP	SHIP_137	Kryos Ore Hauler	3	Industrial	M	Ore	19000	1900	245000	7200	MAT_T3_016	4300	MAT_T3_021	3100	COMP_058	67	Ore specialized 48000m³
SHIP	SHIP_138	Miasmos Gas Hauler	3	Industrial	M	Gas	18800	1880	240000	7140	MAT_T3_020	4200	MAT_T3_022	3050	COMP_059	66	Gas specialized 46000m³
SHIP	SHIP_139	Epithal Planetary	3	Industrial	M	Planetary	18200	1820	230000	6960	MAT_T3_016	4000	MAT_T3_018	2950	COMP_060	64	Planetary goods
SHIP	SHIP_140	Hoarder Quick	2	Industrial	M	Fast	14500	1450	150000	6000	MAT_T2_008	2900	MAT_T2_010	2050	COMP_028	46	Fast hauler 16000m³
SHIP	SHIP_141	Bustard Deep Space	4	Industrial	L	DST	32000	3200	620000	10320	MAT_T4_023	7800	MAT_T4_025	5700	COMP_090	125	Deep space transport
SHIP	SHIP_142	Mastodon Deep Space	4	Industrial	L	DST	33000	3300	650000	10560	MAT_T4_024	8100	MAT_T4_026	5900	COMP_091	130	Armored DST
SHIP	SHIP_143	Crane Blockade Runner	4	Industrial	M	Blockade	25000	2500	480000	9000	MAT_T4_025	6200	MAT_T4_027	4500	COMP_092	102	Covert hauler
SHIP	SHIP_144	Viator Blockade Runner	4	Industrial	M	Blockade	24500	2450	470000	8880	MAT_T4_023	6000	MAT_T4_025	4400	COMP_085	100	Stealth transport
SHIP	SHIP_145	Charon Freighter	5	Industrial	XL	Freighter	120000	12000	6000000	25200	MAT_T5_028	65000	MAT_T5_031	46000	COMP_098	1100	Freighter 980000m³
SHIP	SHIP_146	Obelisk Freighter	5	Industrial	XL	Freighter	125000	12500	6500000	26400	MAT_T5_029	68000	MAT_T5_032	48000	COMP_099	1150	Heavy freighter 1040000m³
SHIP	SHIP_147	Fenrir Freighter	5	Industrial	XL	Freighter	122000	12200	6200000	25800	MAT_T5_030	66000	MAT_T5_033	47000	COMP_100	1120	Fast freighter 1000000m³
SHIP	SHIP_148	Prowler Covert Ops	3	Special	S	Covert	7200	720	115000	5160	MAT_T3_016	1800	MAT_T3_018	1280	COMP_061	38	Covert ops frigate
SHIP	SHIP_149	Raptor Interceptor	3	Special	S	Interceptor	7000	700	110000	5040	MAT_T3_020	1750	MAT_T3_022	1250	COMP_062	37	Elite interceptor
SHIP	SHIP_150	Hound Bomber	3	Special	S	Bomber	7400	740	120000	5280	MAT_T3_016	1850	MAT_T3_021	1300	COMP_063	39	Stealth bomber
SHIP	SHIP_151	Ibis Rookie	1	Civilian	S	Rookie	4500	450	5000	1800	MAT_T1_001	500	MAT_T1_002	300	COMP_001	10	Starter ship free
SHIP	SHIP_152	Velator Rookie	1	Civilian	S	Rookie	4600	460	5200	1860	MAT_T1_001	520	MAT_T1_002	310	COMP_002	10	Starter ship
SHIP	SHIP_153	Reaper Rookie	1	Civilian	S	Rookie	4550	455	5100	1830	MAT_T1_001	510	MAT_T1_002	305	COMP_003	10	Starter ship
SHIP	SHIP_154	Impairor Rookie	1	Civilian	S	Rookie	4650	465	5300	1890	MAT_T1_001	530	MAT_T1_002	315	COMP_004	10	Starter ship
SHIP	SHIP_155	Shuttle Capsule	1	Civilian	S	Shuttle	1000	100	1000	600	MAT_T1_001	100	MAT_T1_002	50	COMP_001	2	Emergency pod
```

---

## VERWENDUNG IN GODOT

### Autoload-System

```gdscript
# res://scripts/autoload/ship_module_data.gd
extends Node

var module_database: Dictionary = {}
var ship_database: Dictionary = {}

func _ready():
	load_module_data()
	load_ship_data()

func load_module_data():
	var file = FileAccess.open("res://data/ship_modules.tsv", FileAccess.READ)
	# Parse TSV...
	
func get_module(module_id: String) -> Dictionary:
	return module_database.get(module_id, {})
```

### Datenbank-Import

```python
# Python Script für TSV → JSON Konvertierung
import csv
import json

def tsv_to_json(tsv_file, json_file):
    data = []
    with open(tsv_file, 'r') as f:
        reader = csv.DictReader(f, delimiter='\t')
        for row in reader:
            data.append(row)
    
    with open(json_file, 'w') as f:
        json.dump(data, f, indent=2)
```

---

## BALANCING-ÜBERSICHT

### Preis-Progression

| Tier | Module (Ø) | Schiffe (Ø) | Multiplikator |
|------|-----------|-------------|---------------|
| 1 | 5,000 | 55,000 | 1x |
| 2 | 20,000 | 180,000 | 3-4x |
| 3 | 85,000 | 300,000 | 4-5x |
| 4 | 320,000 | 650,000 | 3-4x |
| 5 | 2,000,000 | 8,000,000 | 6-8x |

### Material-Verbrauch

| Schiffsklasse | MAT kg | COMP Stück | Ratio |
|---------------|--------|------------|-------|
| Frigate | 1,500 | 25 | 60:1 |
| Destroyer | 2,800 | 50 | 56:1 |
| Cruiser | 4,500 | 70 | 64:1 |
| Battlecruiser | 8,800 | 145 | 61:1 |
| Battleship | 17,000 | 300 | 57:1 |
| Capital | 45,000 | 700 | 64:1 |
| Titan | 95,000 | 1,600 | 59:1 |

---

**ENDE DER DATENBANK**

**Status:** ✅ Excel/Godot Ready  
**Format:** TSV (Tab-separated Values)  
**Encoding:** UTF-8  
**Verwendung:** Import in Excel, Google Sheets, Godot CSV Parser

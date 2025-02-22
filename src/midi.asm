// MIDI.asm (Fray)
if !{defined __MIDI__} {
define __MIDI__()

// This file extends the music table and defines macros for including new MIDI files.
// It also extends the instrument table and defines macros for including new instruments.
// For converting MIDI files, it's recommended to use GE Editor.
// Tools > Extra Tools > MIDI Tools > Convert Midi to GE Format and Loop

include "OS.asm"

scope MIDI {
    read32 MUSIC_TABLE, "../roms/original.z64", 0x3D768
    variable MUSIC_TABLE_END(MUSIC_TABLE + 0x17C)   // variable containing the current end of the music table
    constant MIDI_BANK(0x2400000)                   // defines the start of the additional MIDI bank
    global variable MIDI_BANK_END(MIDI_BANK)        // variable containing the current end of the MIDI bank
    // These 2 variables will be used in FGM.asm to calculate the correct RAM offset for numerous pointers
    variable midi_count(0x2F)                       // variable containing total number of MIDIs
    variable largest_midi(0)                        // variable containing the largest MIDI size

    // @ Description
    // moves the Dream Land midi to our new MIDI bank to clear space for expanding MUSIC_TABLE
    macro move_dream_land_midi() {
        pushvar origin, base

        // define a new offset for the Dream Land MIDI
        origin  MUSIC_TABLE + 0x4
        dw      MIDI_BANK_END - MUSIC_TABLE

        // remove the previous Dream Land MIDI
        origin  MUSIC_TABLE_END
        fill    0x1F40, 0x00

        // insert the Dream Land MIDI and update MIDI_BANK_END
        origin  MIDI_BANK_END
        insert  MIDI_Dream_Land, "../roms/original.z64", MUSIC_TABLE + 0x17C, 0x1F40
        global variable MIDI_BANK_END(origin())

        pullvar base, origin
    }

    // @ Description
    // adds a MIDI to our new MIDI bank, and the music table
    // file_name - Name of MIDI file
    // can_toggle - (bool) indicates if this should be toggleable
    // display_name - Name to display in Toggles
    macro insert_midi(file_name, can_toggle, display_name) {
        pushvar origin, base

        // defines
        define  path_MIDI_{file_name}(../src/music/{file_name}.bin)
        evaluate offset_MIDI_{file_name}(MIDI_BANK_END)
        evaluate MIDI_{file_name}_ID((MUSIC_TABLE_END - MUSIC_TABLE) / 0x8)

        global variable midi_count({MIDI_{file_name}_ID} + 0x1)
        global define MIDI_{MIDI_{file_name}_ID}_TOGGLE({can_toggle})
        global define MIDI_{MIDI_{file_name}_ID}_NAME({display_name})
        global define id.{file_name}({MIDI_{file_name}_ID})

        // print message
        print "Added MIDI_{file_name}({path_MIDI_{file_name}}): {MIDI_{MIDI_{file_name}_ID}_NAME}\n"
        print "ROM Offset: 0x"; OS.print_hex({offset_MIDI_{file_name}}); print "\n"
        print "MIDI_{file_name}_ID: 0x"; OS.print_hex({MIDI_{file_name}_ID}); print "\n"
        print "Sound Test Music ID: ", midi_count, "\n\n"

        // add the new midi to the music table and update MUSIC_TABLE_END
        origin  MUSIC_TABLE_END
        dw      origin_MIDI_{file_name} - MUSIC_TABLE
        dw      MIDI_{file_name}.size
        global variable MUSIC_TABLE_END(origin())

        // insert the MIDI file and update MIDI_BANK_END
        origin  MIDI_BANK_END
        constant origin_MIDI_{file_name}(origin())
        insert  MIDI_{file_name}, "{path_MIDI_{file_name}}"
        OS.align(4)
        global variable MIDI_BANK_END(origin())

        // set the number of songs in MUSIC_TABLE
        origin  MUSIC_TABLE + 0x2
        dh      midi_count

        // update largest MIDI size
        if MIDI_{file_name}.size > largest_midi {
            global variable largest_midi(MIDI_{file_name}.size)
        }

        pullvar base, origin
    }

    // define new MIDI bank
    print "=============================== MIDI FILES =============================== \n"
    // print music table offset
    evaluate music_table_offset(MUSIC_TABLE)
    print "Music Table: 0x"; OS.print_hex({music_table_offset}); print "\n"
    // move dream land midi
    move_dream_land_midi()
    // insert custom midi files
    insert_midi(GANONDORF_BATTLE, OS.TRUE, Ganondorf Battle)
    insert_midi(CORNERIA, OS.TRUE, Corneria)
    insert_midi(KOKIRI_FOREST, OS.TRUE, Kokiri Forest)
    insert_midi(DR_MARIO, OS.TRUE, Dr. Mario)
    insert_midi(KALOS, OS.TRUE, Kalos)
    insert_midi(SMASHVILLE, OS.TRUE, Smashville)
    insert_midi(WARIO_WARE, OS.TRUE, Wario Ware)
    insert_midi(FIRST_DESTINATION, OS.TRUE, First Destination)
	insert_midi(COOLCOOLMOUNTAIN, OS.TRUE, Cool Cool Mountain)
	insert_midi(GODDESSBALLAD, OS.TRUE, Goddess Ballad)
	insert_midi(GREATBAY, OS.TRUE, Great Bay)
	insert_midi(TOWEROFHEAVEN, OS.TRUE, Tower Of Heaven)
	insert_midi(FOD, OS.TRUE, FOD)
    insert_midi(MUDA, OS.TRUE, Muda)
    insert_midi(MEMENTOS, OS.TRUE, Last Surprise)
    insert_midi(SPIRAL_MOUNTAIN, OS.TRUE, Spiral Mountain)
    insert_midi(N64, OS.TRUE, N64)
    insert_midi(MUTE_CITY, OS.TRUE, Mute City)
    insert_midi(BATTLEFIELD, OS.TRUE, Battlefield)
    insert_midi(MADMONSTER, OS.TRUE, Mad Monster Mansion)
    insert_midi(GANON_VICTORY, OS.FALSE, -1)
    insert_midi(YOUNGLINK_VICTORY, OS.FALSE, -1)
    insert_midi(FALCO_VICTORY, OS.FALSE, -1)
    insert_midi(DRMARIO_VICTORY, OS.FALSE, -1)
    insert_midi(DRAGONKING, OS.TRUE, Melee Menu)
    insert_midi(DREAMLANDBETA, OS.TRUE, Dream Land Beta)
    insert_midi(NORFAIR, OS.TRUE, Kraid's Lair)
    insert_midi(BOWSERBOSS, OS.TRUE, Bowser's Theme)
    insert_midi(POKEMON_STADIUM, OS.TRUE, Pokemon Stadium)
    insert_midi(BOWSERROAD, OS.TRUE, Bowser's Road)
    insert_midi(BOWSERFINAL, OS.TRUE, Ultimate Bowser)
    insert_midi(CASTLEWALL, OS.TRUE, Inside the Castle Walls)
    insert_midi(DELFINO, OS.TRUE, Delfino Plaza)
    insert_midi(HORROR_MANOR, OS.TRUE, Horror Manor)
    insert_midi(BIG_BLUE, OS.TRUE, Big Blue)
    insert_midi(DSAMUS_VICTORY, OS.FALSE, -1)
    insert_midi(ONETT, OS.TRUE, Onett)
    insert_midi(ZEBES_LANDING, OS.TRUE, Zebes Landing)
    insert_midi(FROSTY_VILLAGE, OS.TRUE, Frosty Village)
    insert_midi(METAL_CAP, OS.TRUE, Metal Cap)
    insert_midi(WING_CAP, OS.TRUE, Wing Cap)
    insert_midi(PIKA_CUP, OS.TRUE, Pika Cup)
    insert_midi(KITCHEN_ISLAND, OS.TRUE, Kitchen Island)
    insert_midi(GLACIAL, OS.TRUE, Glacial River)
    insert_midi(DK_RAP, OS.TRUE, DK Rap)
    insert_midi(WARIO_VICTORY, OS.FALSE, -1)
    insert_midi(MACHRIDER, OS.TRUE, Mach Rider)
    insert_midi(ELITE_FOUR, OS.TRUE, Elite Four)
    insert_midi(GERUDO_VALLEY, OS.TRUE, Gerudo Valley)
    insert_midi(POP_STAR, OS.TRUE, Pop Star)
    insert_midi(STAR_WOLF, OS.TRUE, Star Wolf)
    insert_midi(STARRING_WARIO, OS.TRUE, Starring Wario)
    insert_midi(LUCAS_VICTORY, OS.FALSE, -1)
    insert_midi(POKEMON_CHAMPION, OS.TRUE, Pokemon Champion)
    insert_midi(ANIMAL_CROSSING, OS.TRUE, Animal Crossing)
    insert_midi(HYRULE_TEMPLE, OS.TRUE, Hyrule Temple)
    insert_midi(ALL_I_NEEDED_WAS_YOU, OS.TRUE, All That I Needed)
    insert_midi(PIGGYGUYS, OS.TRUE, Piggy Guys)
    insert_midi(DCMC, OS.TRUE, DCMC Performance)
    insert_midi(UNFOUNDED_REVENGE, OS.TRUE, Unfounded Revenge)
    insert_midi(BLOOMING_VILLAIN, OS.TRUE, Blooming Villain)
    insert_midi(BRAWL, OS.TRUE, Brawl Menu)
    insert_midi(NBA_JAM, OS.TRUE, NBA Jam)
    insert_midi(KENGJR, OS.TRUE, Ken Griffey Jr.)
	insert_midi(CLOCKTOWER, OS.TRUE, Clocktower)
	insert_midi(POLLYANNA, OS.TRUE, Pollyanna)
	insert_midi(KK_RIDER, OS.TRUE, Go KK Rider)
	insert_midi(SNAKEY_CHANTEY, OS.TRUE, Snakey Chantey)
	insert_midi(TAZMILY, OS.TRUE, Mom's Hometown)
	insert_midi(FLAT_ZONE, OS.TRUE, Flat Zone)
	insert_midi(FLAT_ZONE_2, OS.TRUE, Flat Zone II)
	insert_midi(YOSHI_GOLF, OS.TRUE, Mario Golf Yoshi's Island)
	insert_midi(TEMPLE_8BIT, OS.TRUE, Hyrule Temple 8 Bit)
	insert_midi(OBSTACLE, OS.TRUE, Obstacle Course)
	insert_midi(EVEN_DRIER_GUYS, OS.TRUE, Even Drier Guys)
	insert_midi(FIRE_FIELD, OS.TRUE, Fire Field)
	insert_midi(PEACH_CASTLE, OS.TRUE, Princess Peach's Castle 2)
	insert_midi(CLICKCLOCKWOODS, OS.TRUE, Click Clock Woods)
	insert_midi(BOWSER_VICTORY, OS.FALSE, -1)
	insert_midi(MULTIMAN, OS.TRUE, Multiman Mode)
	insert_midi(CRUEL, OS.TRUE, Cruel Multiman Mode)
	insert_midi(GANGPLANK, OS.TRUE, Gang-Plank Galleon)
	insert_midi(SHOWDOWN, OS.TRUE, Showdown)
    insert_midi(ASTRAL_OBSERVATORY, OS.TRUE, Astral Observatory)
	insert_midi(ARIA_OF_THE_SOUL, OS.TRUE, Aria of the Soul)
	insert_midi(PAPER_MARIO_BATTLE, OS.TRUE, Paper Mario Battle)
	insert_midi(KING_OF_THE_KOOPAS, OS.TRUE, King of the Koopas)
	insert_midi(MRPATCH, OS.TRUE, Mr. Patch)
	insert_midi(KROOLS_ACID_PUNK, OS.TRUE, K. Rool's Acid Punk)
	insert_midi(BEWARE_THE_FORESTS_MUSHROOMS, OS.TRUE, Beware the Forest's Mushrooms)
	insert_midi(FIGHT_AGAINST_BOWSER, OS.TRUE, Fight Against Bowser)
    insert_midi(DKR_BOSS, OS.TRUE, Diddy Kong Racing Boss)
    insert_midi(CRESCENT_ISLAND, OS.TRUE, Crescent Island)
    insert_midi(CONKER_VICTORY, OS.FALSE, -1)
    insert_midi(RITH_ESSA, OS.TRUE, Rith Essa)
    insert_midi(TARGET_TEST, OS.TRUE, Target Test)
    insert_midi(VENOM, OS.TRUE, Venom)
    insert_midi(SURPRISE_ATTACK, OS.TRUE, Surprise Attack)
    insert_midi(BK_FINALBATTLE, OS.TRUE, Final Battle)
    insert_midi(PLACEHOLDER, OS.FALSE, -1)
    insert_midi(OLE, OS.TRUE, Ole!)
    insert_midi(WINDY, OS.TRUE, Windy and Co.)
    insert_midi(STARFOX_MEDLEY, OS.TRUE, Star Fox Medley)
    insert_midi(DATADYNE, OS.TRUE, dataDyne)
    insert_midi(CARRINGTON, OS.TRUE, Carrington Institute)
    insert_midi(CRADLE, OS.TRUE, Cradle)
    insert_midi(TROUBLE_MAKER, OS.TRUE, Trouble Maker)
    insert_midi(ESPERANCE, OS.TRUE, Esperance)
    insert_midi(SLOPRANO, OS.TRUE, Sloprano)
    insert_midi(WOLF_VICTORY, OS.FALSE, -1)
    insert_midi(NSMB, OS.TRUE, New Super Mario Bros.)

    pushvar origin, base

    // Extend Sound Test Music numbers so we can test in game easier
    origin  0x1883BA
    dh      midi_count
    origin  0x188246
    dh      midi_count - 1
    origin  0x1883C2
    dh      midi_count - 1
    origin  0x1883CE
    dh      midi_count - 1

    pullvar base, origin

    // @ Description
    // Modifies the routine that maps Sound Test screen choices to BGM IDs
    scope augment_sound_test_music_: {
        OS.patch_start(0x188530, 0x80132160)
        j       augment_sound_test_music_
        nop
        OS.patch_end()

        lui     t0, 0x8013                        // original line 1
        lw      t0, 0x4348(t0)                    // original line 2
        slti    a0, t0, 0x2D                      // check if this is one we added (so >= 0x2D)
        bnez    a0, _normal                       // if (original bgm_id) then skip to _normal
        nop
        // If we're here, then the music ID is > 0x2C which means it's
        // one we added. So we need to set up a1 as the extended music
        // table address and offset:
        li      a1, extended_music_map_table      // a1 = address of extended table
        addiu   t0, t0, -0x002D                   // t0 = slot in extended table
        sll     t1, t0, 0x2                       // t1 = offset for bgm_id in extended table
        addu    a1, a1, t1                        // a1 = adress for bgm_id
        lhu     a1, 0x0002(a1)                    // a1 = bgm_id
        jal     0x80020AB4                        // call play MIDI routine
        nop
        j       0x80132180                        // return
        nop

        _normal:
        j       0x80132168                        // continue with original line 3
        nop
    }

    extended_music_map_table:
    dw     0xA                                    // for some reason originally left of music test
    dw     0xB                                    // for some reason originally left of music test
    define n(0x2F)
    while {n} < midi_count {
        dw      {n}
        evaluate n({n}+1)
    }

    print "========================================================================== \n"

    print "=============================== INSTRUMENTS ============================== \n"

    // Constants and variables related to instruments
    read32 INST_CTL_TABLE, "../roms/original.z64", 0x3D75C                       // CTL_TABLE is the base for a lot of sound related offsets
    constant INST_CTL_TABLE_PC(0x800472D0)                                       // CTL_TABLE is loaded in RAM here
    read32 INST_BANK_MAP_OFFSET, "../roms/original.z64", INST_CTL_TABLE + 0x0004 // INST_BANK_MAP_OFFSET is the offset from CTL to the INST_BANK_MAP
    constant INST_BANK_MAP(INST_CTL_TABLE + INST_BANK_MAP_OFFSET)                // INST_BANK_MAP holds offsets to each instrument
    read32 INST_SAMPLE_DATA, "../roms/original.z64", 0x3D760                     // INST_SAMPLE_DATA is the raw sample data
    variable instrument_count(0x2A)                                              // variable containing the total number of added instruments
    variable current_instrument_sample_count(0)                                  // variable containing number of samples in the current instrument

    // @ Description
    // Adds an instrument sample to be used by the instrument created in the next add_instrument() call
    // name                        - Name of .aifc file of sample (and .bin of loop predictors file if present)
    // attack_time                 - (word) attack time
    // decay_time                  - (word) decay time
    // release_time                - (word) release time
    // attack_volume               - (byte) attack volume
    // decay_volume                - (byte) decay volume
    // vel_min                     - (byte) vel min
    // vel_max                     - (byte) vel max
    // key_min                     - (byte) key min
    // key_max                     - (byte) key max
    // key_base                    - (byte) key base
    // detune                      - (byte) detune
    // sample_pan                  - (byte) sample pan
    // sample_volume               - (byte) sample volume
    // loop_enabled                - (bool) if OS.FALSE, then loop is not enabled, if OS.TRUE then loop is enabled
    // loop_start                  - (word) loop start
    // loop_end                    - (word) loop end
    // loop_count                  - (word) loop count
    // loop_predictors_file_exists - (bool) if OS.TRUE, then loop predictors are in {name}.bin, if OS.FALSE then fill with 0
    macro add_instrument_sample(name, attack_time, decay_time, release_time, attack_volume, decay_volume, vel_min, vel_max, key_min, key_max, key_base, detune, sample_pan, sample_volume, loop_enabled, loop_start, loop_end, loop_count, loop_predictors_file_exists) {
        if current_instrument_sample_count == 0 {
            // increment instrument count
            global variable instrument_count(instrument_count + 1)
        }

        // increment current_instrument_sample_count
        global variable current_instrument_sample_count(current_instrument_sample_count + 1)
        evaluate inst_num(instrument_count)
        evaluate sample_num(current_instrument_sample_count)
        global define SAMPLE_NAME_{inst_num}_{sample_num}({name})
        // Sample length is 2 words too long
        read32 SAMPLE_LENGTH_{inst_num}_{sample_num}, "../src/music/instruments/{SAMPLE_NAME_{inst_num}_{sample_num}}.aifc", 0xF4

        attack_delay_params_{inst_num}_{sample_num}:
        dw      {attack_time}
        dw      {decay_time}
        dw      {release_time}
        db      {attack_volume}
        db      {decay_volume}
        dh      0x0000 // ?

        vel_key_params_{inst_num}_{sample_num}:
        db      {vel_min}
        db      {vel_max}
        db      {key_min}
        db      {key_max}
        db      {key_base}
        db      {detune}
        dh      0x0000 // ?

        instrument_block_{inst_num}_{sample_num}:
        dw      attack_delay_params_{inst_num}_{sample_num} - INST_CTL_TABLE_PC
        dw      vel_key_params_{inst_num}_{sample_num} - INST_CTL_TABLE_PC
        dw      pc() + 0x8 - INST_CTL_TABLE_PC

        db      {sample_pan}
        db      {sample_volume}
        dh      0x0000 // ?

        // insert raw data
        pushvar origin, base
        origin  MIDI_BANK_END
        // I believe loop predictors will be at the end of the file, so I intentionally read a specific length
        constant SAMPLE_RAW_{inst_num}_{sample_num}_origin(origin())
        insert SAMPLE_RAW_{inst_num}_{sample_num}, "../src/music/instruments/{SAMPLE_NAME_{inst_num}_{sample_num}}.aifc", 0x100, SAMPLE_LENGTH_{inst_num}_{sample_num} - 0x0008
        global variable MIDI_BANK_END(origin())
        pullvar base, origin

        dw      SAMPLE_RAW_{inst_num}_{sample_num}_origin - INST_SAMPLE_DATA // pointer to raw data
        dw      SAMPLE_LENGTH_{inst_num}_{sample_num} - 0x0008               // length of raw data
        dw      0x0000 // ?

        if {loop_enabled} == OS.TRUE {
            dw  loop_params_{inst_num}_{sample_num} - INST_CTL_TABLE_PC
        } else {
            dw  0x0000
        }

        dw      predictors_{inst_num}_{sample_num} - INST_CTL_TABLE_PC

        dw      0x0000

        if {loop_enabled} == OS.TRUE {
            loop_params_{inst_num}_{sample_num}:
            dw  {loop_start}
            dw  {loop_end}
            dw  {loop_count}
            // loop predictors - I believe they should be at the end of the .aifc file, but haven't been able to produce a valid one yet
            // ...but n64 sound tool produces them
            if {loop_predictors_file_exists} == OS.TRUE {
                insert "../src/music/instruments/{SAMPLE_NAME_{inst_num}_{sample_num}}.bin"
            } else {
                fill 0x20, 0x0
            }
            dw  0x0000
        }

        predictors_{inst_num}_{sample_num}:
        dw     0x00000002
        dw     0x00000004
        insert SAMPLE_PREDICTORS_{inst_num}_{sample_num}, "../src/music/instruments/{SAMPLE_NAME_{inst_num}_{sample_num}}.aifc", 0x70, 0x80
    }

    // @ Description
    // Adds an instrument consisting of all the instrument samples added since the last add_instrument() call
    // name       - Name of the instrument (for display purposes only)
    // volume     - (byte) volume
    // pan        - (byte) pan
    // priority   - (byte) priority
    // bend_range - (hw) bend range
    // trem_type  - (byte) trem type
    // trem_rate  - (byte) trem rate
    // trem_depth - (byte) trem depth
    // trem_delay - (byte) trem delay
    // vib_type   - (byte) vib type
    // vib_rate   - (byte) vib rate
    // vib_depth  - (byte) vib depth
    // vib_delay  - (byte) vid delay
    macro add_instrument(name, volume, pan, priority, bend_range, trem_type, trem_rate, trem_depth, trem_delay, vib_type, vib_rate, vib_depth, vib_delay) {
        evaluate inst_num(instrument_count)
        global define INST_NAME_{inst_num}({name})
        print "Added {INST_NAME_{inst_num}}\nINST_ID: 0x"; OS.print_hex({inst_num}); print " (", {inst_num},")\nSamples:\n"

        instrument_parameters_{inst_num}:
        db      {volume}
        db      {pan}
        db      {priority}
        db      0x00                               // Gets set to 1 when processed
        db      {trem_type}
        db      {trem_rate}
        db      {trem_depth}
        db      {trem_delay}
        db      {vib_type}
        db      {vib_rate}
        db      {vib_depth}
        db      {vib_delay}
        dh      {bend_range}                       // 0x0064 for most (2 semitones?)
        dh      current_instrument_sample_count

        // pointers to instrument blocks
        define n(1)
        while {n} <= current_instrument_sample_count {
            dw       instrument_block_{inst_num}_{n} - INST_CTL_TABLE_PC
            print " - {SAMPLE_NAME_{inst_num}_{n}}\n"
            evaluate n({n}+1)
        }

        // This is necessary so the next instrument doesn't get jarbled
        OS.align(16)

        // reset current_instrument_sample_count
        global variable current_instrument_sample_count(0)
    }

    // @ Description
    // Moves the instrument bank map so it can be extended
    macro move_instrument_bank_map() {
        evaluate inst_num(instrument_count)

        // Move INST_BANK_MAP so it can be extended
        moved_inst_bank_map:
        global variable moved_inst_bank_map_origin(origin())
        OS.move_segment(INST_BANK_MAP, 0xB8)

        // extend using instrument_count
        define n(0x2B)
        evaluate n({n})
        while {n} <= {inst_num} {
            dw       instrument_parameters_{n} - INST_CTL_TABLE_PC
            evaluate n({n}+1)
        }

        pushvar origin, base

        // Update instrument count
        origin moved_inst_bank_map_origin
        dh      instrument_count + 1

        // Update INST_BANK_MAP_OFFSET to point to new location
        origin INST_CTL_TABLE + 0x0004
        dw      moved_inst_bank_map - INST_CTL_TABLE_PC

        pullvar base, origin
    }

    // This is necessary so the first instrument doesn't get jarbled
    OS.align(16)

    // Add instrument samples, then call add_instrument
    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(natural_strings-0, 0x00000000, 0xFFFFFFFF, 0x0000704E, 0x7F, 0x7F, 0x00, 0x7F, 0x00, 0x48, 0x48, 0x28, 0x40, 0x7F, OS.TRUE, 0x00001915, 0x00003612, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(natural_strings-1, 0x00000000, 0xFFFFFFFF, 0x0000704E, 0x7F, 0x7F, 0x00, 0x7F, 0x49, 0x51, 0x4F, 0x28, 0x40, 0x7F, OS.TRUE, 0x00001AAA, 0x0000326E, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(natural_strings-2, 0x00000000, 0xFFFFFFFF, 0x0000704E, 0x7F, 0x7F, 0x00, 0x7F, 0x52, 0x56, 0x54, 0x28, 0x40, 0x7F, OS.TRUE, 0x00000F3D, 0x000027FF, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(natural_strings-3, 0x00000000, 0xFFFFFFFF, 0x0000704E, 0x7F, 0x7F, 0x00, 0x7F, 0x57, 0x5D, 0x5B, 0x28, 0x40, 0x7F, OS.TRUE, 0x00000A7E, 0x00002184, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(natural_strings-4, 0x00000000, 0xFFFFFFFF, 0x0000704E, 0x7F, 0x7F, 0x00, 0x7F, 0x5E, 0x62, 0x60, 0x28, 0x40, 0x7F, OS.TRUE, 0x00000A86, 0x00002278, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(natural_strings-5, 0x00000000, 0xFFFFFFFF, 0x0000704E, 0x7F, 0x7F, 0x00, 0x7F, 0x63, 0x69, 0x67, 0x28, 0x40, 0x7F, OS.TRUE, 0x00000D84, 0x00001E1D, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(natural_strings-6, 0x00000000, 0xFFFFFFFF, 0x0000704E, 0x7F, 0x7F, 0x00, 0x7F, 0x6A, 0x7F, 0x6C, 0x28, 0x40, 0x7F, OS.TRUE, 0x00000CAC, 0x00001E35, 0xFFFFFFFF, OS.TRUE)
    add_instrument(Natural Strings, 0x7F, 0x40, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(synth_strings-0, 0x000123FE, 0xFFFFFFFF, 0x0002FBAC, 0x7F, 0x7F, 0x00, 0x7F, 0x00, 0x2A, 0x2A, 0x0, 0x40, 0x7F, OS.TRUE, 0x00000001, 0x00007527, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(synth_strings-1, 0x000123FE, 0xFFFFFFFF, 0x0002FBAC, 0x7F, 0x7F, 0x00, 0x7F, 0x2B, 0x33, 0x31, 0x0, 0x40, 0x7F, OS.TRUE, 0x00000001, 0x00007471, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(synth_strings-2, 0x000123FE, 0xFFFFFFFF, 0x0002FBAC, 0x7F, 0x7F, 0x00, 0x7F, 0x34, 0x3A, 0x36, 0x6, 0x40, 0x7F, OS.TRUE, 0x00000001, 0x0000621C, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(synth_strings-3, 0x000123FE, 0xFFFFFFFF, 0x0002FBAC, 0x7F, 0x7F, 0x00, 0x7F, 0x3B, 0x3F, 0x3D, 0x0, 0x40, 0x7F, OS.TRUE, 0x00000001, 0x00004BFD, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(synth_strings-4, 0x000123FE, 0xFFFFFFFF, 0x0002FBAC, 0x7F, 0x7F, 0x00, 0x7F, 0x40, 0x46, 0x42, 0x3, 0x40, 0x7F, OS.TRUE, 0x00000035, 0x00005FCA, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(synth_strings-5, 0x000123FE, 0xFFFFFFFF, 0x0002FBAC, 0x7F, 0x7F, 0x00, 0x7F, 0x47, 0x4B, 0x49, 0x0, 0x40, 0x7F, OS.TRUE, 0x00000001, 0x00004882, 0xFFFFFFFF, OS.TRUE)
    add_instrument_sample(synth_strings-6, 0x000123FE, 0xFFFFFFFF, 0x0002FBAC, 0x7F, 0x7F, 0x00, 0x7F, 0x4C, 0x7F, 0x4E, 0x0, 0x40, 0x7F, OS.TRUE, 0x00000001, 0x00005E11, 0xFFFFFFFF, OS.TRUE)
    add_instrument(Synth Strings, 0x7F, 0x40, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(choir-0, 0x00000000, 0x0000C028, 0x00004F2D, 0x1E, 0x7F, 0x00, 0x7F, 0x00, 0x7F, 0x5D, 0x1D, 0x40, 0x7F, OS.TRUE, 0x00000000, 0x000011D0, 0xFFFFFFFF, OS.TRUE)
    add_instrument(Choir, 0x7F, 0x40, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(marimba-0, 0x00000000, 0xFFFFFFFF, 0x00001388, 0x7F, 0x7F, 0x00, 0x7F, 0x00, 0x48, 0x48, 0x2D, 0x40, 0x7F, OS.FALSE, 0x00000000, 0x00000000, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(marimba-1, 0x00000000, 0xFFFFFFFF, 0x00001388, 0x7F, 0x7F, 0x00, 0x7F, 0x49, 0x7F, 0x54, 0x2E, 0x40, 0x7F, OS.FALSE, 0x00000000, 0x00000000, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Marimba, 0x7F, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(church_organ-1, 0x0, 0x0, 66 * 750, 0x7F, 0x7F, 0x0, 0x7F, 0,  71,  60, 0x0, 0x3F, 0x7E, OS.TRUE, 15104, 71862, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(church_organ-2, 0x0, 0x0, 66 * 750, 0x7F, 0x7F, 0x0, 0x7F, 72, 127, 72, 0x0, 0x3F, 0x7E, OS.TRUE, 5681,  29819, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Church Organ, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(steel_drum-0, 0x0, 0x004C4B40, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F,  0,  67,  67, 0x0, 0x3F, 0x7E, OS.TRUE, 17025, 23941, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(steel_drum-1, 0x0, 0x004C4B40, 66 * 1879, 0x7F, 0x0, 0x0, 0x7F, 68, 127,  73, 0x0, 0x3F, 0x7E, OS.TRUE, 0, 0, 0, OS.FALSE)
    add_instrument(Steel Drum, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(distortion_guitar-1, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 0,   42, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 0x3383, 0x677A, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-2, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 43,  48, 46, 0x0, 0x3F, 0x7E, OS.TRUE, 0x3333, 0x6686, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(distortion_guitar-3, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 49,  53, 52, 0x0, 0x3F, 0x7E, OS.TRUE, 0x3477, 0x684C, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-4, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 54,  56, 55, 0x0, 0x3F, 0x7E, OS.TRUE,  25240,  65462, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-5, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 57,  58, 57, 0x0, 0x3F, 0x7E, OS.TRUE,  21144,  48670, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-6, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 59,  63, 62, 0x0, 0x3F, 0x7E, OS.TRUE,  20292,  44855, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-7, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 64,  65, 64, 0x0, 0x3F, 0x7E, OS.TRUE,  24855,  49720, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-8, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 66,  70, 69, 0x0, 0x3F, 0x7E, OS.TRUE,  18279,  37962, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-9, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 71,  72, 71, 0x0, 0x3F, 0x7E, OS.TRUE,  11738,  37333, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-10, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 73,  77, 76, 0x0, 0x3F, 0x7E, OS.TRUE,  23164,  35483, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-11, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 78,  82, 81, 0x0, 0x3F, 0x7E, OS.TRUE,  14999,  37007, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(distortion_guitar-12, 0x0, 0x004C4B40, 66 * 450, 0x7F, 0x0, 0x0, 0x7F, 83,  95, 83, 0x0, 0x3F, 0x7E, OS.TRUE,  14439,  29101, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Distortion Guitar, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x80, 0xF1, 0x64, 0x01)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(saxophone-0, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F,  0,  75, 64, 0x0, 0x3F, 0x7E, OS.TRUE, 6644, 8585, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(saxophone-1, 0x0, 0x001E8480, 66 * 300, 0x7F, 0x0, 0x00, 0x7F, 76, 127, 76, 0x0, 0x3F, 0x7E, OS.TRUE, 8887, 9906, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Saxophone, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(overdriven_guitar-0, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 0,  59,  59, 0x0, 0x3F, 0x7E, OS.TRUE, 39088, 66074, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(overdriven_guitar-1, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 60, 64,  64, 0x0, 0x3F, 0x7E, OS.TRUE, 23395, 44703, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(overdriven_guitar-2, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 65, 70,  69, 0x0, 0x3F, 0x7E, OS.TRUE, 14699, 27490, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(overdriven_guitar-3, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 71, 74,  73, 0x0, 0x3F, 0x7E, OS.TRUE, 19841, 32444, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(overdriven_guitar-4, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 75, 78,  77, 0x0, 0x3F, 0x7E, OS.TRUE, 18937, 31235, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(overdriven_guitar-5, 0x0, 0x002DC6C0, 66 * 350, 0x7F, 0x0, 0x0, 0x7F, 79, 127, 88, 0x0, 0x3F, 0x7E, OS.TRUE, 10849, 18728, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Overdriven Guitar, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(piano-1, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 0,  53,  47, 0x0, 0x3F, 0x7E, OS.TRUE, 33089, 34385, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(piano-2, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 53, 71,  67, 0x0, 0x3F, 0x7E, OS.TRUE, 35630, 41007, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(piano-3, 0x0, 0x0, 66 * 1879, 0x7F, 0x7F, 0x0, 0x7F, 72, 127, 79, 0x0, 0x3F, 0x7E, OS.TRUE, 28842, 32304, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Piano, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    // TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(slap_bass-1, 0x0, 0x0, 66 * 500, 0x7F, 0x7F, 0x0, 0x7F, 0,  39,  28, 0x0, 0x3F, 0x7E, OS.TRUE, 24607, 36249, 0xFFFFFFFF, OS.FALSE)
    add_instrument_sample(slap_bass-2, 0x0, 0x0, 66 * 500, 0x7F, 0x7F, 0x0, 0x7F, 40, 127, 40, 0x0, 0x3F, 0x7E, OS.TRUE, 9445,  21094, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Slap Bass, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(orchestral_hit-1, 0x0, 0x000F4240, 66 * 3000, 0x7F, 0x0, 0x0, 0x7F, 0,  127,  72, 0x0, 0x3F, 0x7E, OS.TRUE, 12273, 18432, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Orchestral Hit, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
	
	// TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(synth_alt-1, 0x0, 0x0, 66 * 150, 0x7F, 0x7F, 0x0, 0x7F, 0,  127,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 2797, 4798, 0xFFFFFFFF, OS.FALSE)
    add_instrument(Synth Alt, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
    
	// TODO: for these samples, make sure values are correct (assuming we keep this instrument)
    add_instrument_sample(square_25-1, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F,  0,  45,  36, 0x0, 0x3F, 0x7E, OS.TRUE,  8474, 38310, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(square_25-2, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 46,  47,  48, 0x0, 0x3F, 0x7E, OS.TRUE, 10667, 28738, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(square_25-3, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 58,  69,  60, 0x0, 0x3F, 0x7E, OS.TRUE,  3933, 22004, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(square_25-4, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 70,  81,  72, 0x0, 0x3F, 0x7E, OS.TRUE,  5321, 26994, 0xFFFFFFFF, OS.FALSE)
	add_instrument_sample(square_25-5, 0x0, 0x0, 66 * 30, 0x7F, 0x7F, 0x0, 0x7F, 82, 127,  84, 0x0, 0x3F, 0x7E, OS.TRUE, 10505, 23112, 0xFFFFFFFF, OS.FALSE)
    add_instrument(NES Square Wave 25P, 0x7E, 0x3F, 0x05, 0x04DD, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)

    move_instrument_bank_map()

    // @ Description
    // Loads the instrument bank map from ROM to RAM so that instrument data is properly processed at startup
    scope dmaCopy_moved_bank_map_: {
        OS.patch_start(0x20148, 0x8001F548)
        jal     dmaCopy_moved_bank_map_
        nop
        OS.patch_end()

        OS.save_registers()                             // save registers

        // reload bank table from ROM
        li      a0, moved_inst_bank_map_origin          // load rom address
        li      a1, moved_inst_bank_map                 // load ram address
        li      a2, 0x10 + (instrument_count * 4)       // load length of bank table
        jal     0x80002CA0                              // dmaCopy
        nop

        OS.restore_registers()                          // restore registers

        _end:
        j       0x8001E91C                              // original line 1
        or      a2, s0, r0                              // original line 2
    }

    print "========================================================================== \n"
}

} // __MIDI__

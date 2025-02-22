// DrMario.asm

// This file contains file inclusions, action edits, and assembly for Dr. Mario.

scope DrMario {
    // Insert Moveset files
    insert TAUNT,"moveset/TAUNT.bin"
    insert JAB_1,"moveset/JAB_1.bin"
    insert JAB_2,"moveset/JAB_2.bin"
    insert JAB_3,"moveset/JAB_3.bin"
    insert DASH_ATTACK,"moveset/DASH_ATTACK.bin"
    insert FTILT_HI,"moveset/FORWARD_TILT_HIGH.bin"
    insert FTILT,"moveset/FORWARD_TILT.bin"
    insert FTILT_LO,"moveset/FORWARD_TILT_LOW.bin"
    insert UTILT,"moveset/UP_TILT.bin"
    insert DTILT,"moveset/DOWN_TILT.bin"
    insert FSMASH_HI,"moveset/FORWARD_SMASH_HIGH.bin"
    insert FSMASH_M_HI,"moveset/FORWARD_SMASH_MID_HIGH.bin"
    insert FSMASH,"moveset/FORWARD_SMASH.bin"
    insert FSMASH_M_LO,"moveset/FORWARD_SMASH_MID_LOW.bin"
    insert FSMASH_LO,"moveset/FORWARD_SMASH_MID_LOW.bin"
    insert USMASH,"moveset/UP_SMASH.bin"
    insert DSMASH,"moveset/DOWN_SMASH.bin"
    insert NAIR,"moveset/NEUTRAL_AERIAL.bin"
    insert FAIR,"moveset/FORWARD_AERIAL.bin"
    insert BAIR,"moveset/BACK_AERIAL.bin"
    insert UAIR,"moveset/UP_AERIAL.bin"
    insert DAIR,"moveset/DOWN_AERIAL.bin"
    insert NSP_GROUND, "moveset/NEUTRAL_SPECIAL_AIR.bin"
    insert NSP_AIR, "moveset/NEUTRAL_SPECIAL_GROUND.bin"
    insert USP, "moveset/UP_SPECIAL.bin"
    insert DSP_GROUND, "moveset/DOWN_SPECIAL_GROUND.bin"
    insert DSP_AIR, "moveset/DOWN_SPECIAL_AIR.bin"
    BTHROW:; Moveset.THROW_DATA(BTHROWDATA); insert "moveset/BTHROW.bin"
    insert BTHROWDATA, "moveset/BTHROWDATA.bin"

    // Modify Action Parameters             // Action               // Animation                // Moveset Data             // Flags
    Character.edit_action_parameters(DRM,   Action.Taunt,           File.DRM_TAUNT,             TAUNT,                      -1)
    Character.edit_action_parameters(DRM,   Action.Jab1,            -1,                         JAB_1,                      -1)
    Character.edit_action_parameters(DRM,   Action.Jab2,            -1,                         JAB_2,                      -1)
    Character.edit_action_parameters(DRM,   Action.DashAttack,      -1,                         DASH_ATTACK,                -1)
    Character.edit_action_parameters(DRM,   Action.FTiltHigh,       -1,                         FTILT_HI,                   -1)
    Character.edit_action_parameters(DRM,   Action.FTilt,           -1,                         FTILT,                      -1)
    Character.edit_action_parameters(DRM,   Action.FTiltLow,        -1,                         FTILT_LO,                   -1)
    Character.edit_action_parameters(DRM,   Action.UTilt,           -1,                         UTILT,                      -1)
    Character.edit_action_parameters(DRM,   Action.DTilt,           -1,                         DTILT,                      -1)
    Character.edit_action_parameters(DRM,   Action.FSmashHigh,      -1,                         FSMASH_HI,                  -1)
    Character.edit_action_parameters(DRM,   Action.FSmashMidHigh,   -1,                         FSMASH_M_HI,                -1)   
    Character.edit_action_parameters(DRM,   Action.FSmash,          -1,                         FSMASH,                     -1)   
    Character.edit_action_parameters(DRM,   Action.FSmashMidLow,    -1,                         FSMASH_M_LO,                -1)   
    Character.edit_action_parameters(DRM,   Action.FSmashLow,       -1,                         FSMASH_LO,                  -1)   
    Character.edit_action_parameters(DRM,   Action.USmash,          -1,                         USMASH,                     -1)
    Character.edit_action_parameters(DRM,   Action.DSmash,          -1,                         DSMASH,                     -1)
    Character.edit_action_parameters(DRM,   Action.AttackAirN,      -1,                         NAIR,                       -1)
    Character.edit_action_parameters(DRM,   Action.AttackAirF,      File.DRM_FAIR,              FAIR,                       -1)
    Character.edit_action_parameters(DRM,   Action.AttackAirB,      -1,                         BAIR,                       -1)
    Character.edit_action_parameters(DRM,   Action.AttackAirU,      -1,                         UAIR,                       -1)
    Character.edit_action_parameters(DRM,   Action.AttackAirD,      File.DRM_DAIR,              DAIR,                       0) 
    Character.edit_action_parameters(DRM,   0xDC,                   -1,                         JAB_3,                      -1)
    Character.edit_action_parameters(DRM,   0xDF,                   -1,                         NSP_GROUND,                 -1)
    Character.edit_action_parameters(DRM,   0xE0,                   -1,                         NSP_AIR,                    -1)
    Character.edit_action_parameters(DRM,   0xE1,                   -1,                         USP,                        -1)
    Character.edit_action_parameters(DRM,   0xE2,                   -1,                         USP,                        -1)
    Character.edit_action_parameters(DRM,   0xE3,                   -1,                         DSP_GROUND,                 -1)
    Character.edit_action_parameters(DRM,   0xE4,                   -1,                         DSP_AIR,                    -1) 
    Character.edit_action_parameters(DRM,   Action.ThrowB,          File.DRM_BTHROW,            BTHROW,                     0x50000000)
    
    // Modify Menu Action Parameters                // Action           // Animation                // Moveset Data             // Flags
    
    Character.edit_menu_action_parameters(DRM,      0xE,                File.DRM_1P_CPU_POSE,       0x80000000,                 -1)
    
    // Set crowd chant FGM.
    Character.table_patch_start(crowd_chant_fgm, Character.id.DRM, 0x2)
    dh  0x02EB
    OS.patch_end()
    
    // Set Kirby hat_id
    Character.table_patch_start(kirby_inhale_struct, 0x2, Character.id.DRM, 0xC)
    dh 0x10
    OS.patch_end()

    // Set default costumes
    Character.set_default_costumes(Character.id.DRM, 0, 1, 2, 4, 1, 3, 4)
    
    // Hardcoding for when Mario Clones use Pipes, ensures they face the correct way when entering
    // TEMP LOCATION
    scope pipe_turn_enter: {
        OS.patch_start(0xBCC40, 0x80142200)
        j       pipe_turn_enter             
        nop                                 // original line 2
        _return:
        OS.patch_end()
        
        beq     v0, r0, _mario_turn         // modified original line 1, correct turn
        addiu   at, r0, Character.id.JMARIO // J Mario ID
        beq     v0, at, _mario_turn         // correct turn
        addiu   at, r0, Character.id.JLUIGI // J Luigi ID
        beq     v0, at, _mario_turn         // correct turn
        addiu   at, r0, Character.id.WARIO  // Wario ID
        beq     v0, at, _mario_turn         // correct turn
        addiu   at, r0, Character.id.DRM    // Dr. Mario ID
        beq     v0, at, _mario_turn         // correct turn
        nop
        j       _return                     // return
        addiu   at, r0, 0x000D              // reinserting in the interest of caution
        
        _mario_turn:
        j       0x80142228                  // modified original line 1, routine having Mario properly turn during Pipe animation
        addiu   at, r0, 0x000D              // reinserting in the interest of caution
    }
    
    // Hardcoding for when Mario Clones use Pipes, ensures they face the correct way when exiting
    // TEMP LOCATION
    scope pipe_turn_exit: {
        OS.patch_start(0xBD19C, 0x8014275C)
        j       pipe_turn_exit          
        sw      t5, 0x0B3C(s0)              // original line 2
        _return:
        OS.patch_end()
        
        beq     v0, r0, _mario_turn         // modified original line 1, correct turn
        addiu   at, r0, Character.id.JMARIO // J Mario ID
        beq     v0, at, _mario_turn         // correct turn
        addiu   at, r0, Character.id.JLUIGI // J Luigi ID
        beq     v0, at, _mario_turn         // correct turn
        addiu   at, r0, Character.id.WARIO  // Wario ID
        beq     v0, at, _mario_turn         // correct turn
        addiu   at, r0, Character.id.DRM    // Dr. Mario ID
        beq     v0, at, _mario_turn         // correct turn
        nop
        j       _return                     // return
        nop
        
        _mario_turn:
        j       0x801427AC                  // modified original line 1, routine having Mario properly turn during Pipe animation
        nop
    }
}

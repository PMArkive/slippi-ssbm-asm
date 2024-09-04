################################################################################
# Address: 0x801a500c # updateFunction
################################################################################

.include "Common/Common.s"
.include "Common/FastForward/FunctionMacros.s"

getMinorMajor r3
cmpwi r3, 0x0202
bne EXIT

# Allow loop to exit for the first frame so that the game gets displayed once before no longer
# rendering frames
loadGlobalFrame r3
cmpwi r3, 1
ble EXIT

# Load game end ID, if non-zero, game ended
load r3, 0x8046b6a0
lbz r3, 0x8(r3)
cmpwi r3, 0
beq CONTINUE_LOOPING

# Here the game ended, let's break out of the entire updateFunction to prevent a crash when drawing
# shadows?
branch r12, 0x801a508c

CONTINUE_LOOPING:
# Exec camera tasks to prevent desyncs. This might not be needed for AI training so I'll keep it
# commented out for now. If this is uncommented the line lower in the file must be as well.
# bl FN_ExecCameraTasks

# Fake that there is an input ready
load r4, 0x804c1f78
li r3, 1
stb r3, 0x3(r4)

addi r26, r26, 1
branch r12, 0x801a4de4 # back to start of loop

# Camera tasks function body
# FunctionBody_ExecCameraTasks # Adds FN_ExecCameraTasks

EXIT:
lwz	r0, 0x000C(r25) # replaced code line
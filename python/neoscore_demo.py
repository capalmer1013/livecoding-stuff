from helpers import render_example

from neoscore.core import neoscore
from neoscore.core.directions import DirectionY
from neoscore.core.flowable import Flowable
from neoscore.core.font import Font
from neoscore.core.layout_controllers import MarginController
from neoscore.core.music_text import MusicText
from neoscore.core.text import Text
from neoscore.core.units import ZERO, Mm
from neoscore.western.barline import Barline
from neoscore.western.beam_group import BeamGroup
from neoscore.western.brace import Brace
from neoscore.western.chordrest import Chordrest
from neoscore.western.clef import Clef
from neoscore.western.duration import Duration
from neoscore.western.dynamic import Dynamic
from neoscore.western.instrument_name import InstrumentName
from neoscore.western.key_signature import KeySignature
from neoscore.western.staff import Staff
from neoscore.western.staff_group import StaffGroup
from neoscore.western.system_line import SystemLine
from neoscore.western.time_signature import TimeSignature

neoscore.setup()

expressive_font = Font("Lora", Mm(4), italic=True)

flowable = Flowable((Mm(0), Mm(0)), None, Mm(500), Mm(30), Mm(10), Mm(20))
# Indent first line
flowable.provided_controllers.add(MarginController(ZERO, Mm(20)))
flowable.provided_controllers.add(MarginController(Mm(1), ZERO))

staff_group = StaffGroup()
upper_staff = Staff((Mm(0), Mm(0)), flowable, Mm(500), staff_group)
lower_staff = Staff((Mm(0), Mm(20)), flowable, Mm(500), staff_group)
staves = [upper_staff, lower_staff]
brace = Brace(staves)
SystemLine(staves)

# We can use the same unit in the upper and lower staves since they
# are the same size
unit = upper_staff.unit

upper_clef = Clef(unit(0), upper_staff, "treble")
lower_clef = Clef(unit(0), lower_staff, "bass")

KeySignature(ZERO, upper_staff, "g_major")
KeySignature(ZERO, lower_staff, "g_major")

TimeSignature(ZERO, upper_staff, (3, 4))
TimeSignature(ZERO, lower_staff, (3, 4))

InstrumentName((upper_staff.unit(-3), brace.center_y), upper_staff, "Piano", "pno")

Dynamic((unit(-4), unit(6.5)), upper_staff, "p")
Text((unit(-1), unit(6.5)), upper_staff, "dolce", expressive_font)

# BAR 1 ###################################################

# Upper staff notes
Chordrest(unit(0), upper_staff, ["g'"], Duration(1, 4))
Chordrest(unit(4), upper_staff, ["g'"], Duration(1, 4))
a = Chordrest(unit(8), upper_staff, ["a'"], Duration(3, 16))
MusicText((unit(-1), unit(-2)), a, "ornamentMordent")
b = Chordrest(unit(11), upper_staff, ["b'"], Duration(1, 16))
BeamGroup([a, b])

# Lower staff notes - upper voice
Chordrest(unit(2), lower_staff, None, (1, 4), unit(-3))
Chordrest(unit(8), lower_staff, ["d"], Duration(1, 4), stem_direction=DirectionY.UP)

# Lower staff notes - middle voice
Chordrest(unit(0), lower_staff, None, (1, 4), rest_y=unit(-2))
Chordrest(unit(4), lower_staff, ["b,"], Duration(2, 4), stem_direction=DirectionY.UP)

# Lower staff notes - lower voice
Chordrest(unit(0), lower_staff, ["g,"], Duration(3, 4))

Barline(unit(14), staves)

# BAR 2 ###################################################

b2 = unit(15)

# Upper staff notes
a = Chordrest(b2, upper_staff, ["a'"], (1, 8))
b = Chordrest(b2 + unit(3), upper_staff, ["f'"], (1, 8))
Chordrest(b2 + unit(6), upper_staff, ["d'"], (1, 2))
BeamGroup([a, b])
# grace notes should be used here, but they aren't supported yet

# Lower staff notes (same pattern as prev bar)

# Lower staff notes - upper voice
Chordrest(b2 + unit(4), lower_staff, None, (1, 4), rest_y=unit(-3))
Chordrest(
    b2 + unit(9),
    lower_staff,
    ["d"],
    Duration(1, 4),
    stem_direction=DirectionY.UP,
)

# Lower staff notes - middle voice
Chordrest(b2, lower_staff, None, (1, 4), rest_y=unit(-2))
Chordrest(
    b2 + unit(6),
    lower_staff,
    ["a,"],
    Duration(2, 4),
    stem_direction=DirectionY.UP,
)

# Lower staff notes - lower voice
Chordrest(b2, lower_staff, ["f,"], Duration(3, 4))


render_example("goldberg")
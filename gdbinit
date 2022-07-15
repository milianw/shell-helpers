#
# BEGIN SETUP:
# - add the following lines (without the leading #) to your ~/.gdbinit:
# - make sure to adapt the paths
#

#
python
import sys
sys.path.insert(0, '/home/milian/projects/compiled/kf5-dbg/share/kdevgdb/printers')
sys.path.insert(0, '/home/milian/.bin/gdb-printers')
end
#

#
# END SETUP
#

python

from qt import register_qt_printers
register_qt_printers (None)

from kde import register_kde_printers
register_kde_printers (None)

import libpython

end

source ~/.bin/signals.gdb

set index-cache enabled on
maint set worker-threads 8

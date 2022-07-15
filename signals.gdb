# Copyright (C) 2016 Pedro Alves
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This script defines the "info signal-dispositions" command, a
# command to list signal dispositions.
#
# To "install", copy the file somewhere, and add this to your .gdbinit
# file:
#
# source /path/to/signals.gdb
#
# Should probably be rewritten in gdb/Python, but ...

# Example output (gdb debugging itself):
#
#   (gdb) info signal-dispositions
#   Number  Name            Description                     Disposition
#   1       SIGHUP          Hangup                          handle_sighup(int) in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   2       SIGINT          Interrupt                       rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   3       SIGQUIT         Quit                            rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   4       SIGILL          Illegal instruction             SIG_DFL
#   5       SIGTRAP         Trace/breakpoint trap           SIG_DFL
#   6       SIGABRT         Aborted                         SIG_DFL
#   7       SIGBUS          Bus error                       SIG_DFL
#   8       SIGFPE          Floating point exception        handle_sigfpe(int) in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   9       SIGKILL         Killed                          SIG_DFL
#   10      SIGUSR1         User defined signal 1           SIG_DFL
#   11      SIGSEGV         Segmentation fault              SIG_DFL
#   12      SIGUSR2         User defined signal 2           SIG_DFL
#   13      SIGPIPE         Broken pipe                     SIG_IGN
#   14      SIGALRM         Alarm clock                     rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   15      SIGTERM         Terminated                      rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   16      SIGSTKFLT       Stack fault                     SIG_DFL
#   17      SIGCHLD         Child exited                    sigchld_handler(int) in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   18      SIGCONT         Continued                       tui_cont_sig(int) in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   19      SIGSTOP         Stopped (signal)                SIG_DFL
#   20      SIGTSTP         Stopped                         rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   21      SIGTTIN         Stopped (tty input)             rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   22      SIGTTOU         Stopped (tty output)            rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   23      SIGURG          Urgent I/O condition            SIG_DFL
#   24      SIGXCPU         CPU time limit exceeded         GC_restart_handler in section .text of /lib64/libgc.so.1
#   25      SIGXFSZ         File size limit exceeded        SIG_IGN
#   26      SIGVTALRM       Virtual timer expired           SIG_DFL
#   27      SIGPROF         Profiling timer expired         SIG_DFL
#   28      SIGWINCH        Window changed                  tui_sigwinch_handler(int) in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   29      SIGIO           I/O possible                    SIG_DFL
#   30      SIGPWR          Power failure                   GC_suspend_handler in section .text of /lib64/libgc.so.1
#   31      SIGSYS          Bad system call                 SIG_DFL
#   34      SIG34           Real-time signal 0              SIG_DFL
#   35      SIG35           Real-time signal 1              SIG_DFL
#   [...]
#
#   (gdb) info signal-dispositions 2 5
#   Number  Name            Description                     Disposition
#   2       SIGINT          Interrupt                       rl_signal_handler in section .text of /home/pedro/brno/pedro/gdb/mygit/build/gdb/gdb
#   5       SIGTRAP         Trace/breakpoint trap           SIG_DFL
#

# Print the disposition of all signals, or optionally of the given
# signals (up to 10 arguments).
#
# Usage:
#  (gdb) info signal-dispositions [SIGNUM1 SIGNUM12 ...]
#
define info signal-dispositions
  __isd_print_tbl_hdr

  printf "%d %s\n", argc, arg0

  if argc == 0
    __isd_info_all_signal_dispositions
  else
    # Looping over args 0..argc and using eval to extract the current
    # arg doesn't work, because "eval" command misses replacing argN.
    # See <https://sourceware.org/bugzilla/show_bug.cgi?id=20559>.  We
    # get to unroll the loop manually.
    if argc >= 1
      __isd_info_signal_disposition $arg0
    end
    if argc >= 2
      __isd_info_signal_disposition $arg1
    end
    if $argc >= 3
      __isd_info_signal_disposition $arg2
    end
    if $argc >= 4
      __isd_info_signal_disposition $arg3
    end
    if $argc >= 5
      __isd_info_signal_disposition $arg4
    end
    if $argc >= 6
      __isd_info_signal_disposition $arg5
    end
    if $argc >= 7
      __isd_info_signal_disposition $arg6
    end
    if $argc >= 8
      __isd_info_signal_disposition $arg7
    end
    if $argc >= 9
      __isd_info_signal_disposition $arg8
    end
    if $argc >= 10
      __isd_info_signal_disposition $arg9
    end
  end
end

# Helpers go below.

# Print the disposition of a single signal, given by $arg0.
define __isd_info_signal_disposition
  set $_isd_size = sizeof (struct sigaction)
  __isd_mmap $_isd_size
  if $_isd_mmap_res != (void *) -1
    set $_isd_p = (struct sigaction *) $_isd_mmap_res
    __isd_print_disposition $arg0 $_isd_p
    __isd_munmap $_isd_p $_isd_size
  end
end

# Prints the disposition of all signals.
define __isd_info_all_signal_dispositions
  set $_isd_size = sizeof (struct sigaction)
  __isd_mmap $_isd_size
  if $_isd_mmap_res != (void *) -1
    set $_isd_p = (struct sigaction *) $_isd_mmap_res
    set $_isd_i = 1
    set $_isd_nsig = 64
    while $_isd_i < $_isd_nsig
      __isd_print_disposition $_isd_i $_isd_p
      set $_isd_i = $_isd_i + 1
    end
    __isd_munmap $_isd_p $_isd_size
  end
end

# Call mmap in the inferior.  $arg0 is the requested size.  Returns in $_isd_mmap_res
define __isd_mmap
  set $_isd_size = $arg0
  # PROT_READ(1) | PROT_WRITE(2)
  set $_isd_prot = 0x1 | 0x2
  # MAP_PRIVATE(2) | MAP_ANONYMOUS(0x20)
  set $_isd_flags = 0x2 | 0x20
  set $_isd_mmap = (void *(*) (void *, size_t, int, int, int, off_t)) mmap
  set $_isd_mmap_res = $_isd_mmap (0, $_isd_size, $_isd_prot, $_isd_flags, -1, 0)
end

# Call munmap in the inferior.  $arg0 is address, and $arg1 is the size.
define __isd_munmap
  set $_isd_munmap = (int (*) (void *, size_t)) munmap
  call (void) $_isd_munmap ($arg0, $arg1)
end

# Print the table header.
define __isd_print_tbl_hdr
  printf "%s\t%-9s\t%-24s\t%s\n", "Number", "Name", "Description", "Disposition"
  end

# Helper that prints the disposition of a single signal.  First arg is
# signal number, second is sigaction pointer.
define __isd_print_disposition
  set $_isd_sig = $arg0
  set $_isd_p = $arg1
  set $_isd_res = __sigaction ($arg0, 0, $_isd_p)
  if $_isd_res == 0
    printf "%d\t", $_isd_sig
    if $_isd_sig < 32
      __isd_signame $_isd_sig
    else
      printf "SIG%d    ", $_isd_sig
    end
    printf "\t"
    if _new_sys_siglist[$arg0] != 0
      printf "%-24s", _new_sys_siglist[$arg0]
    else
      if $arg0 >= 34
	printf "Real-time signal %d", $arg0 - 34
	printf "%10s", ""
      else
	printf "Unknown signal %d", $arg0
	printf "%10s", ""
      end
    end
    printf "\t"
    # Avoid "__sigaction_handler.sa_handler" because of
    # #define sa_handler __sigaction_handler.sa_handler
    if (long) $_isd_p->__sigaction_handler == 0
      printf "SIG_DFL\n"
    else
      if (long) $_isd_p->__sigaction_handler == 1
	printf "SIG_IGN\n"
      else
	info symbol (long) $_isd_p->__sigaction_handler
      end
    end
  end
end

# Mapping of signal numbers to names.
define __isd_signame
  if $arg0 == 1
    printf "%-9s", "SIGHUP"
  end
  if $arg0 == 2
    printf "%-9s", "SIGINT"
  end
  if $arg0 == 3
    printf "%-9s", "SIGQUIT"
  end
  if $arg0 == 4
    printf "%-9s", "SIGILL"
  end
  if $arg0 == 5
    printf "%-9s", "SIGTRAP"
  end
  if $arg0 == 6
    printf "%-9s", "SIGABRT"
  end
  if $arg0 == 7
    printf "%-9s", "SIGBUS"
  end
  if $arg0 == 8
    printf "%-9s", "SIGFPE"
  end
  if $arg0 == 9
    printf "%-9s", "SIGKILL"
  end
  if $arg0 == 10
    printf "%-9s", "SIGUSR1"
  end
  if $arg0 == 11
    printf "%-9s", "SIGSEGV"
  end
  if $arg0 == 12
    printf "%-9s", "SIGUSR2"
  end
  if $arg0 == 13
    printf "%-9s", "SIGPIPE"
  end
  if $arg0 == 14
    printf "%-9s", "SIGALRM"
  end
  if $arg0 == 15
    printf "%-9s", "SIGTERM"
  end
  if $arg0 == 16
    printf "%-9s", "SIGSTKFLT"
  end
  if $arg0 == 17
    printf "%-9s", "SIGCHLD"
  end
  if $arg0 == 18
    printf "%-9s", "SIGCONT"
  end
  if $arg0 == 19
    printf "%-9s", "SIGSTOP"
  end
  if $arg0 == 20
    printf "%-9s", "SIGTSTP"
  end
  if $arg0 == 21
    printf "%-9s", "SIGTTIN"
  end
  if $arg0 == 22
    printf "%-9s", "SIGTTOU"
  end
  if $arg0 == 23
    printf "%-9s", "SIGURG"
  end
  if $arg0 == 24
    printf "%-9s", "SIGXCPU"
  end
  if $arg0 == 25
    printf "%-9s", "SIGXFSZ"
  end
  if $arg0 == 26
    printf "%-9s", "SIGVTALRM"
  end
  if $arg0 == 27
    printf "%-9s", "SIGPROF"
  end
  if $arg0 == 28
    printf "%-9s", "SIGWINCH"
  end
  if $arg0 == 29
    printf "%-9s", "SIGIO"
  end
  if $arg0 == 30
    printf "%-9s", "SIGPWR"
  end
  if $arg0 == 31
    printf "%-9s", "SIGSYS"
  end
end

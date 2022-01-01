import inspect
import os
import traceback
import subprocess


class CLog:
    '''
    Simple colored logger. TODO: Integrate with new python logging module.

    Note: Do not implement pprint as part of this. It is hard to handle. We
    expect user to use pprint.pforamat to obtain a formatted string and provide
    that as the argument to functions here.

    Overall this is a poor design. How do you even disable debug in this setup?
    the logger has no state.

    An alternative approach in the future would be to use decorators to catch
    each of these functions and add the print colors before execution and after
    execution.
    '''
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    PURPLE = '\e[1;95m'
    WARNING = '\033[93m'
    BOLD = '\033[1m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    UNDERLINE = '\033[4m'
    RED = FAIL
    DEBUG = BOLD + OKCYAN + RED
    CKEY = 'CLOG_COLOR_ON'
    # Set color_on to whatever int user set if available.
    COLOR_ON = int(os.environ[CKEY]) if CKEY in os.environ else False
    # Set this to false to remove prefix strings in info and warning strings.
    PRE_WARN_ON = False
    PRE_INFO_ON = False

    @staticmethod
    def get_ST_ED(func):
        '''get start, end'''
        strbase, c, end = None, None, ''
        if func == CLog.debug:
            strbase = '[DEBUG] '
            c = CLog.DEBUG
        elif func == CLog.info:
            strbase = '[INFO ] '
            c = CLog.OKBLUE
        elif func == CLog.warning:
            strbase = '[WARN ] '
            c = CLog.WARNING
        elif func == CLog.fail:
            strbase = '[FAIL ] '
            c = CLog.FAIL
        elif func == CLog.debug:
            c = CLog.WARNING
            strbase = '[DEBUG] '
        else:
            raise NotImplementedError
        if CLog.COLOR_ON:
            strbase = c + strbase
            end = CLog.ENDC
        return strbase, end

    @staticmethod
    def debug(*args, **kwargs):
        callerframerecord = inspect.stack()[1]
        frame = callerframerecord[0]
        info = inspect.getframeinfo(frame)
        fn = os.path.basename(info.filename)
        # Regular print
        St, Ed = CLog.get_ST_ED(CLog.debug)
        print(St, end='')
        print(fn + ':%s:%s' % (info.function, info.lineno), *args,
              Ed, **kwargs)

    @staticmethod
    def info(*args, **kwargs):
        callerframerecord = inspect.stack()[1]
        frame = callerframerecord[0]
        info = inspect.getframeinfo(frame)
        fn = os.path.basename(info.filename)
        # Regular print
        St, Ed = CLog.get_ST_ED(CLog.info)
        print(St, end='')
        pre = ''
        if CLog.PRE_INFO_ON:
            pre = fn + ':%s:%s' % (info.function, info.lineno)
        print(pre, *args, Ed, **kwargs)

    @staticmethod
    def warning(*args, **kwargs):
        callerframerecord = inspect.stack()[1]
        frame = callerframerecord[0]
        info = inspect.getframeinfo(frame)
        fn = os.path.basename(info.filename)
        # Regular print
        St, Ed = CLog.get_ST_ED(CLog.warning)
        print(St, end='')
        pre = ''
        if CLog.PRE_INFO_ON:
            pre = fn + ':%s:%s' % (info.function, info.lineno)
        print(pre, *args, Ed, **kwargs)

    @staticmethod
    def fail(*args, **kwargs):
        callerframerecord = inspect.stack()[1]
        frame = callerframerecord[0]
        info = inspect.getframeinfo(frame)
        fn = os.path.basename(info.filename)
        # Regular print
        St, Ed = CLog.get_ST_ED(CLog.fail)
        print(St, end='')
        print(fn + ':%s:%s' % (info.function, info.lineno))
        print(fn + ':%s:%s' % (info.function, info.lineno))
        for cfr in list(reversed(inspect.stack()))[:-1]:
            frame = cfr[0]
            info = inspect.getframeinfo(frame)
            fname, lno, fn, code, idx = info
            print("In %s:%d: %s" % (fname, lno, fn))
            print("\t%s" % code[idx].strip())
        print(*args, Ed, **kwargs)


def git(*args):
    '''
    A simple wrapper to enable git command execution from python.

    Examples:
        git("status")
        git("clone", "git://git.xyz.com/platform/manifest.git", "-b", "jb_2.5")
    '''
    return subprocess.check_call(['git'] + list(args))


#!/bin/bash
# ------------------------------------------------------------------------------
# 
# File: io.sh
# Author: Gabe Gonzalez
# 
# Brief: A compilation of utility functions focusing on I/O operations, like
#        printing.
# 
# Notes: To use some of the functionality, certain global variables are needed:
# 
#        - PROG    : Name of the program.
#        - PROGRAM : Same as PROG.
#        - VERBOSE : Verbose output.
#        - LOG     : Path of the log file.
#        - LOGFILE : Same as LOG.
# 
# ------------------------------------------------------------------------------

##
# Exit statuses.
##
ENORM=0
EGETOPT=1
EARG=2
EARGS=2

###
# Print an informational message.
##
print_info()
{
    print_out ":: ${@}"
    log_out "info" "${@}"
    return 0
}

##
# Print a warning message.
##
print_warn()
{
    print_out "~~ ${@}"
    log_out "warning" "${@}"
    return 0
}

##
# Print an error message.
##
print_err()
{
    local prog="PROG"
    if [ -n "${PROG}" ]
    then
        prog="${PROG}"
    elif [ -n "${PROGRAM}" ]
    then
        prog="${PROGRAM}"
    elif [ -n "${PROJECT}" ]
    then
        prog="${PROJECT}"
    else
        :
    fi
    echo "${prog}: ${@}" 1>&2
    log_out "error" "${@}"
    return 0
}

##
# Print output.
##
print_out()
{
    if [ -z "${VERBOSE}" ]
    then
        return 1
    fi
    echo "${@}"
}

##
# Log output.
##
log_out()
{
    if [ -n "${LOG}" -o -n "${LOGFILE}" ]
    then
        local type="$(str_to_upper "${1}")"
        local log=
        shift
        [ -n "${LOG}" ]     && log="${LOG}"
        [ -n "${LOGFILE}" ] && log="${LOGFILE}"
        echo "[$(get_log_timestamp)] ${type}: ${@} >> ${log}" #>> "${log}"
    fi
}

##
# Convert a string to all uppercase characters.
##
str_to_upper()
{
    echo "${@}" | tr '[:lower:]' '[:upper:]'
}

##
# Convert a string to all lowercase characters.
##
str_to_lower()
{
    echo "${@}" | tr '[:upper:]' '[:lower:]'
}

##
# Convert first character in string to a capital, and every other character
# after it to lowercase.
##
str_to_capital()
{
    local str="${@}"
    if [ -z "${str}" ]
    then
        return
    fi
    local firstchar=$(echo "${str:0:1}" | tr '[a-z]' '[A-Z]')
    local restchar=$(echo "${str:1}" | tr '[A-Z]' '[a-z]')
    echo "${firstchar}${restchar}"
}

##
# Return the current time in a uniform format.
##
get_log_timestamp()
{
    local fmt="%F %T %z"
    date +"${fmt}"
}

##
# Check if the input value is an integer.
##
is_integer()
{
    if [ "${1}" -eq "${1}" ] 2>/dev/null
    then
        return 0
    else
        return 1
    fi
}

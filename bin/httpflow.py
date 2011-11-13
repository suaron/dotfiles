#!/usr/bin/env python

import sys
import os
import getopt

import re

import string
import StringIO

import types
import socket


def usage(msg, exitCode=1):
    if msg:
        sys.stderr.write('\nerror: %s\n\n' % msg)
    sys.stderr.write('''usage: httpflow.py

    Reads tcpflow output from stdin, parses and filters HTTP conversations, writes summary of header information to stdout.

    --help:  print this usage information and exit

    --include <expr>: Report only headers that match regular expression <expr>.  Can appear multiple times on command line.  Each expression is appended together with an or.  I.e. '<expr>|<expr>|<expr>.'

    --exclude <expr>: Do not report headers that match regular expression <expr.  Can appear multiple times.

    --bodies: Print the bodies of messages whose headers matched

    --replies: print the responses to messages whose headers matched
    
    Example:  To track the passing of cookies back and forth, use something like:

    sudo tcpflow -c port 80 | python httpflow.py --include 'Cookie' --include 'Set-Cookie'

    To see all of the text content, use something like:

    sudo tcpflow -c port 80 | python ./httpflow.py --include 'Content-Type: text' --bodies
''')
    sys.exit(exitCode)


def checkOpt(oD, shortName, longName, defaultValue, setValue=1):
    if oD.has_key(shortName):
        possibleValue = oD[shortName]
    elif oD.has_key(longName):
        possibleValue = oD[longName]
    else:
        return defaultValue

    if possibleValue == '':
        return setValue
    else:
        return possibleValue


bodiesFlag = 0  # should print bodies of matching headers? 1/0
repliesFlag = 0  # should print replies to matching headers? 1/0
# REM: is this the canonical 'false' value? I should look that up...

def main():
    global bodiesFlag
    global repliesFlag

    print 'HTTPFlow Running...'
    
    try:
        optionList, args = getopt.getopt(sys.argv[1:], 'hi:e:br', ['help', 'include=', 'exclude=', 'bodies', 'replies'])
    except:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        usage(exc_value)

    optDict = {}
    for k,v in optionList:
        if not optDict.has_key(k):
            optDict[k] = v
        else:
            oV = optDict[k]
            if not (type(oV) == types.ListType):
                oV = [optDict[k]]
                optDict[k] = oV
            oV.append(v)
            
    if checkOpt(optDict, '-h', '--help', 0):
        usage('Help requested; usage information follows.', exitCode = 2)

    includeHeaders = checkOpt(optDict, '-i', '--include', None)
    excludeHeaders = checkOpt(optDict, '-e', '--exclude', None)

    bodiesFlag =  checkOpt(optDict, '-b', '--bodies', 0)
    repliesFlag =  checkOpt(optDict, '-r', '--replies', 0)
    
    includeRE = None
    if includeHeaders:
        if not (type(includeHeaders) == types.ListType):
            includeHeaders = [includeHeaders]
        if len(includeHeaders):
            includeExpr = string.join( includeHeaders, "|" )
            print "Include expr: %s" % includeExpr
            includeRE = re.compile( includeExpr  )

    excludeRE = None
    if excludeHeaders:
        if not (type(excludeHeaders) == types.ListType):
            excludeHeaders  = [excludeHeaders]
        if len(excludeHeaders):
            excludeExpr = string.join( excludeHeaders, "|" )
            print "Exclude expr: %s" % excludeExpr
            excludeRE = re.compile( excludeExpr )
    
    parseStream(includeRE, excludeRE)


communicationsStartRE = re.compile(r'''
^(?P<SourceAddress>[\d]+\.[\d]+\.[\d]+\.[\d]+)\.(?P<SourcePort>[\d]+)-
(?P<DestinationAddress>[\d]+\.[\d]+\.[\d]+\.[\d]+)\.(?P<DestinationPort>[\d]+):\s*
(?P<Data>.*)$
''', re.VERBOSE)

# REM: ought to rewrite this so it works off of the 'Data' field of the above...actually, may be able to eliminate this one completely...
headerStartRE = re.compile(r'''
^(?P<SourceAddress>[\d]+\.[\d]+\.[\d]+\.[\d]+)\.(?P<SourcePort>[\d]+)-
(?P<DestinationAddress>[\d]+\.[\d]+\.[\d]+\.[\d]+)\.(?P<DestinationPort>[\d]+):\s*
(?P<Data>.*HTTP/1.*)$
''', re.VERBOSE)

headerStopRE = re.compile('''^(\r|\n)*$''')

outstandingMessages = {}
printableMessages = {}

messageKey = ''  # the key of the 'current' message
responseKey = ''  # the (future) messageKey of the response to the 'current' message

# Note: possible parse modes are:
#       'scan' to watch for the beginning of a section;
#       'header' to scan, assemble headers, and watch for the end of the header section;
#       'body' prints lines from the body of the message and instructs scan() to end the body section neatly if a new section starts.

parseMode = 'scan' # FIXME: should do these with constants of some kind...

def parseStream(inclusionExpr, exclusionExpr):
    while 1:
        inputLine = sys.stdin.readline()
        if inputLine == '':
            return

        if not scan(inputLine):
            if parseMode == 'header':
                header(inputLine, inclusionExpr, exclusionExpr)

            if parseMode == 'body':
                body(inputLine)


# REM: this method is way too big and has its fingers in way too many pies...
def scan(inputLine):
    global parseMode
    global messageKey
    global responseKey

    blip = 0  # return value
    
    startMatch = communicationsStartRE.match(inputLine)
    if startMatch:
        blip = 1

        if parseMode == 'body':
            # close out the body that was just being printed
            parseMode = 'scan'
            print "----- end body -----"
            print
        
        sA = startMatch.group('SourceAddress')
        dA = startMatch.group('DestinationAddress')
        sP = int(startMatch.group('SourcePort'))
        dP = int(startMatch.group('DestinationPort'))
        
        messageKey = "%s:%d" % (dA, dP)

        headerMatch = headerStartRE.match(inputLine)
        if headerMatch:  # header mode
            parseMode = 'header'

            print "--- begin header ---"

            if outstandingMessages.has_key(messageKey):  # if we saw this message go out...
                print "From request: " + outstandingMessages[messageKey]  # ...print what it is responding to
            
            print "Source: %s : %d (%s)" % (sA, sP , nameFromIP(sA))
            print "Destination: %s : %d (%s)" % (dA, dP, nameFromIP(dA))
            
            print

            data = headerMatch.group('Data')
        
            print data
        
            if string.find(data, "HTTP/1") > 0:
                responseKey = "%s:%d" % (sA, sP)
                outstandingMessages[responseKey] = data
                printableMessages[messageKey] = 0
                printableMessages[responseKey] = 0
                
        else: # body mode
            if shouldPrintBody(messageKey):
                parseMode = 'body'

                print "---- begin body ----"

                if outstandingMessages.has_key(messageKey):  # if we saw this message go out...
                    print "From request: " + outstandingMessages[messageKey]  # ...print what it is responding to
            
                print "Source: %s : %d (%s)" % (sA, sP , nameFromIP(sA))
                print "Destination: %s : %d (%s)" % (dA, dP, nameFromIP(dA))
                
                print

                data = startMatch.group('Data')
                print data
        
    return blip


def header(inputLine, inclusionExpr, exclusionExpr):
    # look for transition out of headers
    global parseMode
    
    endMatch = headerStopRE.match(inputLine)
    if endMatch:
        print "---- end header ----"
        print
        if shouldPrintBody(messageKey):
            parseMode = 'body'
            print "---- begin body ----"
        else:
            parseMode = 'scan'
    
    else:
        inputLine = string.replace(inputLine, '\r', '')
        inputLine = string.replace(inputLine, '\n', '')

        if inclusionExpr and not inclusionExpr.match(inputLine):
            return

        if exclusionExpr and exclusionExpr.match(inputLine):
            return

        # inputLine has passed the filters, we have A WINNER!!
        print inputLine
        if bodiesFlag:
            printableMessages[messageKey] = 1 # header matched, print body
        if repliesFlag:
            printableMessages[responseKey] = 1 # header matched, print reply


def body(inputLine):
    if shouldPrintBody(messageKey):
        print inputLine


def shouldPrintBody(key):
    return printableMessages.has_key(key) and printableMessages[key] and (bodiesFlag or repliesFlag)


def nameFromIP(anIP):
    try:
        return socket.gethostbyaddr(anIP)[0]
    except:
        return "-unknown-"

    
if __name__ == "__main__":
    main()


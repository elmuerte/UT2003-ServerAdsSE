///////////////////////////////////////////////////////////////////////////////
// filename:    ServerAdsSE.uc
// version:     102
// author:      Michiel 'El Muerte' Hendriks <elmuerte@drunksnipers.com>
// perpose:     displaying messages (advertisements) in every players console.
///////////////////////////////////////////////////////////////////////////////

class ServerAdsSE extends Info config;

const VERSION   = "102";
const MAXLINES  = 25;
const DEBUG     = false;

var bool    bInitialized;
var int     iCurPos;
var int     nLines;

// config options
var globalconfig bool   bEnabled;
var globalconfig float  fDelay;           // delay between a message (seconds)
var globalconfig string sLines[MAXLINES]; // the lines
var globalconfig int    iGroupSize;       // number of lines to show at one
var globalconfig int    iAdType;          // the way to display lines
var globalconfig bool   bWrapAround;      // at the end of the list, start at the beginning
var globalconfig int    iAdminMsgDuration;// seconds that an "admin" message will stay visible
var globalconfig color  cAdminMsgColor;   // color of the admin messages
//  iAdType - description
//  0         display iGroupSize number at the time
//  1         display iGroupSize number of _random_ lines, bWrapAround has no effect
//  2         display iGroupSize number at the time, start at a random position
var globalconfig bool   bUseURL;          // get lines from www
var globalconfig string sURLHost;         // hostname
var globalconfig int    iURLPort;         // webserver port, default 80
var globalconfig string sURLRequest;      // file to request

// initialise this serveractor
function PostBeginPlay()
{
  local int i;
  local string tmp[MAXLINES];

	if (!bInitialized)
  {
    nLines = 0;
    bInitialized = true;
    log("[~] Starting ServerAdsSE version: "$VERSION);
    if (DEBUG) log("[~] * DEBUG compiled *");
    log("[~] Michiel 'El Muerte' Hendriks - elmuerte@drunksnipers.com");
    log("[~] The Drunk Snipers - http://www.drunksnipers.com");
    if (bUseURL) getLinesFromWeb();
    // clean up list
    for (i = 0; i < MAXLINES; i++)
    {
      if (sLines[i] != "") 
      {
        tmp[nLines] = sLines[i];
        nLines++;
      }
    }
    for (i = 0; i < MAXLINES; i++)
    {
      sLines[i] = tmp[i];
    }
    StaticSaveConfig();
    SaveConfig();
    log("[~] There are "$nLines$" lines in the list");
    iCurPos = 0;
    SetTimer(fDelay,true);
  }
}

// update the timer with a new value
function UpdateTimer()
{
  SetTimer(fDelay,true);
}

// broadcast the message
event Timer()
{
  local int i;

  if (!bEnabled) return; // disabled, so return
  if ((iCurPos >= nLines) && (bWrapAround == false)) return;

  switch (iAdType)
  {
    case 0: for (i = 0; i < iGroupSize; i++)
            {
              if (iCurPos >= nLines)
              {
                if (bWrapAround) iCurPos = 0;
                else return;
              }
              BroadcastAd(sLines[iCurPos]);
              iCurPos++;
            }
            break;
    case 1: for (i = 0; i < iGroupSize; i++)
            {
              BroadcastAd(sLines[rand(nLines)]);
            }
            iCurPos = 0; // to make sure bWrapAround has no effect
            break;
    case 2: iCurPos = rand(nLines); // begin at a random position
            for (i = 0; i < iGroupSize; i++)
            {
              if (iCurPos >= nLines)
              {
                if (bWrapAround) iCurPos = 0;
                else return;
              }
              BroadcastAd(sLines[iCurPos]);
              iCurPos++;
            }
            iCurPos = 0; // to make sure bWrapAround has no effect the next time
            break;
  } 
}


// send message to players
event BroadcastAd( coerce string Msg)
{  
  local controller C;

	// center print admin messages which start with #
	if (left(Msg,1) == "#" )
	{
		Msg = right(Msg,len(Msg)-1);
		for( C=Level.ControllerList; C!=None; C=C.nextController )
    {
			if( C.IsA('PlayerController') )
			{
				PlayerController(C).ClearProgressMessages();
				PlayerController(C).SetProgressTime(iAdminMsgDuration);
				PlayerController(C).SetProgressMessage(0, Msg, cAdminMsgColor);
        //class'Canvas'.Static.MakeColor(255,255,255));
			}
    }
    if (DEBUG) log("[D] ServerAdsSE admin line: "$Msg);
		return;
	}
  Level.Game.Broadcast(None, Msg);
  if (DEBUG) log("[D] ServerAdsSE line: "$Msg);
}

function getLinesFromWeb()
{
  local WebDownload wdl;
  if (DEBUG) log("[D] ServerAdsSE Download lines from the web");
  wdl = Spawn( class 'ServerAdsSE.WebDownload' );
  wdl.sHostname = sURLHost;
  wdl.iPort = iURLPort;
  wdl.sRequest = sURLRequest;
  wdl.sase = Self;
  wdl.GetLines();
}

defaultproperties
{
  bEnabled=true
  fDelay=300
  iGroupSize=1
  iAdType=0
  bWrapAround=true
  iAdminMsgDuration=4
  cAdminMsgColor=(B=0,G=255,R=255,A=127);
  bUseURL=false
  sURLHost="localhost"
  iURLPort=80
  sURLRequest="/serverads.txt";
}
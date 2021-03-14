# UT2003-ServerAdsSE

ServerAdsSE is the successor of ServerAdds. This server add-on only works for UT2003 Servers. ServerAdsSE gives you the ability to display advertisements, news (or what ever kind of messages you want) on your server. Players will see these messages in their chat console. It's also possible to display so called "Admin messages".0

# How to install
You have to extract the contents of this zip file to your UT2003 directory. Keep the directory names in tact: the "System" files belong in the "System" directory and the "Web" files belong in the "Web" directory. No files will be overwritten.

Now you have to edit your server configuration (UT2003.ini by default), make sure the server is no longer running. Add the following lines to the configuration:

```
[Engine.GameEngine]
ServerActors=ServerAdsSE.ServerAdsSE
```

If you want to make use of the WebAdmin feature of ServerAdsSE you will also have to add these lines to the configuration.

```
[UWeb.WebServer]
Applications[2]=ServerAdsSE.WebAdmin
ApplicationPaths[2]=/ServerAdsSE
```

Note : Replace the "2" with the first unused number

Note 2: The WebAdmin doesn't need any extra configuration, the Admin username and password are the same as the username and password of the normal WebAdmin.

You have now installed ServerAdsSE. There are two ways to configure ServerAdsSE: edit the configuration file or via the WebAdmin. If you are going to use the WebAdmin (it's the easiest form) you have to start the server, otherwise the server should stay down.

To check if ServerAdsSE is correctly installed you only have to check the server's log file when it has been started. The following lines should be visible:

```
[~] Starting ServerAdsSE version: ###
```

and if you also installed the WebAdmin:

```
[~] ServerAdsSE WebAdmin loaded
```

# Configuration
The configuration of ServerAdsSE belongs in the server configuration files (UT2003.ini by default). Here's an example configuration:

```
    [ServerAdsSE.ServerAdsSE]
    bEnabled=True
    fDelay=300.000000
    sLines[0]=This is the first line
    sLines[1]=And this is the second line
    sLines[2]=#This is a Admin Message
    iAdType=0
    iGroupSize=2
    bWrapAround=True
    bUseURL=False
    sURLHost=
    iURLPort=80
    sURLRequest=
    iAdminMsgDuration=5
    cAdminMsgColor=(B=0,G=255,R=255)
```

### bEnabled
True/False

With this you can turn ServerAds on and off

### fDelay
Number (floating point)

The number of seconds between the messages (1 = one second, 1.5 = one and a half second)

### sLines\[#]
sLines\[0] to sLines\[24]

The linex ServerAdsSE will display (25 max), prefix a line with a '#' to make it an Admin Message

### iAdType
0,1,2

There are 3 diffirent types for displaying the lines

1.    Normal:
    Lines are displayed the order they appear in the list.
2.    Random lines:
    Lines are picked at random from the list.
3.    Random groups:
    The starting line is randomly picked on every cycle. (With a group size of one this type will behave the same way as "Random lines") 

### iGroupSize
Number (integer)

The number of lines to show in every cycle.

### bWrapAround
True/False

With this option enabled ServerAdsSE will continue to the begining of the list after it reached the end of the list.

### iAdminMsgDuration
Number (integer)

The number of seconds an "Admin message" will stay visible.

### cAdminMsgColor
Color (B=0,G=255,R=255)

The color of the "Admin message", use RGB values from 0 to 255.

### bUseURL
True/False

Download the lines to use from a website, this will overwrite the lines in the config file on every map change.

### sURLHost
The hostname of the webserver where the lines are located.

### iURLPort
Number (integer)

The port where the webserver is running, usualy 80.

### sURLRequest
The relative URL from the root of the webserver, it as to start with a '/'.

# Admin messages

When you are logged in as an admin on the game server you can send "Admin messages" by prefixing the chat message with a '#'. An admin message is just like a normal chat message except that it is displayed on the middle of the player's screen in a large font. ServerAdsSE also has the ability to display admin messages, just prefix the line you want to be an admin message with a '#'.

These messages are quite annoying so use them with caution.

# Web Downloads

ServerAdsSE has the ability to download the lines you want to display on the server from a website. To do this you only have to point ServerAdsSE to the server and the location of the file that you want to be downloaded. The file MUST be a plain text file, you can use a script to generate this text file, but be sure you set the content type to "text/plain".

The result of the download will be saved in the configuration file, so the next time ServerAdsSE is started it will use the old lines until the news lines have been downloaded from the server. 

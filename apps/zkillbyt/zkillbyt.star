load("render.star", "render")
load("http.star", "http")
load("humanize.star", "humanize")
load("animation.star","animation")
load("math.star","math")
load("encoding/base64.star", "base64")

ZKILL_URL = "https://redisq.zkillboard.com/listen.php?queueID=QymmPhyton?ttw=3"
CHAR_ID_LOOKUP = "https://esi.evetech.net/latest/characters/%s/?datasource=tranquility"
CORP_ID_LOOKUP = "https://esi.evetech.net/latest/corporations/%s/?datasource=tranquility"
ALLIANCE_ID_LOOKUP = "https://esi.evetech.net/latest/alliances/%s/?datasource=tranquility"
ALLIANCE_CORP_LOOKUP = "https://esi.evetech.net/latest/alliances/%s/corporations/?datasource=tranquility"
NAME_LOOKUP = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility"
SYSTEM_LOOKUP = "https://esi.evetech.net/latest/universe/systems/%s/?datasource=tranquility&language=en"
ICON_LOOKUP= "https://images.evetech.net/types/%s/icon"
ALLIANCE_ID = "99000739" #SOUND ALLIANCE ID
#ALLIANCE_ID = "99005338" #HORDE ALLIANCE ID
#ALLIANCE_ID = "498125261" #TEST ALLIANCE ID
CHARACTER_ID = "2113672544" #Qymm Phyton
#CHARACTER_ID = "2114328667" #Test.
#HIGH_VALUE_FILTER = 10000000000
HIGH_VALUE_FILTER = 1000000000 #1bilISK
DISABLE_FILTER = False
IGNORE_NPC_KILLS = True
DEBUG_MODE = False
ANIMTEST_MODE = False
STORED_CORPS = []
MAX_KILLMAILS = 3
FRAMES_PER_SECOND = 45
TIME_TOTAL = 15*FRAMES_PER_SECOND
MAX_SECONDS_PER_SLIDE = 5

ELMO = base64.decode("""R0lGODlhIAAgAPf/AIYnFtNrC+mEDYITFoUVGJtDC5UZHfGXIoMxBb1DIbJTDGQcCPaYGsJdC7xYC5Y5E3QqBOTEuuF8DpI8CTUKBJpCE2VHSL9mJn0xB34TGksSBbJPC1sbBspkC+yKEqVJDIkzBbxbEpEXGhMBAch7RtlzDaBFCYwYGXwtBHINEkIRBM1pEuSBELhVCmsjBLNJGDwNBP2pKW4KC9mkjY07CZM5BXMSE30SFUUOBXkRFcNhEmQhBYkVGMllE8JdFSsJBI0XGhsDAbJTESMFAjoRBch3OcRgDII1CKZRGVQYBVAVBZVLRI04BuyMHN2GOLp7WtOFVIQsB6tKBZkbHV4eCJtBB2glCNp2E5RACwsAAWMiCd15FNVyEqQ6FZo9CrxVBq5RDoQaFqRFBdBsFMxyJwYBAatNFFogB3QtCMxiBIUcGqE1FcJvLpAyFHEmBL1VEykGAmwpCooUF3cPEpEtFWwQELVRB6lKCdZvDc5oDqtFEdNxGsBaCHkYDncNDqhNDX4UF5c9BpEgGa5NCXsjDYAQFyQIBFoSDlUcCIkSGsqgkqhjRIk1B+eJGsxrG24oBaxPDfmfH3kUFtSsnHkuB6MqG6U+G6FKEng0EZQ2DdN/Nb1gEr1xP+eFFE0XBmMKD5A1BpQpGPGPE4kcGNy9tE4aCZ5HC3AlC7I8GfTZ0pEmFrVTF5oiG/fTwIY7Dt54Daw4GbiYkKc9E0sUBqhDBqRED6pEH10PDsmuq1QWCKtMCpdBCKRICB0HBEUTBnwQGeeGG8NlHi4OBNl2G1kXBpARGZ4uFbBLB0MZC6lDDrCNgI4VGRwMCIpBO7ZXDnkZFuSBF5kXINBoBcdhB7FXFK+MgcdeCqA/BzUOBXYWEzAIA9pFHP9KHKdWSap3ceN+V3gSEvBnNnwQFMY4GvJKIY4THPbSv24wEXgoBGUnCsZnFpcXG99/F0kaB5gwGd6mhe+QGe+LDBYFBMqfj71fGYcQG4c3B9R5K9Obfr9YCeGje8pgCKdIC69IEAMBAv///yH/C05FVFNDQVBFMi4wAwEAAAAh/wtYTVAgRGF0YVhNUDw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDkuMC1jMDAwIDc5LjE3MWMyN2ZhYiwgMjAyMi8wOC8xNi0yMjozNTo0MSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDI0LjAgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjExMjU3NTAwNjA1NzExRUQ4Njg2QjlEODhEMzEzMjcyIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjExMjU3NTAxNjA1NzExRUQ4Njg2QjlEODhEMzEzMjcyIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MTEyNTc0RkU2MDU3MTFFRDg2ODZCOUQ4OEQzMTMyNzIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MTEyNTc0RkY2MDU3MTFFRDg2ODZCOUQ4OEQzMTMyNzIiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4B//79/Pv6+fj39vX08/Lx8O/u7ezr6uno5+bl5OPi4eDf3t3c29rZ2NfW1dTT0tHQz87NzMvKycjHxsXEw8LBwL++vby7urm4t7a1tLOysbCvrq2sq6qpqKempaSjoqGgn56dnJuamZiXlpWUk5KRkI+OjYyLiomIh4aFhIOCgYB/fn18e3p5eHd2dXRzcnFwb25tbGtqaWhnZmVkY2JhYF9eXVxbWllYV1ZVVFNSUVBPTk1MS0pJSEdGRURDQkFAPz49PDs6OTg3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""")

def getCorpsForAlliance(allianceID):
    corps = http.get(ALLIANCE_CORP_LOOKUP %(str(int(allianceID))))
    return corps.json()

def isNPCKill(attackers):
    npcFlag = True
    for attacker in attackers:
        if "character_id" in attacker:
            npcFlag = False
            break
    #print ("npcFlag:", npcFlag)
    return npcFlag

def filter(rep,corps):

    totalValue = rep.json()["package"]["zkb"]["totalValue"]
    if (totalValue >= HIGH_VALUE_FILTER):
        print("High value! Adding.")
        return True, "HIGH VALUE"

    #filter out if pod
    if (rep.json()["package"]["killmail"]["victim"]["ship_type_id"] == 670):
        print("Capsule. Skip.")
        return False, ""

    if DISABLE_FILTER:
        print ("Didn't filter. Adding.")
        return True, "#NOFILTER"

    if IGNORE_NPC_KILLS:
        if isNPCKill(rep.json()["package"]["killmail"]["attackers"]):
            print("NPC Kill. Skip.")
            return False, ""

    #is victim in alliance or is the saved character?      
    victim = rep.json()["package"]["killmail"]["victim"]
    if "character_id" in victim:
        if str(int(victim["character_id"])) == CHARACTER_ID:
            print("Found character in victim.")
            return True, "YOU DIED"

    #are any attackers in alliance or is any attacker the saved character?
    for attacker in rep.json()["package"]["killmail"]["attackers"]:
        if "character_id" in attacker:
            if CHARACTER_ID == str(int(attacker["character_id"])):
                print("Found character in attackers.")
                return True, "NICE KILL!"

        if "alliance_id" in attacker:
            #print (str(int(attacker["alliance_id"])), ALLIANCE_ID)
            if (str(int(attacker["alliance_id"])) == ALLIANCE_ID):
                print ("Found alliance in attackers.")
                return True, "ALLIANCE KILL"
          
    corpID = rep.json()["package"]["killmail"]["victim"]["corporation_id"]
    #print ("CorpID:",corpID)
    #print (corps)
    if corpID in corps:
        print("Found alliance in victim.")
        return True, "ALLIANCE LOSS"

    print("Filters didn't trip. Skip.")
    return False, ""

def getCharName(charID):
    #print ()
    char_name = http.get(CHAR_ID_LOOKUP %(str(int(charID))))
    #print(char_name.json())
    return char_name.json()["name"]

def getFinalBlowChar(attackers):
    for attacker in attackers:
        if attacker["final_blow"]:
            if "character_id" in attacker:
                return getCharName(attacker["character_id"])
            elif "ship_type_id" in attacker:
                return getShipName(attacker["ship_type_id"])
    return ""

def getCorpNameIfNotAllianceNameFromCorpID(corpID):
    corp_lookup = http.get(CORP_ID_LOOKUP %(str(int(corpID))))
    if "alliance_id" in corp_lookup.json():
        all_id = corp_lookup.json()["alliance_id"]
        alliance_lookup = http.get(ALLIANCE_ID_LOOKUP %(str(int(all_id))))
        return alliance_lookup.json()["ticker"]
    else:
        return corp_lookup.json()["ticker"]

def getLocationName(locationID):
    system_lookup = http.get(SYSTEM_LOOKUP %(str(int(locationID))))
    return system_lookup.json()["name"]

def getSystemSecurityColor(locationID):
    system_lookup = http.get(SYSTEM_LOOKUP %(str(int(locationID))))
    sec = system_lookup.json()["security_status"]
    sec *= 10
    sec = int(sec)
    if sec >= 10: return "#2FEFEF"
    elif sec >= 9: return "#48F0C0"
    elif sec >= 8: return "#00EF47"
    elif sec >= 7: return "#00F000"
    elif sec >= 6: return "#8FEF2F"
    elif sec >= 5: return "#EFEF00"
    elif sec >= 4: return "#fdb745"
    elif sec >= 3: return "#e9943d"
    elif sec >= 2: return "#d36f37"
    elif sec >= 1: return "#bf4b30"
    return "#ff0000"

def getCorpName(corpID):
    corp_name = http.get(CORP_ID_LOOKUP %(str(int(corpID))))
    return corp_name.json()["name"]

def getShipName(shipID):
    shipID = "[\n" + str(int(shipID)) + "\n]"
    ship_name = http.post(NAME_LOOKUP,body=shipID)
    #print (ship_name)
    if "name" in ship_name.json()[0]:
        return ship_name.json()[0]["name"]
    else:
        return "NO SHIP NAME"

def getAllNames(charID,corpID,shipID):
    query = "[\n" + str(int(charID)) + ",\n" + str(int(corpID)) + ",\n" + str(int(shipID)) + "\n]"
    results = http.post(NAME_LOOKUP,body=query)
    #print(results.json()[0])
    #print(query)
    return results.json()[0]["name"],results.json()[1]["name"],results.json()[2]["name"]

def createDummyKillmail():
    finalBlowChar = getCharName(2112487672)
    rep_char = 2113672544
    rep_ship = 49713
    rep_corp = 98477920
    location = getLocationName(30003330)
    color = "#ff0000"
    finalBlowColor = "#fff"

    if rep_char > 0:
        char = getCharName(rep_char)
    else:  
        char = "NO CHAR FOUND"
    corp = "[" + getCorpNameIfNotAllianceNameFromCorpID(rep_corp) + "]"
    ship = getShipName(rep_ship)

    iconstring = ICON_LOOKUP %(str(int(rep_ship)))

    nameWidget = render.Marquee(width=58,child=render.Text(content=char,font="CG-pixel-3x5-mono",color="#ff0000"))
    nameWidget = render.Padding(child=nameWidget,pad=(1,1,1,1))
    firstRowList = [nameWidget]

    icon = render.Image(src= http.get(iconstring).body(), width=18, height=18)
    icon = render.Padding(child=icon,pad=(1,0,1,0))

    corpWidget = render.Marquee(width=42,child=render.Text(content=corp,font="CG-pixel-3x5-mono"))
    corpWidget = render.Padding(child=corpWidget,pad=(0,0,0,1))

    shipWidget = render.Marquee(width=42,child=render.Text(content=ship,font="CG-pixel-3x5-mono"))
    shipWidget = render.Padding(child=shipWidget,pad=(0,0,0,1))

    systemWidget = render.Marquee(width=42,child=render.Text(content=location,font="CG-pixel-3x5-mono",color=color))
    systemWidget = render.Padding(child=systemWidget,pad=(0,0,0,1))

    fBOffset = len(str(4))*4

    finalBlowWidget = render.Marquee(width=55-fBOffset,child=render.Text(content=finalBlowChar,font="CG-pixel-3x5-mono",color=finalBlowColor))
    finalBlowWidget = render.Padding(child=finalBlowWidget,pad=(1,1,1,0))

    totalAttackersWidget = render.Text(content="("+str(4)+")",font="CG-pixel-3x5-mono")
    totalAttackersWidget = render.Padding(child=totalAttackersWidget,pad=(0,1,1,1))

    frame = render.Box(color="#000",
        child=render.Column(
            children=[
                render.Row(children=firstRowList),
                render.Row(children=[
                    icon,
                    render.Column(children=[
                        corpWidget,
                        shipWidget,
                        systemWidget])
                ]),
                render.Row(children=[finalBlowWidget, totalAttackersWidget])
            ]))

    return frame

def createKillmail(rep,repCount):
    rep_corp = rep.json()["package"]["killmail"]["victim"]["corporation_id"]
    if "character_id" in rep.json()["package"]["killmail"]["victim"]:
        rep_char = rep.json()["package"]["killmail"]["victim"]["character_id"]
    else:
        rep_char = -1
    rep_ship = rep.json()["package"]["killmail"]["victim"]["ship_type_id"]
    rep_attackers = rep.json()["package"]["killmail"]["attackers"]
    finalBlowChar = getFinalBlowChar(rep_attackers)
    location = getLocationName(rep.json()["package"]["killmail"]["solar_system_id"])
    color = getSystemSecurityColor(rep.json()["package"]["killmail"]["solar_system_id"])
    finalBlowColor = "#fff"
    if isNPCKill(rep_attackers):
        finalBlowColor = "#aaa"
    #print(rep_corp, rep_char, rep_ship)

    #char, corp, ship = getAllNames(rep_char,rep_corp,rep_ship)
    if rep_char > 0:
        char = getCharName(rep_char)
    else:  
        char = "NO CHAR FOUND"
    corp = "[" + getCorpNameIfNotAllianceNameFromCorpID(rep_corp) + "]"
    ship = getShipName(rep_ship)

    iconstring = ICON_LOOKUP %(str(int(rep_ship)))

    nameWidget = render.Marquee(width=58,child=render.Text(content=char,font="CG-pixel-3x5-mono",color="#ff0000"))
    nameWidget = render.Padding(child=nameWidget,pad=(1,1,1,1))
    firstRowList = [nameWidget]

    icon = render.Image(src= http.get(iconstring).body(), width=18, height=18)
    icon = render.Padding(child=icon,pad=(1,0,1,0))

    corpWidget = render.Marquee(width=42,child=render.Text(content=corp,font="CG-pixel-3x5-mono"))
    corpWidget = render.Padding(child=corpWidget,pad=(0,0,0,1))

    shipWidget = render.Marquee(width=42,child=render.Text(content=ship,font="CG-pixel-3x5-mono"))
    shipWidget = render.Padding(child=shipWidget,pad=(0,0,0,1))

    systemWidget = render.Marquee(width=42,child=render.Text(content=location,font="CG-pixel-3x5-mono",color=color))
    systemWidget = render.Padding(child=systemWidget,pad=(0,0,0,1))

    fBOffset = len(str(len(rep_attackers)))*4

    finalBlowWidget = render.Marquee(width=55-fBOffset,child=render.Text(content=finalBlowChar,font="CG-pixel-3x5-mono",color=finalBlowColor))
    finalBlowWidget = render.Padding(child=finalBlowWidget,pad=(1,1,1,0))

    if DEBUG_MODE:
        frameCountWidget = render.Text(content=str(repCount+1),font="CG-pixel-3x5-mono")
        frameCountWidget = render.Padding(child=frameCountWidget,pad=(0,1,1,1))
        firstRowList.append (frameCountWidget)

    totalAttackersWidget = render.Text(content="("+str(len(rep_attackers))+")",font="CG-pixel-3x5-mono")
    totalAttackersWidget = render.Padding(child=totalAttackersWidget,pad=(0,1,1,1))

    frame = render.Box(color="#000",
        child=render.Column(
            children=[
                render.Row(children=firstRowList),
                render.Row(children=[
                    icon,
                    render.Column(children=[
                        corpWidget,
                        shipWidget,
                        systemWidget])
                ]),
                render.Row(children=[finalBlowWidget, totalAttackersWidget])
            ]))

    #frame = render.Stack(children=[render.Box(color="#000"),frame])

    return frame

def wrapKillmailsInAnimation (killmails,reasons):
    animKillmails = []
    for x in range(len(killmails)):
        layer1 = animation.Transformation(
            child=killmails[x-1],
            duration=max(FRAMES_PER_SECOND*MAX_SECONDS_PER_SLIDE,math.floor(TIME_TOTAL/len(killmails))),
            delay=0,
            keyframes=[
                animation.Keyframe(percentage=0.0,curve = "ease_out",transforms=[animation.Translate(64,0)]),
                animation.Keyframe(percentage=0.1,curve = "ease_in",transforms=[animation.Translate(0,0)]),
                animation.Keyframe(percentage=0.9,curve = "ease_in",transforms=[animation.Translate(0,0)]),
                animation.Keyframe(percentage=1.0,curve = "ease_out",transforms=[animation.Translate(-100,0)])
                ],
            wait_for_child=False
        )
        layer2comp = render.Box(child=render.Text(content=reasons[x],font="CG-pixel-3x5-mono",color="#fff"),width=64,height=7,color="#0e4296")
        layer2 = animation.Transformation(
            child=layer2comp,
            duration = math.floor(FRAMES_PER_SECOND*1.5),
            keyframes=[
                animation.Keyframe(percentage=0.0,curve="ease_in",transforms=[animation.Translate(0,12),animation.Scale(1,0)]),
                animation.Keyframe(percentage=0.05,curve="linear",transforms=[animation.Translate(0,12),animation.Scale(1,1)]),
                animation.Keyframe(percentage=0.95,curve="linear",transforms=[animation.Translate(0,12),animation.Scale(1,1)]),
                animation.Keyframe(percentage=1.0,curve="ease_out",transforms=[animation.Translate(0,12),animation.Scale(1,0)])
            ]
        )
        composite = render.Stack(children=[layer1,layer2])
        animKillmails.append(composite)
    return animKillmails

def errorMessage(string):
    return render.Root(
        child = render.Row(
            children=[
                render.WrappedText(content=string,width=32),
                render.Image(
                    src=ELMO)],
            main_align="center",expanded=True))

def main():

    killmails = []
    reasons = []

    STORED_CORPS = getCorpsForAlliance(ALLIANCE_ID)
    #print(STORED_CORPS)

    found = False
    for x in range (100):
        if ANIMTEST_MODE == False:
            rep = http.get(ZKILL_URL)
            if rep.url == "https://redisq.zkillboard.com/banned.html":
                return errorMessage("THANKS SQUIZZ")
            if rep.status_code == 429:
                return errorMessage("429")
            if rep.json()["package"] == None:
                print("No package. Stopping.")
                break
            else:
                result = filter(rep,STORED_CORPS)
                if result[0]:
                    found = True
                    killmails.append(createKillmail(rep,len(killmails)))
                    reasons.append(result[1])
        else:
            found = True
            killmails.append(createDummyKillmail())
            reasons.append("DEBUG MODE!")
        if (len(killmails) >= MAX_KILLMAILS):
            break
    
    if not found:
        print("Did not return any good results. Returning nothing.")
        return []


    print(len(killmails))

    killmails = wrapKillmailsInAnimation(killmails,reasons)
    return render.Root(
        child = render.Sequence(children = killmails),
        delay = math.floor(1000/FRAMES_PER_SECOND)
    )
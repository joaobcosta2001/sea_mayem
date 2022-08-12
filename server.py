from multiprocessing import connection
from multiprocessing.dummy import current_process
import socket
from threading import Thread
from queue import Queue
import sys
from random import random
from random import randint
from turtle import position
from matplotlib.pyplot import prism
from perlin_noise import PerlinNoise

mapSize = 2 #map size in km
minPlayerNumber = 6
teamBalancing = True
HOST = "127.0.0.1"
PORT = 4500
currentStage = "lobby"
team1 = []
team2 = []
playerList = []
connectionList = []
broadcastQueue = Queue()
map = []

class Player:
    def __init__(self,con,addr,p):
        self.name = ""
        self.ready = False
        self.address = addr
        self.port = p
        self.boat = Boat()
        self.bot = False
        self.connection = con
        playerList.append(self)
        if len(team1) > len(team2):
            team2.append(self)
            self.team = 2
        else:
            team1.append(self)
            self.team = 1

MAX_NORMAL_POINTS = 55
MAX_SPECIAL_POINTS = 30
MAX_ATTACK_POINTS = 45
MAX_DEFENSE_POINTS = 30
MAX_NAVIGATION_POINTS = 15
MAX_ENGINE_POINTS = 15

def getTurretPointCost(p):
    if p == -1:
        return 0
    if p == 0:
        return 5
    if p == 1:
        return 10
    if p == 2:
        return 15
    print("ERROR finding point cost of turret of type " + str(p))

def getAntiTurretPointCost(p):
    if p == -1:
        return 0
    if p == 0:
        return 5
    if p == 1:
        return 10
    if p == 2:
        return 15
    print("ERROR finding point cost of anti turret of type "+ str(p))

def getNavigationPointCost(p):
    if p == -1:
        return 0
    if p == 0:
        return 5
    if p == 1:
        return 10
    if p == 2:
        return 15
    print("ERROR finding point cost of anti turret of type "+ str(p))

def getEnginePointCost(p):
    if p == -1:
        return 0
    if p == 0:
        return 5
    if p == 1:
        return 10
    if p == 2:
        return 15
    print("ERROR finding point cost of anti turret of type "+ str(p))

def nerfBoat(b):
    while True:
        t = randint(0,6)
        if t == 0:
            if getTurretPointCost(b.turrets.ft) > 5 and b.turrets.ft > 0:
                b.turrets.ft-=1
                break
            else:
                continue
        elif t == 1:
            if getTurretPointCost(b.turrets.mt) > 5 and b.turrets.mt > 0:
                b.turrets.mt-=1
                break
            else:
                continue
        elif t == 2:
            if getTurretPointCost(b.turrets.bt) > 5 and b.turrets.bt > 0:
                b.turrets.bt-=1
                break
            else:
                continue
        elif t == 3:
            if getAntiTurretPointCost(b.turrets.bat) > 5 and b.turrets.bat > 0:
                b.turrets.bat-=1
                break
            else:
                continue
        elif t == 4:
            if getAntiTurretPointCost(b.turrets.fat) > 5 and b.turrets.fat > 0:
                b.turrets.fat-=1
                break
            else:
                continue
        elif t == 5:
            if getNavigationPointCost(b.turrets.nav) > 5 and b.turrets.nav > 0:
                b.turrets.nav-=1
                break
            else:
                continue
        elif t == 6:
            if getEnginePointCost(b.turrets.eng) > 5 and b.turrets.eng > 0:
                b.turrets.eng-=1
                break
            else:
                continue

def enhanceBoat(b):
    while True:
        t = randint(0,6)
        if t == 0:
            if getTurretPointCost(b.turrets.ft) < 15 and b.turrets.ft < 2:
                b.turrets.ft+=1
                break
            else:
                continue
        elif t == 1:
            if getTurretPointCost(b.turrets.mt) < 15 and b.turrets.mt < 2:
                b.turrets.mt+=1
                break
            else:
                continue
        elif t == 2:
            if getTurretPointCost(b.turrets.bt) < 15 and b.turrets.bt < 2:
                b.turrets.bt+=1
                break
            else:
                continue
        elif t == 3:
            if getAntiTurretPointCost(b.turrets.bat) < 15 and b.turrets.bat < 2:
                b.turrets.bat+=1
                break
            else:
                continue
        elif t == 4:
            if getAntiTurretPointCost(b.turrets.fat) < 15 and b.turrets.fat < 2:
                b.turrets.fat+=1
                break
            else:
                continue
        elif t == 5:
            if getNavigationPointCost(b.turrets.nav) < 15 and b.turrets.nav < 2:
                b.turrets.nav+=1
                break
            else:
                continue
        elif t == 6:
            if getEnginePointCost(b.turrets.eng) < 15 and b.turrets.eng < 2:
                b.turrets.eng+=1
                break
            else:
                continue

class Boat:
    def __init__(self):
        self.wastedPoints = 0
        self.turrets = Turrets()
        self.position = (0,0)
        self.rotation = 0
    def getRemainingPoints(self):
        return MAX_NORMAL_POINTS + MAX_SPECIAL_POINTS - self.wastedPoints - getTurretPointCost(self.turrets.ft) - getTurretPointCost(self.turrets.mt) - getTurretPointCost(self.turrets.bt) - getAntiTurretPointCost(self.turrets.fat) - getAntiTurretPointCost(self.turrets.bat) - getNavigationPointCost(self.turrets.nav) - getEnginePointCost(self.turrets.eng)
        


class Turrets:
    def __init__(self):
        self.fat = -1
        self.bat = -1
        self.ft = -1
        self.bt = -1
        self.mt = -1
        self.nav = -1
        self.eng = -1


for i in range(1):
    p = Player(None,"127.0.0.1",6400+i)
    p.name = "Bot_" + str(p.port)
    p.ready = True
    p.bot = True



def getPlayerByName(t):
    #Returns player with name t
    for player in playerList:
        if player.name == t:
            return player
    return None

def getPlayerByAddress(t):
    #Rreturns first player with ip t
    for player in playerList:
        if player.addr == t:
            return player
    return None
    
def formatTeamInfo():
    print("Sending team info")
    messageToSend = "teams_info:"
    for player in team1:
        messageToSend = messageToSend + player.name
        if(player.ready):
            messageToSend = messageToSend + "V1"
        else:
            messageToSend = messageToSend + "X1"
        messageToSend = messageToSend + ","
    for player in team2:
        messageToSend = messageToSend + player.name
        if(player.ready):
            messageToSend = messageToSend + "V2"
        else:
            messageToSend = messageToSend + "X2"
        messageToSend = messageToSend + ","
    messageToSend = messageToSend[0:-1]
    return messageToSend

#Returns a string with the turret displays of all boats with syntax:
#   Bob:1,3,-1,3,4;Jack:2,2,2,2,3;
def formatBoatsInfo():
    print("Sending boats info")
    m = "boats_info:"
    for player in playerList:
        m = m + player.name + ":" + str(player.boat.turrets.ft) + "," + str(player.boat.turrets.mt) + "," + str(player.boat.turrets.bt) + "," + str(player.boat.turrets.fat) + "," + str(player.boat.turrets.bat) + "," + str(player.boat.turrets.nav) + "," + str(player.boat.turrets.eng)+ ";"
    return m


def saveMap(location,m):
    print("Saving map to " + location)
    f = open(location + "map_" + str(len(m)) + "x" + str(len(m[0])) + ".txt","w")
    for i in range(len(m)):
        for j in range(len(m[0])):
            if m[i][j] < 10 and m[i][j]>=0:
                f.write("0"+ str(m[i][j]))
            else:
                f.write(str(m[i][j]))
    f.close()
    print("Map saved successfully")

def loadMap(filename,mapSize):
    map = []
    print("Loading map from: " + filename)
    f = open(filename, "r")
    for i in range(mapSize):
        row = []
        for j in range(mapSize):
            try:
                n = int(f.read(2))
                row.append(n)
            except:
                print("Value error!!!")
        map.append(row)
    print("Map loaded successfully")
    return map
            
def main():
    global map
    try:
        Thread(target=consoleThread).start()
    except:
        print("Failed to start console thread")
    #map = loadMap("map_1000x1000.txt",1000)
    map = generateMap()
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    print("Server socket created")
    try:
        s.bind((HOST,PORT))
    except:
        print("Socket binding failed (Error: " + str(sys.exc_info()) + ")")
        sys.exit()
    s.listen(64)
    try:
        Thread(target = broadcastThread).start()
    except:
        print("Failed to start broadcast thread")
    print("Socket now listening")
    while True:
        connection,address = s.accept()
        connectionList.append(connection)
        print("Established connection with " + str(address[0]) + ":" + str(address[1]))
        try:
            Thread(target = clientThread, args = (connection,address[0],address[1])).start()
        except:
            print("Failed to start thread")
    s.close()

def clientThread(connection, ip, port):
    global currentStage
    player = Player(connection,ip,port)

    while True:
        try:
            data = connection.recv(1024)
        except ConnectionResetError:
            break
        print("Received data: |" +  str(data) + "|")
        receivedPacket = str(data,"UTF-8")
        separator = receivedPacket.find(")",1, len(receivedPacket))
        user = receivedPacket[1:separator]
        message = receivedPacket[separator+1:]


        #Handle messages

        if player.name == "":
            player.name = user

        if (message == "request_teams"):
            broadcast(formatTeamInfo())
        
        if (message == "swap_teams"):
            print("Swapping user " + user + " to team 1")
            p = getPlayerByName(user)
            try:
                team1.remove(p)
                team2.append(p)
            except:
                team2.remove(p)
                team1.append(p)
            broadcast(formatTeamInfo())
            

        if (message == "ready"):
            getPlayerByName(user).ready = True
            if checkAllPlayersReady():
                if currentStage == "lobby":
                    print("All players are ready, going to building screen")
                    broadcast("points_info:" + str(MAX_NORMAL_POINTS) + ":" + str(MAX_SPECIAL_POINTS))
                    for player in playerList:
                        if player.bot:
                            player.boat.turrets.ft  = randint(0,2)
                            player.boat.turrets.mt  = randint(0,2)
                            player.boat.turrets.bt  = randint(0,2)
                            player.boat.turrets.fat = randint(0,2)
                            player.boat.turrets.bat = randint(0,2)
                            player.boat.turrets.nav = randint(0,2)
                            player.boat.turrets.eng = randint(0,2)
                            while player.boat.getRemainingPoints() < 0:
                                nerfBoat(player.boat)
                            while player.boat.getRemainingPoints() > 0:
                                enhanceBoat(player.boat)
                        player.ready = player.bot
                    broadcast(formatBoatsInfo())
                    broadcast("building_screen")
                    currentStage = "building"
                elif currentStage == "building":
                    print("All player are ready, starting game")
                    broadcast("game_loading_screen")
                    currentStage ="loading"
                    generateGame()
            else:
                broadcast(formatTeamInfo())

        if(message == "unready"):
            getPlayerByName(user).ready = False
            broadcast(formatTeamInfo())

        if message[:11] == "change_part":
            p = getPlayerByName(user)
            if message[12:14] == "ft":
                newTurretValue = int(message[15:])
                if getTurretPointCost(newTurretValue) <= p.boat.getRemainingPoints() + getTurretPointCost(player.boat.turrets.ft):
                    p.boat.turrets.ft = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:14] == "mt":
                newTurretValue = int(message[15:])
                if getTurretPointCost(newTurretValue) <= p.boat.getRemainingPoints() + getTurretPointCost(player.boat.turrets.mt):
                    p.boat.turrets.mt = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:14] == "bt":
                newTurretValue = int(message[15:])
                if getTurretPointCost(newTurretValue) <= p.boat.getRemainingPoints() + getTurretPointCost(player.boat.turrets.bt):
                    p.boat.turrets.bt = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:15] == "fat":
                newTurretValue = int(message[16:])
                if getAntiTurretPointCost(newTurretValue) <= p.boat.getRemainingPoints() + getAntiTurretPointCost(player.boat.turrets.fat):
                    p.boat.turrets.fat = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:15] == "bat":
                newTurretValue = int(message[16:])
                if getAntiTurretPointCost(newTurretValue) <= p.boat.getRemainingPoints() + getAntiTurretPointCost(player.boat.turrets.bat):
                    p.boat.turrets.bat = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:15] == "nav":
                newNavValue = int(message[16:])
                if getNavigationPointCost(newNavValue) <= p.boat.getRemainingPoints() + getNavigationPointCost(player.boat.turrets.nav):
                    p.boat.turrets.nav = newNavValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:15] == "eng":
                newEngineValue = int(message[16:])
                if getEnginePointCost(newEngineValue) <= p.boat.getRemainingPoints() + getEnginePointCost(player.boat.turrets.eng):
                    p.boat.turrets.eng = newEngineValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            rm = player.boat.getRemainingPoints()
            availableNormalPoints = 0
            availableSpecialPoints = 0
            if rm < MAX_SPECIAL_POINTS - player.boat.wastedPoints:
                availableSpecialPoints = rm
                availableNormalPoints = 0
            else:
                availableSpecialPoints = MAX_SPECIAL_POINTS - player.boat.wastedPoints
                availableNormalPoints = rm - availableSpecialPoints
            print("Sending points info to " + player.name + ": np=" + str(availableNormalPoints) + "  sp=" + str(availableSpecialPoints) + "  rm=" + str(player.boat.getRemainingPoints()) + "  wp=" + str(player.boat.wastedPoints))
            sendMessage(connection,"points_info:" + str(availableNormalPoints) + ":" + str(availableSpecialPoints))
        if message == "steal_intel":
            if player.boat.wastedPoints < MAX_SPECIAL_POINTS and p.boat.getRemainingPoints() >= 5:
                player.boat.wastedPoints += 5
                if player.team == 1:
                    sendMessage(connection,"stolen_intel:" + getTeamSecretInfo(2))
                elif player.team == 2:
                    sendMessage(connection,"stolen_intel:" + getTeamSecretInfo(1))
                rm = player.boat.getRemainingPoints()
                availableNormalPoints = 0
                availableSpecialPoints = 0
                if rm < MAX_SPECIAL_POINTS - player.boat.wastedPoints:
                    availableSpecialPoints = rm
                    availableNormalPoints = 0
                else:
                    availableSpecialPoints = MAX_SPECIAL_POINTS - player.boat.wastedPoints
                    availableNormalPoints = rm - availableSpecialPoints
                print("Sending points info to " + player.name + ": np=" + str(availableNormalPoints) + "  sp=" + str(availableSpecialPoints) + "  rm=" + str(player.boat.getRemainingPoints()) + "  wp=" + str(player.boat.wastedPoints))
                sendMessage(connection,"points_info:" + str(availableNormalPoints) + ":" + str(availableSpecialPoints))

    connectionList.remove(connection)
    playerList.remove(player)
    if player.team == 1:
        team1.remove(player)
    else:
        team2.remove(player)
    print("Terminanting thread of client " + player.name + " (" + ip + ":" + str(port) + ")")

def sendMessage(connection,message):
    connection.sendall(bytes(message + "|",'utf-8'))

def broadcast(t):
    broadcastQueue.put(t+"|")

def broadcastThread():
    print("Started broadcast thread")
    while True:
        if not broadcastQueue.empty():
            message = broadcastQueue.get()
            for c in connectionList:
                if message[0:4] == "map:":
                    print("Sending map to connection")
                c.sendall(bytes(message,'utf-8'))
                if message[0:4] == "map:":
                    print("Sent map data successfully")

def consoleThread():
    while True:
        command = input()
        if command[:7] == "add bot":
            if currentStage != "lobby":
                print("ERROR Cannot add bots if not in lobby!")
                continue
            n = 1
            if len(command) > 8:
                try:
                    n = int(command[8:])
                except:
                    print("Invalid number of bots to be added!")
            for i in range(n):
                p = Player(None,"127.0.0.1",6400)
                c = 1
                name = "Bot_" + str(c)
                match = False
                for p in playerList:
                    if name == p.name:
                        match = True
                        break
                while match:
                    c += 1
                    name = "Bot_" + str(c)
                    match = False
                    for p in playerList:
                        if name == p.name:
                            match = True
                            break
                p.name = name
                p.ready = True
                p.bot = True
            print("Successfully added " + str(n) + " bots")
            broadcast(formatTeamInfo())
        #MISSING remove player still doesnt disconnect
        elif command[:14] == "player remove ":
            removed = False
            for p in playerList:
                if p.name == command[14:]:
                    playerList.remove(p)
                    try:
                        team1.remove(p)
                    except:
                        team2.remove(p)
                    removed = True
                    print("SUCCESS removed player " + command[14:])
                    break
            if removed:
                broadcast("remove_player:" + command[14:])
            else:
                print("ERROR player " + command[14:] + " not found")
        elif command == "player list":
            print("-----Player List-----")
            for p in playerList:
                print(p.name + " (team " + str(p.team) + ")")
            print("---------------------")
        elif command[:9] == "get boat ":
            found = False
            for p in playerList:
                if p.name == command[9:]:
                    print("Boat configuration of player " + command[9:] + ":")
                    print("  ft:  " + str(p.boat.turrets.ft))
                    print("  bt:  " + str(p.boat.turrets.bt))
                    print("  mt:  " + str(p.boat.turrets.mt))
                    print("  fat: " + str(p.boat.turrets.fat))
                    print("  bat: " + str(p.boat.turrets.bat))
                    print("  nav: " + str(p.boat.turrets.nav))
                    print("  eng: " + str(p.boat.turrets.eng))
                    found = True
            if not found:
                print("ERROR Player not found")
        else:
            print("ERROR Command unknow!")

def checkAllPlayersReady():
    readyPlayerCount = 0
    botCount = 0
    if len(playerList) < minPlayerNumber:
        return False
    for p in playerList:
        if p.ready:
            readyPlayerCount+=1
        if p.bot:
            botCount+=1
    if readyPlayerCount == len(playerList):
        if readyPlayerCount == botCount:
            return False
        if teamBalancing and (len(team1) > len(team2) + 1 or len(team2) > len(team1) +1):
            for p in playerList:
                p.ready = False
            broadcast(formatTeamInfo())
            broadcast("teams_unbalanced")
            return False
        return True

def getTeamSecretInfo(team):
    attackPoints = 0
    defensePoints = 0
    navigationPoints = 0
    enginePoints = 0
    r = random()
    if r > 0.8:
        return "no_intel"
    elif r > 0.7:
        r = random()
        if r<0.25:
            return "strong_attack"
        elif r<0.5:
            return "strong_defense"
        elif r<0.75:
            return "strong_navigation"
        else:
            return "strong_engine"
    elif team == 1:
        for player in team1:
            attackPoints += getTurretPointCost(player.boat.turrets.ft) + getTurretPointCost(player.boat.turrets.mt) + getTurretPointCost(player.boat.turrets.bt)
            defensePoints += getAntiTurretPointCost(player.boat.turret.fat) + getAntiTurretPointCost(player.boat.turret.bat)
        p = [attackPoints/(len(team1)*MAX_ATTACK_POINTS),defensePoints/(len(team1)*MAX_DEFENSE_POINTS),navigationPoints/(len(team1)*MAX_NAVIGATION_POINTS),enginePoints/(len(team1)*MAX_ENGINE_POINTS)]
        if p[0] == p[1] and p[1] == p[2] and p[2] == p[3]:
            r = random()
            if r<0.25:
                return "strong_attack"
            elif r<0.5:
                return "strong_defense"
            elif r<0.75:
                return "strong_navigation"
            else:
                return "strong_engine"
        m = max(p)
        if p.index(m) == 0:
            return "strong_attack"
        elif p.index(m) == 1:
            return "strong_defense"
        elif p.index(m) == 2:
            return "strong_navigation"
        elif p.index(m) == 3:
            return "strong_engine"
    elif team == 2:
        for player in team2:
            attackPoints += getTurretPointCost(player.boat.turrets.ft) + getTurretPointCost(player.boat.turrets.mt) + getTurretPointCost(player.boat.turrets.bt)
            defensePoints += getAntiTurretPointCost(player.boat.turrets.fat) + getAntiTurretPointCost(player.boat.turrets.bat)
        p = [attackPoints/(len(team2)*MAX_ATTACK_POINTS),defensePoints/(len(team2)*MAX_DEFENSE_POINTS),navigationPoints/(len(team2)*MAX_NAVIGATION_POINTS),enginePoints/(len(team2)*MAX_ENGINE_POINTS)]
        if p[0] == p[1] and p[1] == p[2] and p[2] == p[3]:
            r = random()
            if r<0.25:
                return "strong_attack"
            elif r<0.5:
                return "strong_defense"
            elif r<0.75:
                return "strong_navigation"
            else:
                return "strong_engine"
        m = max(p)
        if p.index(m) == 0:
            return "strong_attack"
        elif p.index(m) == 1:
            return "strong_defense"
        elif p.index(m) == 2:
            return "strong_navigation"
        elif p.index(m) == 3:
            return "strong_engine"
    else:
        print("ERROR invalid team given to getTeamSecretInfo()")

def generateGame():
    print("Generating game")
    global map
    #send map to players
    print("Preparing map information message")
    m = "map:"
    for i in range(len(map)):
        for j in range(len(map[0])):
            if map[j][i] >= 0 and map[j][i] <= 9:
                m = m + "0" + str(map[j][i])
            else:
                m = m + str(map[j][i])
    broadcast(m)
    #colocar navios em lados distintos do mapa
    for player in team1:
        player.boat.position = (50+100*random(),450+100*random())
        positionOK = False
        while not positionOK:
            aux = False
            for player2 in playerList:
                if abs(player.boat.position[0] - player2.boat.position[0]) < 20 and abs(player.boat.position[1] - player2.boat.position[1]) < 20:
                    player.boat.position = (50+100*random(),450+100*random())
                    aux = True
                    break
            if aux == False:
                positionOK = True
        player.boat.rotation = 0
    for player in team2:
        player.boat.position = (850+100*random(),450+100*random())
        positionOK = False
        while not positionOK:
            aux = False
            for player2 in playerList:
                if abs(player.boat.position[0] - player2.boat.position[0]) < 20 and abs(player.boat.position[1] - player2.boat.position[1]) < 20:
                    player.boat.position = (850+100*random(),450+100*random())
                    aux = True
                    break
            if aux == False:
                positionOK = True
        player.boat.rotation = 180
    #garantir que navios nao estao demasiado perto da costa
    #esperar pela confirmacao de mapa criado
    #dizer a todos para comecar

#def checkForMapGenerationConfirmations():

def generateMap():
    noise1 = PerlinNoise(octaves=3)
    noise2 = PerlinNoise(octaves=6)
    noise3 = PerlinNoise(octaves=12)
    noise4 = PerlinNoise(octaves=24)
    xpix, ypix = int(mapSize*100), int(mapSize*100)
    pic = []
    threshold = 0.3
    print("Generating map")
    maxValue = 0
    for i in range(xpix):
        row = []
        for j in range(ypix):
            noise_val = noise1([i/xpix*1.2, j/ypix*1.2])
            noise_val += 0.5 * noise2([i/xpix, j/ypix])
            noise_val += 0.25 * noise3([i/xpix, j/ypix])
            noise_val += 0.125 * noise4([i/xpix, j/ypix])
            if noise_val < threshold:
                noise_val = int(-1)
            else:
                noise_val = int((noise_val-threshold)/(1-threshold)*100)
            if noise_val> maxValue:
                maxValue = noise_val
            row.append(noise_val)
        pic.append(row)
        if i%(mapSize*10)==0:
            print(str(i/xpix*100) + "%",end="\r")
    for i in range(xpix):
        for j in range(ypix):
            if pic[i][j] > 0:
                pic[i][j] = int((pic[i][j]/maxValue)*99)
    print("Map Generated")
    return pic

if __name__ == '__main__':
    main()



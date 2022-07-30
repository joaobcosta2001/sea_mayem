from multiprocessing import connection
import socket
from threading import Thread
from queue import Queue
import sys

minPlayerNumber = 6
teamBalancing = True
HOST = "127.0.0.1"
PORT = 4500

team1 = []
team2 = []
playerList = []
connectionList = []
broadcastQueue = Queue()

class Player:
    def __init__(self,addr,p):
        self.name = ""
        self.ready = False
        self.address = addr
        self.port = p
        self.boat = Boat()
        playerList.append(self)
        if len(team1) > len(team2):
            team2.append(self)
            self.team = 2
        else:
            team1.append(self)
            self.team = 1

MAX_NORMAL_POINTS = 55
MAX_SPECIAL_POINTS = 30

def getTurretPointCost(p):
    if p == -1:
        return 0
    if p == 0:
        return 10
    if p == 1:
        return 15
    if p == 2:
        return 5
    print("ERROR finding point cost of turret of type " + str(p))

def getAntiTurretPointCost(p):
    if p == -1:
        return 0
    if p == 0:
        return 10
    if p == 1:
        return 15
    if p == 2:
        return 5
    print("ERROR finding point cost of anti turret of type "+ str(p))

class Boat:
    def __init__(self):
        self.wastedPoints = 0
        self.turrets = Turrets()
    def getRemainingPoints(self):
        return MAX_NORMAL_POINTS + MAX_SPECIAL_POINTS - self.wastedPoints - getTurretPointCost(self.turrets.ft) - getTurretPointCost(self.turrets.mt) - getTurretPointCost(self.turrets.bt) - getAntiTurretPointCost(self.turrets.fat) - getAntiTurretPointCost(self.turrets.bat)
        


class Turrets:
    def __init__(self):
        self.fat = -1
        self.bat = -1
        self.ft = -1
        self.bt = -1
        self.mt = -1


for i in range(26):
    p = Player("127.0.0.1",6400+i)
    p.name = "Bot_" + str(p.port)
    p.ready = True


for i in range(5):
    playerList[i].ready = True



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
        m = m + player.name + ":" + str(player.boat.turrets.ft) + "," + str(player.boat.turrets.mt) + "," + str(player.boat.turrets.bt) + "," + str(player.boat.turrets.fat) + "," + str(player.boat.turrets.bat) + ";"
    return m

def main():
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
    player = Player(ip,port)

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
                print("All players are ready, going to building screen")
                broadcast("points_info:" + str(MAX_NORMAL_POINTS) + ":" + str(MAX_SPECIAL_POINTS))
                broadcast("building_screen")
                broadcast(formatBoatsInfo())
                #for player in playerList:
                #    player.ready = False
            else:
                broadcast(formatTeamInfo())

        if(message == "unready"):
            getPlayerByName(user).ready = False
            broadcast(formatTeamInfo())

        if message[:11] == "change_part":
            p = getPlayerByName(user)
            if message[12:14] == "ft":
                newTurretValue = int(message[15:])
                if getTurretPointCost(newTurretValue) < p.boat.getRemainingPoints() + getTurretPointCost(player.boat.turrets.ft):
                    p.boat.turrets.ft = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:14] == "mt":
                newTurretValue = int(message[15:])
                if getTurretPointCost(newTurretValue) < p.boat.getRemainingPoints() + getTurretPointCost(player.boat.turrets.mt):
                    p.boat.turrets.mt = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:14] == "bt":
                newTurretValue = int(message[15:])
                if getTurretPointCost(newTurretValue) < p.boat.getRemainingPoints() + getTurretPointCost(player.boat.turrets.bt):
                    p.boat.turrets.bt = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:15] == "fat":
                newTurretValue = int(message[16:])
                if getAntiTurretPointCost(newTurretValue) < p.boat.getRemainingPoints() + getAntiTurretPointCost(player.boat.turrets.fat):
                    p.boat.turrets.fat = newTurretValue
                    broadcast(formatBoatsInfo())
                else:
                    sendMessage(connection,"not_enough_points")
            if message[12:15] == "bat":
                newTurretValue = int(message[16:])
                if getAntiTurretPointCost(newTurretValue) < p.boat.getRemainingPoints() + getAntiTurretPointCost(player.boat.turrets.bat):
                    p.boat.turrets.bat = newTurretValue
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
                c.sendall(bytes(message,'utf-8'))


def checkAllPlayersReady():
    readyPlayerCount = 0
    if len(playerList) < minPlayerNumber:
        return False
    for p in playerList:
        if p.ready:
            readyPlayerCount+=1
    if readyPlayerCount == len(playerList):
        if teamBalancing and (len(team1) > len(team2) + 1 or len(team2) > len(team1) +1):
            for p in playerList:
                p.ready = False
            broadcast(formatTeamInfo())
            broadcast("teams_unbalanced")
            return False
        return True


if __name__ == '__main__':
    main()
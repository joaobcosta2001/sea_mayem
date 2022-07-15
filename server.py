from multiprocessing import connection
import socket
from threading import Thread
from queue import Queue
import sys

minPlayerNumber = 6
teamBalancing = True
HOST = "127.0.0.1"
PORT = 4500

#-------GAME CODE---------

team1 = []
team2 = []
playerList = []
connectionList = []
broadcastQueue = Queue()

class Player:
    def __init__(self,addr,p):
        self.name = ""
        self.teamReady = False
        self.address = addr
        self.port = p
        playerList.append(self)
        if len(team1) > len(team2):
            team2.append(self)
            self.team = 2
        else:
            team1.append(self)
            self.team = 1


p1 = Player("127.0.0.1",6400)
p1.name = "Vasco da Gama"
p2 = Player("127.0.0.1",6401)
p2.name = "Cristovao Colombo"
p3 = Player("127.0.0.1",6402)
p3.name = "Fernao Magalhaes"
p4 = Player("127.0.0.1",6403)
p4.name = "Pedro Alvares Cabral"
p5 = Player("127.0.0.1",6404)
p5.name = "Gil Eanes"

for i in range(5):
    playerList[i].teamReady = True


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
        if(player.teamReady):
            messageToSend = messageToSend + "V"
        else:
            messageToSend = messageToSend + "X"
        messageToSend = messageToSend + ","
    messageToSend = messageToSend + ","
    for player in team2:
        messageToSend = messageToSend + player.name
        if(player.teamReady):
            messageToSend = messageToSend + "V"
        else:
            messageToSend = messageToSend + "X"
        messageToSend = messageToSend + ","
    messageToSend = messageToSend[0:-1]
    return messageToSend

def main():
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    print("Server socket created")
    try:
        s.bind((HOST,PORT))
    except:
        print("Socket binding failed (Error: " + str(sys.exc_info()) + ")")
        sys.exit()
    s.listen(40)
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
            getPlayerByName(user).teamReady = True
            if checkAllPlayersReady():
                broadcast("building_screen")
            else:
                broadcast(formatTeamInfo())

        if(message == "unready"):
            getPlayerByName(user).teamReady = False
            broadcast(formatTeamInfo())
    connectionList.remove(connection)
    playerList.remove(player)
    if player.team == 1:
        team1.remove(player)
    else:
        team2.remove(player)
    print("Terminanting thread of client " + player.name + " (" + ip + ":" + str(port) + ")")

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
        if p.teamReady:
            readyPlayerCount+=1
    if readyPlayerCount == len(playerList):
        if teamBalancing and (len(team1) > len(team2) + 1 or len(team2) > len(team1) +1):
            for p in playerList:
                p.teamReady = False
            broadcast(formatTeamInfo())
            broadcast("teams_unbalanced")
            return False
        return True
            



if __name__ == '__main__':
    main()
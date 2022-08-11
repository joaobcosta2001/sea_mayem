from perlin_noise import PerlinNoise
mapSize = 1

map = []

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

def generateMap():
    noise1 = PerlinNoise(octaves=3)
    noise2 = PerlinNoise(octaves=6)
    noise3 = PerlinNoise(octaves=12)
    noise4 = PerlinNoise(octaves=24)
    xpix, ypix = int(mapSize*100), int(mapSize*100)
    pic = []
    threshold = 0.3
    print("Generating map")
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
            row.append(noise_val)
        pic.append(row)
        if i%100==0:
            print(str(i/xpix*100) + "%")
    return pic

map = generateMap()

m = "map:"
for i in range(len(map)):
    for j in range(len(map[0])):
        if map[j][i] >= 0 and map[j][i] <= 9:
            m = m + "0" + str(map[j][i])
        else:
            m = m + str(map[j][i])

i = 4
count = 0
while i < len(m):
    if m[i] == "-":
        count+=1
    i+=2

print(len(m))
print(count)
print(str(count/(mapSize*mapSize*100*100)*100) + "%")
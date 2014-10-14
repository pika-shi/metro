#!/usr/local/bin/python
# -*- coding:utf-8 -*-
import json,math

def distance(point1,point2) :
    return math.sqrt( ( point1[0]-point2[0] )**2 + ( point1[1]-point2[1] )**2 )

    

if __name__ == "__main__" :
    f = open("./metroRosen.json",'r')
    rosens = json.loads(f.read())
    f.close()
    f = open("./stationgeo.json",'r')
    station2geo = json.loads(f.read())
    f.close()
    f = open("./metroRailway.json",'r')
    railways = json.loads(f.read())
    f.close()
    
    bet_stat_map = {}
    for ri in range(len(railways)) :
        stations = railways[ri]['odpt:travelTime']
        rosen = rosens[ri]['coordinates'][0]
        for station in stations :
            fromgeo = station2geo[ station['odpt:fromStation'] ]["coordinates"]
            togeo = station2geo[ station['odpt:toStation'] ]["coordinates"]
            
            from_nearest = -1
            from_min = float("inf")
            to_nearest = -1
            to_min = float("inf") 
            for rsi in range(len(rosen)) :
                if from_min > distance(fromgeo,rosen[rsi]) :
                    from_min = distance(fromgeo,rosen[rsi])
                    from_nearest = rsi
                if to_min > distance(togeo,rosen[rsi]) :
                    to_min = distance(togeo,rosen[rsi])
                    to_nearest = rsi
           
            #間の駅数
            #st_dist = math.abs(from_nearest,to_nearest)
            bet_time = station['odpt:necessaryTime']

            #mapの生成
            if from_nearest < to_nearest :
                bet_stat_map.update({ station['odpt:fromStation']:{station['odpt:toStation']:
                    {"odpt:necessaryTime":bet_time,"path":rosen[from_nearest:to_nearest]} 
                    }})
            if from_nearest > to_nearest :
                bet_stat_map.update({ station['odpt:toStation']:{station['odpt:fromStation']:
                    {"odpt:necessaryTime":bet_time,"path":rosen[to_nearest:from_nearest]} 
                    }})
    f = open('betstmap.json','w')
    f.write(json.dumps(bet_stat_map))
    f.close()



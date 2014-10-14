#!/usr/local/bin/python
# -*- coding:utf-8 -*-

import geohash
import json
import tools 

f = open("../../static/metrodata/stationgeo.json",'r')
stations = json.loads(f.read())
f.close()
w = open('../../static/metrodata/stationgeohash.json','w')

station_geohash = {}
for st_name in stations.keys() :
    coord = tools.Coordinate(stations[st_name]['coordinates']) 
    station_gh = geohash.encode(coord.lat,coord.lon)[:7]
    if (not station_geohash.has_key(station_gh)) :
        station_geohash[station_gh]=[]
    
    st_name_coord = {}
    st_name_coord['name']=st_name
    st_name_coord['coordinates']=stations[st_name]['coordinates']

    station_geohash[station_gh].append(st_name_coord)

w.write(json.dumps(station_geohash))
w.close()
    

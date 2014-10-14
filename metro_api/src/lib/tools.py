#!/usr/local/bin/python
#-*- coding:utf-8 -*-
import math
class Coordinate :
    def __init__(self,coordinate=[]) :
        if(coordinate):
            lon,lat = coordinate
            self.lon = lon
            self.lat = lat

    def distance(self,coordinate) :
        if( not hasattr(self,"lon") or not hasattr(self,"lat")) :
            print("You must set coordinate")
            raise Exception

        lon,lat = coordinate
        a = 6378137.0
        b = 6356752.314140
        dx = self.__deg2rad(self.lon-lon)
        dy = self.__deg2rad(self.lat-lat)
        my = self.__deg2rad( (self.lat+lat)/2 )
        e2 = (a**2-b**2)/(a**2)
        Mnum = a*(1-e2)
        W = math.sqrt(1-e2*math.sin(my)**2)
        M = Mnum/(W**3)
        N = a/W
        d = math.sqrt((dy*M)**2+(dx*N*math.cos(my))**2)
        return d

    def __deg2rad(self,x):
        return x*math.pi/180
    
    def set_getjson(self,geojson_obj) :
        self.lon = geojson_obj["coordinates"][0]
        self.lat = geojson_obj["coordinates"][1]

if __name__ == ('__main__') :
    import json
    coord = Coordinate([ 140.09111,36.10056 ])
    print coord.distance([ 139.74472,35.65500 ])
    coord.set_getjson(json.loads('{"type": "Point", "coordinates": [139.71944, 35.73074]}'))
    print coord.distance([ 139.74472,35.65500 ])

#-*- coding:utf-8 -*-

from django.shortcuts import render,render_to_response
from django.http import HttpResponse
from django.template import Context,loader,RequestContext
from redis_cache import get_redis_connection
from django.core.cache import cache
import json
from src.lib.tools import Coordinate
from src.lib import geohash

def k_nearest_train(request,coord):

    now_coord=Coordinate()
    if coord :
        now_coord.lat = float(coord.split(',')[0]) 
        now_coord.lon = float(coord.split(',')[1]) 
    else :
        now_coord.set_getjson(json.loads('{"type": "Point", "coordinates": [139.7262337, 35.6987467]}'))

    now_gh = geohash.encode(now_coord.lat,now_coord.lon)[:7]
    f = open('static/metrodata/stationgeohash.json','r')
    gh2stations = json.loads(f.read())
    f.close()

    neighbors_st = []
    neighbors_gh = set()
    if gh2stations.has_key(now_gh):
        neighbors_st.extend(gh2stations[now_gh])
    neighbors_gh.add(now_gh)
    for ii in range(10) :
        if len(neighbors_st) > 5 :break
        tmp_gh = list(neighbors_gh)
        for gh in tmp_gh :
            neighbors_gh = neighbors_gh.union(geohash.neighbors(gh))

        for gh in neighbors_gh :
            if gh2stations.has_key(gh):
                st_list = gh2stations[gh]
                for st in st_list :
                    sw = True
                    for nst in neighbors_st :
                        if st['name'] == nst['name'] :
                            sw = False

                    if sw :
                        neighbors_st.append(st)

            else :
                print("there is no station in "+str(gh))

        
    print("nearstation="+str(neighbors_st))
    resjson = HttpResponse(json.dumps(list(neighbors_st)))
    resjson['Access-Control-Allow-Origin']="localhost"
    resjson['Content-Type']="application/json;charset=utf-8"
    return resjson
    #return HttpResponse(render_to_response('index.html',{'title':'Nearest Trains'},context_instance=RequestContext(request)))

def redis_check(request):
    con = get_redis_connection('default')
    hashs = {'key1':'kfs','dfas':'dasf'}
    cache.set('key1',hashs)
    tmp= cache.get('key1')
    

    return HttpResponse(render_to_response('index.html',{'title':'redis','logs':[con,tmp]},context_instance=RequestContext(request)))
# 動いている電車の車両番号と、位置情報をjsonで返す
def metro_now(request) :
    import json,conf,urllib,urllib2

    # キーを駅名として、駅のgeojsonを取得するhashマップを生成
    filename = "static/metrodata/stationgeo.json"
    f = open(filename,'r')
    station2geo=json.loads(f.read())
    f.close()
    f = open("static/metrodata/betstmap.json")
    betstmap=json.loads(f.read())
    # APIをたたいて駅情報を取得
    data = {}
    data['acl:consumerKey']=conf.token
    data['rdf:type']="odpt:Train"
    urls = "%s?%s" % (conf.data_url,urllib.urlencode(data))

    trainlist = json.loads(urllib2.urlopen(urllib2.Request(urls)).read())
    trainnum = []
    geojson = []
    for train in trainlist :
        fromst = station2geo[train['odpt:fromStation']]
        if train['odpt:toStation'] is not None :
            tost = station2geo[train['odpt:toStation']]
            nowpt = [(fromst['coordinates'][0]+tost['coordinates'][0])/2,
                    (fromst['coordinates'][1]+tost['coordinates'][1])/2]
            fromst['coordinates']=nowpt
            try :
                numSt = len(betstmap[train['odpt:fromStation']][train['odpt:toStation']]['path'])
                stList = betstmap[train['odpt:fromStation']][train['odpt:toStation']]['path']
            except KeyError :
                print("from:%s,to:%s" %(train['odpt:fromStation'],train['odpt:toStation']))
            ##stTime = betstmap[train['odpt:fromStation']][train['odpt:toStation']]['odpt:necessaryTime']
            fromst['coordinates']=stList[int(numSt/2)]
            trainnum.append(train['owl:sameAs'].split(".")[3])
            geojson.append(fromst)
        else :
            pass

    resjson = HttpResponse(json.dumps([trainnum,geojson]),mimetype='application/json')
    resjson['Access-Control-Allow-Origin']="localhost"
    resjson['Content-Type']="application/json;charset=utf-8"

    #filename = "static/metrodata/trainrun.json"
    #f = open(filename,'w')
    #f.write(urllib2.urlopen(urllib2.Request(urls)).read())
    #f.close
    #resjson = HttpResponse("Download OK")

    return resjson

